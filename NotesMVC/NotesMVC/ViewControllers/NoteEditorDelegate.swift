import Core

protocol NoteEditorDelegate: AnyObject {
    func editedNote(_ note: NoteModel)
    func createdNote(_ note: NoteModel)
}

extension NoteEditorDelegate {
    func editedNote(_ note: NoteModel) {
        
    }
    
    func createdNote(_ note: NoteModel) {
        
    }
}
