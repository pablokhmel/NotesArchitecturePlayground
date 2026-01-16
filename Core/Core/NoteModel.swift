import Foundation

public struct NoteModel {
    public let name: String
    public let createdDate: Date
    public let editedDate: Date?

    public init(name: String, createdDate: Date, editedDate: Date?) {
        self.name = name
        self.createdDate = createdDate
        self.editedDate = editedDate
    }
}
