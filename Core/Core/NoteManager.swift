import Foundation

public class NoteManager {
    public static func fetchNotes() -> [NoteModel] {
        return [
            NoteModel(name: "Note 1", createdDate: Date(), editedDate: Date()),
            NoteModel(name: "Note 2", createdDate: Date(), editedDate: nil),
            NoteModel(name: "Note 3", createdDate: Date(), editedDate: Date())
        ]
    }
}
