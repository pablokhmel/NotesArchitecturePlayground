import UIKit
import Core

class NotesListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var editedDateLabel: UILabel!
    
    func configure(with noteModel: NoteModel) {
        nameLabel.text = noteModel.name
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.yyyy"
        createdDateLabel.text = "Created: " + dateFormat.string(from: noteModel.createdDate)
        if let editedDate = noteModel.editedDate {
            editedDateLabel.isHidden = false
            editedDateLabel.text = "Edited: " + dateFormat.string(from: editedDate)
        } else {
            editedDateLabel.isHidden = true
        }
    }
}
