import XCTest
import Core
import UIKit

@testable import NotesMVC

final class NoteEditorViewControllerTests: XCTestCase {
    private static var retainedNav: UINavigationController?

    private func makeEditorInNav(withPrevious prev: UIViewController = UIViewController()) -> NoteEditorViewController {
        let editor = NoteEditorViewController()
        let nameTextField = UITextField()
        let noteTextView = UITextView()
        editor.nameTextField = nameTextField
        editor.noteTextView = noteTextView

        let nav = UINavigationController(rootViewController: prev)
        nav.pushViewController(editor, animated: false)
        _ = nav.view
        Self.retainedNav = nav
        return editor
    }

    private final class MockNoteManager: NoteManaging {
        var savedNote: NoteModel?
        var updatedNote: NoteModel?
        var saveExpectation: XCTestExpectation?
        var updateExpectation: XCTestExpectation?

        func saveNote(_ note: NoteModel) async {
            savedNote = note
            saveExpectation?.fulfill()
        }
        func updateNote(_ note: NoteModel) async {
            updatedNote = note
            updateExpectation?.fulfill()
        }
    }

    private final class MockDelegate: NoteEditorDelegate {
        var lastCreated: NoteModel?
        var lastEdited: NoteModel?
        func createdNote(_ note: NoteModel) { lastCreated = note }
        func editedNote(_ note: NoteModel) { lastEdited = note }
    }

    func testAddModeConfiguresUI() {
        let editor = makeEditorInNav()
        editor.mode = .add
        editor.loadViewIfNeeded()

        XCTAssertEqual(editor.navigationItem.title, "New Note")
        XCTAssertEqual(editor.nameTextField.text, "")
        XCTAssertEqual(editor.noteTextView.text, "")
    }

    func testEditModePopulatesFields() {
        let note = NoteModel(name: "N", text: "T", createdDate: Date())
        let editor = makeEditorInNav()
        editor.mode = .edit(note)
        editor.loadViewIfNeeded()

        XCTAssertEqual(editor.navigationItem.title, "N")
        XCTAssertEqual(editor.nameTextField.text, "N")
        XCTAssertEqual(editor.noteTextView.text, "T")
    }

    func testModeChangeUpdatesUI() {
        let editor = makeEditorInNav()
        editor.loadViewIfNeeded()

        editor.mode = .add
        XCTAssertEqual(editor.navigationItem.title, "New Note")

        let note = NoteModel(name: "X", text: "Y", createdDate: Date())
        editor.mode = .edit(note)
        XCTAssertEqual(editor.navigationItem.title, "X")
    }

    func testNameValidationAndTrimming() {
        let editor = makeEditorInNav()
        editor.loadViewIfNeeded()
        let prevManager = NoteEditorViewController.noteManager
        defer { NoteEditorViewController.noteManager = prevManager }

        let mockManager = MockNoteManager()
        NoteEditorViewController.noteManager = mockManager

        editor.nameTextField.text = ""
        editor.noteTextView.text = "Valid text"
        let notCalled = expectation(description: "save not called for empty name")
        notCalled.isInverted = true
        mockManager.saveExpectation = notCalled

        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [notCalled], timeout: 0.3)

        editor.nameTextField.text = "   "
        editor.noteTextView.text = "Valid text"
        let notCalled2 = expectation(description: "save not called for whitespace name")
        notCalled2.isInverted = true
        mockManager.saveExpectation = notCalled2

        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [notCalled2], timeout: 0.3)

        editor.nameTextField.text = "ab"
        editor.noteTextView.text = "Valid text"
        let notCalled3 = expectation(description: "save not called for short name")
        notCalled3.isInverted = true
        mockManager.saveExpectation = notCalled3

        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [notCalled3], timeout: 0.3)

        editor.nameTextField.text = "  abc  "
        editor.noteTextView.text = "Valid text"
        let saveExp = expectation(description: "save called after trimming")
        mockManager.saveExpectation = saveExp

        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [saveExp], timeout: 2.0)

        XCTAssertEqual(mockManager.savedNote?.name, "abc")
    }

    func testNoteValidationAndTrimming() {
        let editor = makeEditorInNav()
        editor.loadViewIfNeeded()
        let prevManager = NoteEditorViewController.noteManager
        defer { NoteEditorViewController.noteManager = prevManager }

        let mockManager = MockNoteManager()
        NoteEditorViewController.noteManager = mockManager

        editor.nameTextField.text = "Valid Name"

        editor.noteTextView.text = ""
        let notCalled = expectation(description: "save not called for empty note")
        notCalled.isInverted = true
        mockManager.saveExpectation = notCalled
        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [notCalled], timeout: 0.3)

        editor.noteTextView.text = "   "
        let notCalled2 = expectation(description: "save not called for whitespace note")
        notCalled2.isInverted = true
        mockManager.saveExpectation = notCalled2
        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [notCalled2], timeout: 0.3)

        editor.noteTextView.text = "abcd"
        let notCalled3 = expectation(description: "save not called for short note")
        notCalled3.isInverted = true
        mockManager.saveExpectation = notCalled3
        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [notCalled3], timeout: 0.3)

        editor.noteTextView.text = "  valid body  "
        let saveExp = expectation(description: "save called after trimming note")
        mockManager.saveExpectation = saveExp
        editor.saveButtonPressed(UIBarButtonItem())
        wait(for: [saveExp], timeout: 2.0)

        XCTAssertEqual(mockManager.savedNote?.text, "valid body")
    }
}
