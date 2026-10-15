//
//  AppAssemblyTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix
import Swinject

final class AppAssemblyTests: XCTestCase {
    func test_live_resolvesCriticalTypes() {
        let dependencies = AppDependencies.live()

        XCTAssertNotNil(dependencies.resolver.resolve(AppSession.self))
        XCTAssertNotNil(dependencies.resolver.resolve(NetworkClient.self))
    }

    func test_appSession_isSingleton() {
        let dependencies = AppDependencies.live()

        let first = dependencies.resolver.resolve(AppSession.self)
        let second = dependencies.resolver.resolve(AppSession.self)

        XCTAssertTrue(first === second)
    }
}
