import UIKit

class NotesFlowCoordinator {
    let navigationController: UINavigationController
    let viewModelFactory: ViewModelFactoryType
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let notesProvider = DefaultNoteManager()
        viewModelFactory = ViewModelFactory(noteManagerProvider: { notesProvider })
    }
    
    public func start() {
        let listVC = ViewController()
        navigationController.pushViewController(listVC, animated: false)
    }
}
