//
//  BaseViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

class BaseViewModel: NSObject {
    deinit {
        AppLog.deinitialize(self)
    }
}
