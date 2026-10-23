//
//  FundCategory.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation

struct FundCategory: Decodable, Equatable {
    let categoryId: String
    let categoryTitle: String
    let categoryCode: String
    let categoryIcon: String?

    var iconURL: URL? { categoryIcon.flatMap(URL.init) }
}
