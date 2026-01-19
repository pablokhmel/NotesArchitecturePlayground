import Foundation

public class NoteManager {
    public static func fetchNotes() -> [NoteModel] {
        return [
            NoteModel(
                name: "Note 1",
                text: "Blah-blah-blah 1",
                createdDate: Date(),
                editedDate: Date()),
            NoteModel(
                name: "Note 2",
                text: "Blah-blah-blah 2",
                createdDate: Date(),
                editedDate: nil),
            NoteModel(
                name: "Note 3",
                text: "Blah-blah-blah 3",
                createdDate: Date(),
                editedDate: Date())
        ]
    }
}
