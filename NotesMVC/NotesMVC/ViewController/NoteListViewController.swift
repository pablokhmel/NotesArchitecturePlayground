import UIKit
import Core

class NoteListViewController: UITableViewController {
    
    var notes: [NoteModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = NoteManager.fetchNotes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as? NoteListTableViewCell else {
            fatalError("Failed to dequeue NoteListTableViewCell with identifier NoteCell")
        }
        
        cell.selectionStyle = .none
        let noteModel = notes[indexPath.row]
        cell.configure(with: noteModel)

        return cell
    }
}
