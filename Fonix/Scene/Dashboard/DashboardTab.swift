//
//  DashboardTab.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

enum DashboardTab: Int, CaseIterable {
    case home, portfolio, explore, profile

    var title: String {
        switch self {
        case .home: return "tab_home".localized
        case .portfolio: return "tab_portfolio".localized
        case .explore: return "tab_explore".localized
        case .profile: return "tab_profile".localized
        }
    }

    var iconName: String {
        switch self {
        case .home: return "icon_tabbar_home"
        case .portfolio: return "icon_tabbar_portfolio"
        case .explore: return "icon_tabbar_explore"
        case .profile: return "icon_tabbar_profile"
        }
    }

    var systemFallback: String {
        switch self {
        case .home: return "house"
        case .portfolio: return "chart.pie"
        case .explore: return "magnifyingglass"
        case .profile: return "person"
        }
    }

    var tabBarItem: UITabBarItem {
        let image = UIImage(named: iconName) ?? UIImage(systemName: systemFallback)
        let selected = UIImage(named: iconName + "_selected") ?? UIImage(systemName: systemFallback + ".fill")
        let item = UITabBarItem(title: title, image: image, selectedImage: selected)
        item.tag = rawValue
        return item
    }
}
