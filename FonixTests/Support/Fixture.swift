//
//  Fixture.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest

enum Fixture {
    static func json(_ name: String) throws -> String {
        let bundle = Bundle(for: FixtureAnchor.self)
        let url = try XCTUnwrap(bundle.url(forResource: name, withExtension: "json"), "\(name).json bulunamadı")
        return try String(contentsOf: url, encoding: .utf8)
    }
}

private final class FixtureAnchor {}
