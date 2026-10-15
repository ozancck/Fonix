//
//  NetworkAssembly.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import Swinject

final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppSession.self) { _ in AppSession() }
            .inObjectScope(.container)

        container.register(NetworkClient.self) { resolver in
            let session = resolver.resolve(AppSession.self)!
            return URLSessionNetworkClient(baseURL: AppEnvironment.current.baseURL,
                                           tokenProvider: { session.accessToken })
        }
        .inObjectScope(.container)
    }
}
