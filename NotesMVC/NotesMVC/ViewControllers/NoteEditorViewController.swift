import UIKit
import Core

class NoteEditorViewController: UIViewController {
    private enum ValidationError: Error {
        case nameEmpty
        case nameTooShort(min: Int)
        case noteEmpty
        case noteTooShort(min: Int)
        
        var message: String {
            switch self {
            case .nameEmpty:
                return "Name cannot be empty"
            case .nameTooShort(let min):
                return "Name must be at least \(min) characters"
            case .noteEmpty:
                return "Note cannot be empty"
            case .noteTooShort(let min):
                return "Note must be at least \(min) characters"
            }
        }
    }
    
    public enum NoteEditorMode {
        case add
        case edit(NoteModel)
    }
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var mode: NoteEditorMode = .add {
        didSet {
            if isViewLoaded {
                configureForMode()
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        startActivity { [weak self] in
            guard let self else { return }
            try self.validateTextFields()
            
            switch mode {
            case .add:
                let noteModel = NoteModel(
                    name: self.nameTextField.text!,
                    text: self.noteTextView.text!,
                    createdDate: Date()
                )

                NoteManager.saveNote(noteModel)
            case .edit(var noteModel):
                noteModel.name = self.nameTextField.text!
                noteModel.text = self.noteTextView.text!
                
                NoteManager.updateNote(noteModel)
            }
            
            await MainActor.run {
                self.navigationController?.popViewController(animated: true)
            }
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
    
    private func startActivity(action: @escaping () async throws -> Void) {
        self.loadingView.alpha = 0
        self.loadingView.isHidden = false
        UIView.animate(withDuration: 0.1) {
            self.loadingView.alpha = 1
        }
        
        Task {
            do {
                try await action()
                
                await MainActor.run {
                    self.loadingView.isHidden = true
                }
            } catch let validationError as ValidationError {
                await MainActor.run {
                    loadingView.isHidden = true
                    showErrorAlert(for: validationError)
                }
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    private func trimmed(_ text: String?) -> String? {
        text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
