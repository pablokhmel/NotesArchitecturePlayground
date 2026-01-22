import UIKit

@IBDesignable
final class LoadingView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        let nib = UINib(nibName: "LoadingView", bundle: .main)
        nib.instantiate(withOwner: self)
        addSubview(contentView)
        contentView.frame = bounds
    }
    
    @MainActor
    public static func startLoading(
        on viewController: UIViewController,
        action: @escaping () async throws -> Void,
        onError: @escaping (Error) -> Void = { _ in }
    ) {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.alpha = 0

        guard let containerView =
            viewController.navigationController?.view
            ?? viewController.view.window
            ?? viewController.view
        else { return }

        containerView.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        loadingView.isUserInteractionEnabled = true

        UIView.animate(withDuration: 0.1) {
            loadingView.alpha = 1
        }

        Task {
            do {
                try await action()
            } catch {
                onError(error)
            }

            await MainActor.run {
                UIView.animate(withDuration: 0.1, animations: {
                    loadingView.alpha = 0
                }, completion: { _ in
                    loadingView.removeFromSuperview()
                })
            }
        }
    }
}

