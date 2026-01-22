import UIKit
import Core

class NoteListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var editedDateLabel: UILabel!
    
    func configure(with noteModel: NoteModel) {
        nameLabel.text = noteModel.name
        
        let dateFormatter = NoteDateFormatter()
        createdDateLabel.text = dateFormatter.createdDate(from: noteModel.createdDate)
        if let editedDate = noteModel.editedDate {
            editedDateLabel.isHidden = false
            editedDateLabel.text = dateFormatter.updatedDate(from: editedDate)
        } else {
            editedDateLabel.isHidden = true
        }
    }
}
