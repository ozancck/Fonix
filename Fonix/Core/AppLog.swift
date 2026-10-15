//
//  AppLog.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import Foundation

enum AppLog {
    static func verbose(_ message: String) {
        #if DEBUG
        print("[V] \(message)")
        #endif
    }

    static func error(_ message: String) {
        #if DEBUG
        print("[E] \(message)")
        #endif
    }

    static func deinitialize(_ object: AnyObject) {
        #if DEBUG
        print("[D] \(type(of: object)) deinitialized.")
        #endif
    }
}
