import Foundation

public protocol BaseViewModel: AnyObject {
    var title: String? { get set }
    func onAppear()
    func onDisappear()
}

public extension BaseViewModel {
    func onAppear() {}
    func onDisappear() {}
}

open class DefaultBaseViewModel: BaseViewModel {
    public var title: String?
    public init(title: String? = nil) {
        self.title = title
    }
    public func onAppear() {}
    public func onDisappear() {}
}
