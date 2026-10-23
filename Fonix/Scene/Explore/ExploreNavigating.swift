//
//  ExploreNavigating.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation

protocol ExploreNavigating: AnyObject {
    func showAssetDetail(assetCode: String)
    func showCategory(code: String)
    func showAllFunds(type: TopFundType)
}
