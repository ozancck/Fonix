//
//  ServiceAssembly.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import Swinject

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FundServicing.self) { resolver in
            FundService(client: resolver.resolve(NetworkClient.self)!)
        }
        .inObjectScope(.container)
    }
}
