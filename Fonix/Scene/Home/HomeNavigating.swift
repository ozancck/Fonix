//
//  HomeNavigating.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

protocol HomeNavigating: AnyObject {
    func showAssetDetail(assetCode: String)
    func showExplore()
    func showCreatePortfolio()
}
