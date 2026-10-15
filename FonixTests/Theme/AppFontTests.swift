//
//  AppFontTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class AppFontTests: XCTestCase {
    func test_allWeights_areRegistered() {
        let weights: [AppFontWeight] = [.regular, .medium, .semibold, .bold]
        for weight in weights {
            let font = AppFont.bodyLarge.attributes(weight).font
            XCTAssertEqual(font.fontName, weight.rawValue, "\(weight) yüklenmemiş")
        }
    }

    func test_attributes_useSizeAndLineHeight() {
        let attributes = AppFont.h4.attributes(.bold)
        XCTAssertEqual(attributes.font.pointSize, 20)
        XCTAssertEqual(attributes.lineHeight, 28)
    }
}
