//
//  UIToolbar+Done.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

extension UIToolbar {
    static func doneToolbar(target: Any, action: Selector) -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "ok".localized, style: .done, target: target, action: action)
        done.tintColor = AppColor.brand60.uiColor
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        return toolbar
    }
}
