//
//  AmountFormatter.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

struct AmountFormatter {
     private let money: NumberFormatter
     private let fundPrice: NumberFormatter
     private let percent: NumberFormatter

     init(locale: Locale = Locale(identifier: "tr_TR")) {
         money = NumberFormatter()
         money.locale = locale
         money.numberStyle = .currency
         money.currencySymbol = "₺"
         money.maximumFractionDigits = 2

         fundPrice = NumberFormatter()
         fundPrice.locale = locale
         fundPrice.numberStyle = .currency
         fundPrice.currencySymbol = "₺"
         fundPrice.minimumFractionDigits = 2
         fundPrice.maximumFractionDigits = 6

         percent = NumberFormatter()
         percent.locale = locale
         percent.numberStyle = .decimal
         percent.minimumFractionDigits = 2
         percent.maximumFractionDigits = 2
         percent.positivePrefix = "+"
     }

     func moneyString(_ value: Double) -> String {
         money.string(from: NSNumber(value: value)) ?? ""
     }

     func fundPriceString(_ value: Double) -> String {
         fundPrice.string(from: NSNumber(value: value)) ?? ""
     }

     func percentString(_ value: Double) -> String {
         "%" + (percent.string(from: NSNumber(value: value)) ?? "")
     }
 }
