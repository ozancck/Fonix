//
//  AmountFormatterTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class AmountFormatterTests: XCTestCase {
    private let formatter = AmountFormatter()

    func test_money_usesTurkishSeparators() {
        XCTAssertEqual(formatter.moneyString(184250.75), "₺184.250,75")
    }

    func test_fundPrice_keepsUpToSixDecimals() {
        XCTAssertEqual(formatter.fundPriceString(48.213456), "₺48,213456")
    }

    func test_percent_signedWithTwoDecimals() {
        XCTAssertEqual(formatter.percentString(2.14), "%+2,14")
        XCTAssertEqual(formatter.percentString(-0.87), "%-0,87")
    }
}
