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
        
        LoadingView.startLoading(on: self) { [weak self] in
            self?.notes = await NoteManager.fetchNotes()
        }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNoteDetail",
           let detailVC = segue.destination as? NoteDetailsViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {

            let model = notes[indexPath.row]
            detailVC.setModel(model)
            detailVC.delegate = self
        }
        
        if segue.identifier == "AddNote" {
            let editorVC = segue.destination as! NoteEditorViewController
            editorVC.delegate = self
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completion in
            self?.deleteNote(at: indexPath)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func deleteNote(at indexPath: IndexPath) {
        let note = notes[indexPath.row]

        notes.remove(at: indexPath.row)

        Task {
            await NoteManager.deleteNote(id: note.id)
        }
    }
}

extension NoteListViewController: NoteEditorDelegate {
    func editedNote(_ note: NoteModel) {
        guard let indexToReplace = notes
            .firstIndex(where: { $0.id == note.id }) else {return}

        notes[indexToReplace] = note
        notes.sort { firstNote, secondNote in
            let firstDate = firstNote.editedDate ?? firstNote.createdDate
            let secondDate = secondNote.editedDate ?? secondNote.createdDate
            return firstDate > secondDate
        }
    }
    
    func createdNote(_ note: NoteModel) {
        notes.append(note)
        notes.sort { firstNote, secondNote in
            let firstDate = firstNote.editedDate ?? firstNote.createdDate
            let secondDate = secondNote.editedDate ?? secondNote.createdDate
            return firstDate > secondDate
        }
    }
}
