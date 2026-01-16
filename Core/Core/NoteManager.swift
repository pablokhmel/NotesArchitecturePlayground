import Foundation

public class NoteManager {
    public static func fetchNotes() -> [NoteModel] {
        return [
            NoteModel(name: "Note", createdDate: Date(), editedDate: Date()),
            NoteModel(name: "Note", createdDate: Date(), editedDate: nil),
            NoteModel(name: "Note", createdDate: Date(), editedDate: Date())
        ]
    }
}
