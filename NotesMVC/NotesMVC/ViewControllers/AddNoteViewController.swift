import UIKit
import Core

class AddNoteViewController: UIViewController {
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

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        startActivity { [weak self] in
            guard let self else { return }
            try self.validateTextFields()
            
            if
                let name = nameTextField.text,
                let note = noteTextView.text
            {
                let noteModel = NoteModel(
                    name: name,
                    text: note,
                    createdDate: Date()
                )
                
                NoteManager.saveNote(noteModel)
            }
            
            await MainActor.run {
                self.navigationController?.popViewController(animated: true)
            }
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
            } catch let validationError as ValidationError {
                await MainActor.run {
                    loadingView.isHidden = true
                    showErrorAlert(for: validationError)
                }
            } catch {
                print(String(describing: error))
            }
            
            await MainActor.run {
                self.loadingView.isHidden = true
            }
        }
    }
    
    private func trimmed(_ text: String?) -> String? {
        text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
