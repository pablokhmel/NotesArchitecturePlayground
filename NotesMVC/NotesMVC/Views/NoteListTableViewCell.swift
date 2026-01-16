import UIKit
import Core

class NoteListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var editedDateLabel: UILabel!
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    func configure(with noteModel: NoteModel) {
        nameLabel.text = noteModel.name
        
        let dateFormat = NoteListTableViewCell.dateFormatter
        createdDateLabel.text = "Created: " + dateFormat.string(from: noteModel.createdDate)
        if let editedDate = noteModel.editedDate {
            editedDateLabel.isHidden = false
            editedDateLabel.text = "Edited: " + dateFormat.string(from: editedDate)
        } else {
            editedDateLabel.isHidden = true
        }
    }
}
