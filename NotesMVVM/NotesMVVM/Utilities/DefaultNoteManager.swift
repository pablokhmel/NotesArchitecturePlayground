import Core
import Foundation

public protocol NoteManaging {
    func fetchNotes() async -> [NoteModel]
    func saveNote(_ note: NoteModel) async
    func updateNote(_ note: NoteModel) async
    func deleteNote(id: UUID) async
}

public struct DefaultNoteManager: NoteManaging {
    public init() {}
    public func fetchNotes() async -> [NoteModel] {
        await NoteManager.fetchNotes()
    }
    public func saveNote(_ note: NoteModel) async {
        await NoteManager.saveNote(note)
    }
    public func updateNote(_ note: NoteModel) async {
        await NoteManager.updateNote(note)
    }
    public func deleteNote(id: UUID) async {
        await NoteManager.deleteNote(id: id)
    }
}
