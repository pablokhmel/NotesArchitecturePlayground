import UIKit
import Core

protocol NoteManaging {
    func saveNote(_ note: NoteModel) async
    func updateNote(_ note: NoteModel) async
}

private struct DefaultNoteManager: NoteManaging {
    func saveNote(_ note: NoteModel) async {
        await NoteManager.saveNote(note)
    }
    func updateNote(_ note: NoteModel) async {
        await NoteManager.updateNote(note)
    }
}

class NoteEditorViewController: UIViewController {
    public enum NoteEditorMode {
        case add
        case edit(NoteModel)
    }

    static var noteManager: NoteManaging = DefaultNoteManager()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    weak var delegate: NoteEditorDelegate?
    var mode: NoteEditorMode = .add {
        didSet {
            if isViewLoaded {
                configureForMode()
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        LoadingView.startLoading(on: self) { [weak self] in
            guard let self else { return }
            try self.validateTextFields()
            
            switch mode {
            case .add:
                let noteModel = NoteModel(
                    name: self.nameTextField.text!,
                    text: self.noteTextView.text!,
                    createdDate: Date()
                )

                await Self.noteManager.saveNote(noteModel)
                delegate?.createdNote(noteModel)
            case .edit(var noteModel):
                noteModel.name = self.nameTextField.text!
                noteModel.text = self.noteTextView.text!
                noteModel.editedDate = Date()
                
                await Self.noteManager.updateNote(noteModel)
                delegate?.editedNote(noteModel)
            }
            
            await MainActor.run {
                self.navigationController?.popViewController(animated: true)
            }
        } onError: { [weak self] error in
            guard let error = error as? ValidationError else {
                return
            }
            
            self?.showErrorAlert(for: error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForMode()
    }

    private func configureForMode() {
        switch mode {
        case .add:
            navigationItem.title = "New Note"
            nameTextField.text = ""
            noteTextView.text = ""
        case .edit(let noteModel):
            navigationItem.title = noteModel.name
            nameTextField.text = noteModel.name
            noteTextView.text = noteModel.text
        }
    }
    
    private func validateTextFields() throws {
        try validateName()
        try validateNote()
    }
    
    private func validateName() throws {
        let minLength = 3
        guard let name = trimmed(nameTextField.text), !name.isEmpty else {
            throw ValidationError.nameEmpty
        }
        
        nameTextField.text = name
        
        guard name.count >= minLength else {
            throw ValidationError.nameTooShort(min: minLength)
        }
    }
    
    private func validateNote() throws {
        let minLength = 5
        guard let note = trimmed(noteTextView.text), !note.isEmpty else {
            throw ValidationError.noteEmpty
        }
        
        noteTextView.text = note
        
        guard note.count >= minLength else {
            throw ValidationError.noteTooShort(min: minLength)
        }
    }
    
    
    private func showErrorAlert(for error: ValidationError) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func trimmed(_ text: String?) -> String? {
        text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
