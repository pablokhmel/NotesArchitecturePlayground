import UIKit
import Core

class NoteDetailsViewController: UIViewController {
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var editedDateLabel: UILabel!
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private var noteModel: NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    public func setModel(_ model: NoteModel) {
        self.noteModel = model
        
        if isViewLoaded {
            configure()
        }
    }
    
    private func configure() {
        guard let noteModel else { return }
        navigationItem.title = noteModel.name
        noteTextLabel.text = noteModel.text
        let dateFormatter = NoteDetailsViewController.dateFormatter
        createdDateLabel.text = "Created: " + dateFormatter.string(from: noteModel.createdDate)
        if let editedDate = noteModel.editedDate {
            editedDateLabel.isHidden = false
            editedDateLabel.text = "Edited: " + dateFormatter.string(from: editedDate)
        } else {
            editedDateLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNote" {
            let navigationController = segue.destination as! NoteEditorViewController
            navigationController.mode = .edit(noteModel!)
        }
    }
}
