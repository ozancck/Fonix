//
//  AppColor.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

enum AppColor: String, CaseIterable {
    case gray0 = "#FFFFF2"
    case gray10 = "#F1F5F9"
    case gray20 = "#E2E8F0"
    case gray30 = "#CBD5E1"
    case gray40 = "#94A3B8"
    case gray50 = "#64748B"
    case gray60 = "#475569"
    case gray70 = "#334155"
    case gray80 = "#1E293B"
    case gray90 = "#0F172A"

    case brand50 = "#6366F1"
    case brand60 = "#4F46E5"
    case brand80 = "#3730A3"
    case brand90 = "#312E81"

    case success10 = "#DCFCE7"
    case success50 = "#22C55E"
    case success60 = "#16A34A"
    case success90 = "#14532D"

    case destructive10 = "#FEE2E2"
    case destructive50 = "#EF4444"
    case destructive60 = "#DC2626"
    case destructive90 = "#7F1D1D"

    case white = "#FFFFFF"
    case black = "#000000"

    var uiColor: UIColor { UIColor(hex: rawValue) }
}
