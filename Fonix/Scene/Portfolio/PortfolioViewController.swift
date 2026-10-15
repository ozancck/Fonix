//
//  HomeViewController.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class PortfolioViewController: BaseFormViewController {
    override func screenIdentifier() -> String { "tab_home" }

    override func prepareViewModels() {
        viewModels = [EmptyCellViewModel(height: AppConstants.Margin2x)]
    }
}
