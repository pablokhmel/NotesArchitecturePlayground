import Foundation

public struct NoteModel {
    public let name: String
    public let text: String
    public let createdDate: Date
    public let editedDate: Date?

    public init(
        name: String,
        text: String,
        createdDate: Date,
        editedDate: Date?
    ) {
        self.name = name
        self.text = text
        self.createdDate = createdDate
        self.editedDate = editedDate
    }
}
