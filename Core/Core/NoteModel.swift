import Foundation

public struct NoteModel {
    public var name: String
    public var text: String
    public let createdDate: Date
    public var editedDate: Date?

    public init(
        name: String,
        text: String,
        createdDate: Date,
        editedDate: Date? = nil
    ) {
        self.name = name
        self.text = text
        self.createdDate = createdDate
        self.editedDate = editedDate
    }
}
