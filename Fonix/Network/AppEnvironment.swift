//
//  AppEnvironment.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation


enum AppEnvironment {
    case development
    case production

    static var current: AppEnvironment {
        //App Transport Security Settings sözlüğü altında Allows Local Networking = YES.
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    /// Dummy backend'in adresi. Gerçek sunucu gelince production değişir.
    var baseURL: URL {
        switch self {
        case .development: return URL(string: "https://fonix-mock-api.ozancck.workers.dev/")!
        case .production: return URL(string: "https://fonix-mock-api.ozancck.workers.dev/")!
        }
    }
}
