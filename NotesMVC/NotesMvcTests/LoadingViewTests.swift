import XCTest
@testable import NotesMVC

final class LoadingViewTests: XCTestCase {
    @MainActor
    private func makeViewControllerInWindow() async -> UIViewController {
        let vc = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        return vc
    }

    func testExecutesAction() async {
        let vc = await makeViewControllerInWindow()
        let exp = expectation(description: "action executed")

        await MainActor.run {
            LoadingView.startLoading(on: vc) {
                exp.fulfill()
            }
        }

        await fulfillment(of: [exp], timeout: 2.0)
    }

    func testCallsOnErrorOnFailure() async {
        let vc = await makeViewControllerInWindow()
        let exp = expectation(description: "onError called")

        await MainActor.run {
            LoadingView.startLoading(on: vc, action: {
                struct DummyError: Error {}
                throw DummyError()
            }, onError: { _ in
                exp.fulfill()
            })
        }

        await fulfillment(of: [exp], timeout: 2.0)
    }
}
