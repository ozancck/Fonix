//
//  AppDependencies.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import Swinject

final class AppDependencies {
    private let assembler: Assembler

    var resolver: Resolver { assembler.resolver }

    init(assemblies: [Assembly] = []) {
        assembler = Assembler(assemblies)
    }

    static func live() -> AppDependencies {
        AppDependencies(assemblies: [NetworkAssembly()])
    }
}
