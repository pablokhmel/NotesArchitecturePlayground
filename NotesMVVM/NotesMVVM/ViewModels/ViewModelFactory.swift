import Foundation
import Core

public protocol ViewModelFactoryType {
    
}

public final class ViewModelFactory: ViewModelFactoryType {
    private let noteManagerProvider: () -> NoteManaging

    public init(noteManagerProvider: @escaping () -> NoteManaging = { DefaultNoteManager() }) {
        self.noteManagerProvider = noteManagerProvider
    }
}
