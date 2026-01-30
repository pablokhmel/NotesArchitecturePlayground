import XCTest
@testable import NotesMVC
import Core
import UIKit

final class NoteListTableViewCellTests: XCTestCase {
    let nameLabel = UILabel()
    let createDateLabel = UILabel()
    let editedDateLabel = UILabel()

    private func makeCell() -> NoteListTableViewCell {
        let cell = NoteListTableViewCell()
        cell.nameLabel = nameLabel
        cell.createdDateLabel = createDateLabel
        cell.editedDateLabel = editedDateLabel
        return cell
    }

    func testConfigureWithFullNoteSetsLabelsAndShowsEditedDate() {
        let created = Date(timeIntervalSince1970: 1_600_000_000)
        let edited = Date(timeIntervalSince1970: 1_600_100_000)
        let note = NoteModel(name: "My Note", text: "Body", createdDate: created, editedDate: edited)

        let cell = makeCell()

        cell.configure(with: note)
        
        XCTAssertEqual(cell.nameLabel.text, "My Note")

        let formatter = NoteDateFormatter()
        let expectedCreated = formatter.createdDate(from: created)
        XCTAssertEqual(cell.createdDateLabel.text, expectedCreated)

        XCTAssertFalse(cell.editedDateLabel.isHidden, "editedDateLabel should be visible when editedDate exists")
        let expectedEdited = formatter.updatedDate(from: edited)
        XCTAssertEqual(cell.editedDateLabel.text, expectedEdited)
    }

    func testConfigureWithoutEditedDateHidesEditedLabel() {
        let created = Date(timeIntervalSince1970: 1_700_000_000)
        let note = NoteModel(name: "No Edit", text: "Body", createdDate: created, editedDate: nil)

        let cell = makeCell()

        cell.configure(with: note)
        
        XCTAssertEqual(cell.nameLabel.text, "No Edit")

        let formatter = NoteDateFormatter()
        let expectedCreated = formatter.createdDate(from: created)
        XCTAssertEqual(cell.createdDateLabel.text, expectedCreated)

        XCTAssertTrue(cell.editedDateLabel.isHidden, "editedDateLabel should be hidden when editedDate is nil")
    }

    func testDateFormattingMatchesNoteDateFormatterOutput() {
        let created = Date(timeIntervalSince1970: 1_600_500_000)
        let edited = Date(timeIntervalSince1970: 1_600_600_000)
        let note = NoteModel(name: "Date Test", text: "Body", createdDate: created, editedDate: edited)

        let cell = makeCell()

        RunLoop.main.run(until: Date())
        cell.configure(with: note)

        let formatter = NoteDateFormatter()
        let createdText = cell.createdDateLabel.text
        let editedText = cell.editedDateLabel.text

        XCTAssertEqual(createdText, formatter.createdDate(from: created))
        XCTAssertEqual(editedText, formatter.updatedDate(from: edited))

        let createdPattern = "^Created: \\d{2}\\.\\d{2}\\.\\d{4}, \\d{2}:\\d{2}$"
        let updatedPattern = "^Updated: \\d{2}\\.\\d{2}\\.\\d{4}, \\d{2}:\\d{2}$"

        XCTAssertNotNil(createdText?.range(of: createdPattern, options: .regularExpression), "Created text should match pattern 'Created: dd.MM.yyyy, hh:mm' - got: \(createdText ?? "nil")")
        XCTAssertNotNil(editedText?.range(of: updatedPattern, options: .regularExpression), "Updated text should match pattern 'Updated: dd.MM.yyyy, hh:mm' - got: \(editedText ?? "nil")")
    }
}
