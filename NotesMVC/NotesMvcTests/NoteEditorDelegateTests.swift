import XCTest
@testable import NotesMVC
import Core

final class NoteEditorDelegateTests: XCTestCase {

    func testMethodsCallable() {
        final class DefaultMock: NoteEditorDelegate {}

        let mock = DefaultMock()
        let note = NoteModel(name: "Test", text: "Body", createdDate: Date())

        mock.editedNote(note)
        mock.createdNote(note)

        XCTAssertTrue(true)
    }

    func testCanOverrideBothMethods() {
        final class OverrideMock: NoteEditorDelegate {
            var editedCalled = false
            var createdCalled = false

            func editedNote(_ note: NoteModel) {
                editedCalled = true
            }

            func createdNote(_ note: NoteModel) {
                createdCalled = true
            }
        }

        let mock = OverrideMock()
        let note = NoteModel(name: "X", text: "Y", createdDate: Date())

        mock.editedNote(note)
        mock.createdNote(note)

        XCTAssertTrue(mock.editedCalled, "Overriding editedNote(_:) should be called")
        XCTAssertTrue(mock.createdCalled, "Overriding createdNote(_:) should be called")
    }

    func testCanOverrideSingleMethod() {
        final class PartialOverrideMock: NoteEditorDelegate {
            var editedCalled = false

            func editedNote(_ note: NoteModel) {
                editedCalled = true
            }
        }

        let mock = PartialOverrideMock()
        let note = NoteModel(name: "A", text: "B", createdDate: Date())

        mock.editedNote(note)
        mock.createdNote(note)

        XCTAssertTrue(mock.editedCalled, "Overridden editedNote(_:) should be called")
    }
}
