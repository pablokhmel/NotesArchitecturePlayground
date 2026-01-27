import XCTest
@testable import NotesMVC

final class LoadingViewTests: XCTestCase {
    @MainActor
    private func makeViewControllerInWindow() async -> UIViewController {
        let vc = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        // Make the window key & visible so LoadingView can attach to a container
        window.makeKeyAndVisible()
        return vc
    }

    func testExecutesAction() async {
        let vc = await makeViewControllerInWindow()
        let exp = expectation(description: "action executed")

        // Call startLoading on the main actor because it manipulates the view hierarchy
        await MainActor.run {
            LoadingView.startLoading(on: vc) {
                // fulfill the expectation from inside the async action
                exp.fulfill()
            }
        }

        // Wait for the action to be executed
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
