//
//  AppSession.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

/// Oturum durumu. Swinject'te container scope: uygulama boyunca tek örnek.
final class AppSession {
    var accessToken: String?
    var userId: String?

    var isLoggedIn: Bool { !(accessToken ?? "").isEmpty }

    func clear() {
        accessToken = nil
        userId = nil
    }
}
