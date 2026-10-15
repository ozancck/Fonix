import XCTest
@testable import Fonix

private final class SampleCardCellViewModel: BaseCellViewModel {}

private final class ReloadSpy: CellReloading {
    var reloaded: [BaseCellViewModel] = []
    func reloadCell(_ viewModel: BaseCellViewModel) { reloaded.append(viewModel) }
    func reloadAllCells() {}
}

final class BaseCellViewModelTests: XCTestCase {
    func test_cellIdentifier_followsNamingConvention() {
        XCTAssertEqual(SampleCardCellViewModel().cellIdentifier(), "SampleCardTableViewCell")
    }

    func test_reload_notifiesDelegate() {
        let spy = ReloadSpy()
        let viewModel = SampleCardCellViewModel()
        viewModel.reloadDelegate = spy

        viewModel.reload()

        XCTAssertTrue(spy.reloaded.first === viewModel)
    }
}
