import XCTest
@testable import NotesMVC
import Core
import UIKit

final class NoteDetailsViewControllerTests: XCTestCase {
    private let noteTextLabel = UILabel()
    private let createdDateLabel = UILabel()
    private let editedDateLabel = UILabel()

    private func makeController() -> NoteDetailsViewController {
        let vc = NoteDetailsViewController()
        vc.noteTextLabel = noteTextLabel
        vc.createdDateLabel = createdDateLabel
        vc.editedDateLabel = editedDateLabel
        return vc
    }

    func testSetModelBeforeViewLoadsIsStoredAndAppliedOnLoad() {
        let vc = makeController()
        let note = NoteModel(name: "Title A", text: "Text A", createdDate: Date(timeIntervalSince1970: 1_600_000_000), editedDate: nil)

        vc.setModel(note)
        vc.loadViewIfNeeded()

        XCTAssertEqual(vc.navigationItem.title, "Title A")
        XCTAssertEqual(vc.noteTextLabel.text, "Text A")
        let expectedCreated = NoteDateFormatter().createdDate(from: note.createdDate)
        XCTAssertEqual(vc.createdDateLabel.text, expectedCreated)
        XCTAssertTrue(vc.editedDateLabel.isHidden)
    }

    func testSetModelAfterViewLoadsTriggersConfigurationImmediately() {
        let vc = makeController()
        vc.loadViewIfNeeded()

        let note = NoteModel(name: "Title B", text: "Text B", createdDate: Date(timeIntervalSince1970: 1_610_000_000), editedDate: Date(timeIntervalSince1970: 1_610_100_000))

        vc.setModel(note)

        XCTAssertEqual(vc.navigationItem.title, "Title B")
        XCTAssertEqual(vc.noteTextLabel.text, "Text B")
        let expectedCreated = NoteDateFormatter().createdDate(from: note.createdDate)
        let expectedEdited = NoteDateFormatter().updatedDate(from: note.editedDate!)
        XCTAssertEqual(vc.createdDateLabel.text, expectedCreated)
        XCTAssertFalse(vc.editedDateLabel.isHidden)
        XCTAssertEqual(vc.editedDateLabel.text, expectedEdited)
    }

    func testConfigureHandlesNilModelGracefully() {
        let vc = makeController()
        vc.loadViewIfNeeded()

        XCTAssertNil(vc.noteTextLabel.text)
        XCTAssertNil(vc.createdDateLabel.text)
        _ = vc.editedDateLabel.isHidden
    }

    func testViewLifecycleConfigureCalledOnViewDidLoadAndViewWillAppearEffectsObserved() {
        let vc = makeController()
        let note = NoteModel(name: "Lifecycle", text: "Life", createdDate: Date(timeIntervalSince1970: 1_600_200_000), editedDate: nil)

        vc.setModel(note)
        vc.loadViewIfNeeded()

        XCTAssertEqual(vc.navigationItem.title, "Lifecycle")

        let updatedNote = NoteModel(name: "Lifecycle2", text: "Life2", createdDate: note.createdDate, editedDate: nil)
        vc.setModel(updatedNote)
        vc.beginAppearanceTransition(true, animated: false)
        vc.endAppearanceTransition()

        XCTAssertEqual(vc.navigationItem.title, "Lifecycle2")
    }

    func testPrepareForSegueEditNoteSetsEditorModeAndDelegate() {
        let vc = makeController()
        let note = NoteModel(name: "SegueNote", text: "SText", createdDate: Date(), editedDate: nil)

        vc.setModel(note)
        vc.loadViewIfNeeded()

        let editor = NoteEditorViewController()
        let segue = UIStoryboardSegue(identifier: "EditNote", source: vc, destination: editor)

        vc.prepare(for: segue, sender: nil)

        switch editor.mode {
        case .edit(let model):
            XCTAssertEqual(model.name, note.name)
            XCTAssertEqual(model.text, note.text)
        default:
            XCTFail("Editor mode should be .edit")
        }

        XCTAssertTrue(editor.delegate === vc, "Editor delegate should be set to the details VC")
    }

    func testEditedNotePropagatesToParentDelegateAndUpdatesUI() {
        let vc = makeController()
        let initial = NoteModel(name: "Initial", text: "I", createdDate: Date(timeIntervalSince1970: 1_600_000_000), editedDate: nil)

        let parent = MockEditorParentDelegate()
        vc.setModel(initial)
        vc.loadViewIfNeeded()
        vc.delegate = parent

        let edited = NoteModel(name: "Edited", text: "E", createdDate: initial.createdDate, editedDate: Date())

        (vc as NoteEditorDelegate).editedNote(edited)

        XCTAssertEqual(parent.lastEdited?.name, "Edited")
        XCTAssertEqual(parent.lastEdited?.text, "E")

        XCTAssertEqual(vc.navigationItem.title, "Edited")
        XCTAssertEqual(vc.noteTextLabel.text, "E")
        XCTAssertFalse(vc.editedDateLabel.isHidden)
    }
}

private final class MockEditorParentDelegate: NoteEditorDelegate {
    var lastEdited: NoteModel?
    var lastCreated: NoteModel?

    func editedNote(_ note: NoteModel) {
        lastEdited = note
    }

    func createdNote(_ note: NoteModel) {
        lastCreated = note
    }
}
