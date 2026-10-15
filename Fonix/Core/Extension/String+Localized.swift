//
//  String+Localized.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
