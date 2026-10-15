//
//  AppColorTests.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import XCTest
@testable import Fonix

final class AppColorTests: XCTestCase {
    func test_hexInit_parsesChannels() {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(hex: "#FF8000").getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 1, accuracy: 0.01)
        XCTAssertEqual(g, 0.5, accuracy: 0.01)
        XCTAssertEqual(b, 0, accuracy: 0.01)
    }

    func test_allCases_haveSixDigitHex() {
        for color in AppColor.allCases {
            XCTAssertEqual(color.rawValue.count, 7, "\(color) hex uzunluğu yanlış")
        }
    }
}
