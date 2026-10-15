//
//  AppFont.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

struct FontAttributes {
    let font: UIFont
    let lineHeight: CGFloat
}

enum AppFontWeight: String {
    case regular = "Archivo-Regular"
    case medium = "Archivo-Medium"
    case semibold = "Archivo-SemiBold"
    case bold = "Archivo-Bold"
}

enum AppFont {
    case h1, h2, h3, h4, h5, h6
    case bodyXLarge, bodyLarge, bodyMedium, bodySmall, bodyXSmall

    var size: CGFloat {
        switch self {
        case .h1: return 32
        case .h2: return 28
        case .h3: return 24
        case .h4: return 20
        case .h5: return 18
        case .h6: return 16
        case .bodyXLarge: return 18
        case .bodyLarge: return 16
        case .bodyMedium: return 14
        case .bodySmall: return 12
        case .bodyXSmall: return 10
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .h1: return 40
        case .h2: return 36
        case .h3: return 32
        case .h4: return 28
        case .h5: return 26
        case .h6: return 24
        case .bodyXLarge: return 26
        case .bodyLarge: return 24
        case .bodyMedium: return 20
        case .bodySmall: return 16
        case .bodyXSmall: return 14
        }
    }

    func attributes(_ weight: AppFontWeight = .regular) -> FontAttributes {
        let font = UIFont(name: weight.rawValue, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight.systemWeight)
        return FontAttributes(font: font, lineHeight: lineHeight)
    }
}

private extension AppFontWeight {
    var systemWeight: UIFont.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }
}
