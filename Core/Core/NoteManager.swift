import Foundation

@MainActor
public class NoteManager {

    private static let notesKey = "saved_notes"
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    /// Simulated network delay (in nanoseconds)
    private static let apiDelay: UInt64 = 500_000_000

    // MARK: - Fetch

    public static func fetchNotes() async -> [NoteModel] {
        await simulateDelay()

        guard
            let data = UserDefaults.standard.data(forKey: notesKey),
            let notes = try? decoder.decode([NoteModel].self, from: data)
        else {
            return []
        }

        return notes
    }

    // MARK: - Save

    public static func saveNote(_ note: NoteModel) async {
        await simulateDelay()

        var notes = await fetchNotes()
        notes.append(note)
        saveAll(notes)
    }

    // MARK: - Update

    public static func updateNote(_ note: NoteModel) async {
        await simulateDelay()

        var notes = await fetchNotes()

        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            return
        }

        notes[index] = note
        saveAll(notes)
    }
    
    // MARK: - Get
    
    public static func getNote(id: UUID) async -> NoteModel? {
        await simulateDelay()
        
        let notes = await fetchNotes()
        return notes.first(where: { $0.id == id })
    }

    // MARK: - Private

    private static func saveAll(_ notes: [NoteModel]) {
        guard let data = try? encoder.encode(notes) else { return }
        UserDefaults.standard.set(data, forKey: notesKey)
    }

    private static func simulateDelay() async {
        try? await Task.sleep(nanoseconds: apiDelay)
    }
}
