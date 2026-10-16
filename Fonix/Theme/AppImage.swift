//
//  AppImage.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

enum ImageSource: Equatable {
    case asset(String)
    case system(String)
    case remote(URL)
}

enum AppImage {
    static func named(_ name: String) -> UIImage? {
        let image = UIImage(named: name)
        if image == nil { AppLog.error("Görsel bulunamadı: \(name)") }
        return image
    }
}
