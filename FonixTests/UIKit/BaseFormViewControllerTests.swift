import XCTest
@testable import Fonix

private final class SampleFormViewController: BaseFormViewController {
    override func prepareViewModels() {
        let hidden = EmptyCellViewModel(height: 20)
        hidden.visible = false
        viewModels = [EmptyCellViewModel(height: 10), hidden, EmptyCellViewModel(height: 30)]
        headerViewModels = [EmptyCellViewModel(height: 40)]
    }
}

final class BaseFormViewControllerTests: XCTestCase {
    private func makeLoaded() -> SampleFormViewController {
        let controller = SampleFormViewController()
        controller.loadViewIfNeeded()
        return controller
    }

    func test_prepareViewModels_feedsTableView() {
        let controller = makeLoaded()
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 3)
    }

    func test_invisibleViewModel_hasZeroHeight() {
        let controller = makeLoaded()
        let height = controller.tableView(controller.tableView,
                                          heightForRowAt: IndexPath(row: 1, section: 0))
        XCTAssertEqual(height, 0)
    }

    func test_headerViewModels_areMountedInHeaderStack() {
        let controller = makeLoaded()
        XCTAssertEqual(controller.headerStack.arrangedSubviews.count, 1)
    }

    func test_reloadContent_rebuildsWithoutDuplicates() {
        let controller = makeLoaded()
        controller.reloadContent()
        XCTAssertEqual(controller.viewModels.count, 3)
        XCTAssertEqual(controller.headerStack.arrangedSubviews.count, 1)
    }
    
    func test_tableView_fillsHeight_insideTabBar() {
        let controller = SampleFormViewController()
        let tabs = UITabBarController()
        tabs.viewControllers = [UINavigationController(rootViewController: controller)]
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        window.rootViewController = tabs
        window.makeKeyAndVisible()
        controller.view.layoutIfNeeded()

        XCTAssertGreaterThan(controller.tableView.frame.height, 300)
    }
}
