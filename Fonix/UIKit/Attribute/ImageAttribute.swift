//
//  ImageAttribute.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit
import SDWebImage

final class ImageAttribute {
    var source: ImageSource?
    var tintColor: UIColor?
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var cornerRadius: CGFloat = 0

    init(source: ImageSource? = nil, tintColor: AppColor? = nil) {
        self.source = source
        self.tintColor = tintColor?.uiColor
    }

    convenience init(named name: String, tintColor: AppColor? = nil) {
        self.init(source: .asset(name), tintColor: tintColor)
    }

    var isEmpty: Bool { source == nil }

    func apply(to imageView: UIImageView) {
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = cornerRadius > 0
        imageView.tintColor = tintColor

        switch source {
        case .asset(let name):
            let image = AppImage.named(name)
            imageView.image = tintColor == nil ? image : image?.withRenderingMode(.alwaysTemplate)
        case .remote(let url):
            imageView.sd_setImage(with: url, placeholderImage: AppImage.named("CryptoLogo"))
        case nil:
            imageView.image = nil
        }
    }
}
