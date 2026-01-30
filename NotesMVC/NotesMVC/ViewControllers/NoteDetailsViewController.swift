import UIKit
import Core

class NoteDetailsViewController: UIViewController {
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var editedDateLabel: UILabel!
    
    private var noteModel: NoteModel?
    weak var delegate: NoteEditorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configure()
    }
    
    public func setModel(_ model: NoteModel) {
        self.noteModel = model
        
        if isViewLoaded {
            configure()
        }
    }
    
    private func configure() {
        guard let noteModel else {
            navigationItem.title = nil
            noteTextLabel.text = nil
            createdDateLabel.text = nil
            editedDateLabel.isHidden = true
            editedDateLabel.text = nil
            return
        }
        navigationItem.title = noteModel.name
        noteTextLabel.text = noteModel.text
        let dateFormatter = NoteDateFormatter()
        createdDateLabel.text = dateFormatter.createdDate(from: noteModel.createdDate)
        if let editedDate = noteModel.editedDate {
            editedDateLabel.isHidden = false
            editedDateLabel.text = dateFormatter.updatedDate(from: editedDate)
        } else {
            editedDateLabel.isHidden = true
            editedDateLabel.text = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNote" {
            guard let model = noteModel else { return }
            let editorViewController = segue.destination as! NoteEditorViewController
            editorViewController.mode = .edit(model)
            editorViewController.delegate = self
        }
    }
}

extension NoteDetailsViewController: NoteEditorDelegate {
    func editedNote(_ note: NoteModel) {
        delegate?.editedNote(note)
        setModel(note)
    }
}
