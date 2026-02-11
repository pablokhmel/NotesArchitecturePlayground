import XCTest
@testable import NotesMVC
import Core
import UIKit

final class NoteListViewControllerTests: XCTestCase {
    private let tableView = UITableView()
    private let cellIdentifier = "NoteCell"

    private func makeController() -> NoteListViewController {
        let vc = NoteListViewController()
        vc.loadViewIfNeeded()
        vc.tableView.register(NoteListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return vc
    }

    private final class MockManager {
        static var fetchResult: [NoteModel] = []
        static var deleteCalledWith: UUID?

        static func reset() {
            fetchResult = []
            deleteCalledWith = nil
        }
    }

    func testInitialState() {
        let vc = makeController()
        XCTAssertTrue(vc.notes.isEmpty)
        XCTAssertEqual(vc.numberOfSections(in: vc.tableView), 1)
    }

    @MainActor
    func testFetchNotesOnViewDidLoadPopulatesNotes() async {
        let created = Date(timeIntervalSince1970: 1_600_000_000)
        let note = NoteModel(name: "A", text: "B", createdDate: created)
        MockManager.fetchResult = [note]

        let prevFetch = NoteListViewController.fetchNotesHandler
        NoteListViewController.fetchNotesHandler = { MockManager.fetchResult }
        defer { NoteListViewController.fetchNotesHandler = prevFetch }

        let vc = makeController()

        await vc.performFetch()

        XCTAssertEqual(vc.notes.count, 1)
        XCTAssertEqual(vc.notes.first?.id, note.id)
    }

    func testPrepareForAddNoteSetsDelegate() {
        let vc = makeController()
        let editor = NoteEditorViewController()

        let segue = UIStoryboardSegue(identifier: "AddNote", source: vc, destination: editor)
        vc.prepare(for: segue, sender: nil)

        XCTAssertNotNil(editor.delegate)
    }

    func testSwipeActionsConfiguration() {
        let vc = makeController()
        vc.notes = [NoteModel(name: "S", text: "s", createdDate: Date())]

        let config = vc.tableView(vc.tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(config)
    }

    func testEditedNoteUpdatesAndSorts() {
        let created = Date(timeIntervalSince1970: 1_600_000_000)
        var note1 = NoteModel(name: "One", text: "a", createdDate: created)
        let note2 = NoteModel(name: "Two", text: "b", createdDate: created)
        let vc = makeController()
        vc.notes = [note1, note2]

        note1.text = "updated"
        note1.editedDate = Date(timeIntervalSince1970: 1_700_000_000)
        vc.editedNote(note1)

        XCTAssertEqual(vc.notes.first?.id, note1.id)
    }

    func testCreatedNoteAddsAndSorts() {
        let created = Date(timeIntervalSince1970: 1_600_000_000)
        let note1 = NoteModel(name: "One", text: "a", createdDate: created)
        let vc = makeController()
        vc.notes = [note1]

        let newNote = NoteModel(name: "New", text: "n", createdDate: Date(), editedDate: Date(timeIntervalSince1970: 1_800_000_000))
        vc.createdNote(newNote)

        XCTAssertEqual(vc.notes.first?.id, newNote.id)
    }
}
