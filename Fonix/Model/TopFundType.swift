//
//  TopFundType.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation

enum TopFundType: String, CaseIterable {
    case earned
    case leader
    case investor

    var titleKey: String { "explore_top_funds_\(rawValue)" }
}
