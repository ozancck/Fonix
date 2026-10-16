//
//  InputCellViewModelTests.swift
//  FonixTests
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class InputCellViewModelTests: XCTestCase {
    func test_textField_requiredAndEmpty_returnsMessage() {
        let viewModel = TextFieldCellViewModel(title: "Ad")
        viewModel.isRequired = true

        XCTAssertNotNil(viewModel.validate())
        viewModel.text.text = "  Ozan "
        XCTAssertNil(viewModel.validate())
        XCTAssertEqual(viewModel.value, "Ozan")
    }

    func test_textField_emailType_rejectsInvalidAddress() {
        let viewModel = TextFieldCellViewModel(title: "E-posta", inputType: .email)
        viewModel.text.text = "ozan@"
        XCTAssertNotNil(viewModel.validate())
        viewModel.text.text = "ozan@fonix.app"
        XCTAssertNil(viewModel.validate())
    }

    func test_pickerTextField_selectUpdatesTextAndIndex() {
        let viewModel = PickerTextFieldCellViewModel(title: "Fon", items: ["AFT", "TTE"], selectedIndex: 1)
        XCTAssertEqual(viewModel.selectedValue, "TTE")
        XCTAssertEqual(viewModel.text.text, "TTE")

        viewModel.select(index: 5)
        XCTAssertNil(viewModel.selectedValue)
        XCTAssertEqual(viewModel.selectedIndex, -1)
        viewModel.isRequired = true
        XCTAssertNotNil(viewModel.validate())
    }

    func test_numberKeyValue_commitParsesTurkishFormat() {
        let viewModel = NumberKeyValueInputCellViewModel(title: "Fiyat", unit: "₺")
        viewModel.commit(input: "1.234,5")

        XCTAssertEqual(viewModel.decimalValue, 1234.5)
        XCTAssertEqual(viewModel.text.text, "1.234,5 ₺")
        XCTAssertEqual(viewModel.editableText, "1.234,5")
    }

    func test_numberKeyValue_requiredRejectsZero() {
        let viewModel = NumberKeyValueInputCellViewModel(title: "Adet", value: 0)
        viewModel.isRequired = true
        XCTAssertNotNil(viewModel.validate())
        viewModel.set(value: 3)
        XCTAssertNil(viewModel.validate())
    }

    func test_pickerKeyValue_selectAndValidate() {
        let viewModel = PickerKeyValueInputCellViewModel(title: "Portföy", items: ["Ana", "Yedek"])
        viewModel.isRequired = true
        XCTAssertNotNil(viewModel.validate())
        viewModel.select(index: 0)
        XCTAssertEqual(viewModel.value, "Ana")
        XCTAssertNil(viewModel.validate())
    }

    func test_dateTimeKeyValue_formatsDate() {
        var components = DateComponents()
        components.year = 2026
        components.month = 10
        components.day = 16
        let date = Calendar(identifier: .gregorian).date(from: components)!
        let viewModel = DateTimeKeyValueInputCellViewModel(title: "Tarih", date: date)

        XCTAssertEqual(viewModel.text.text, "16.10.2026")
        viewModel.set(date: nil)
        XCTAssertFalse(viewModel.hasValue)
    }

    func test_keyValueSubclasses_shareOneCell() {
        let number = NumberKeyValueInputCellViewModel(title: "x")
        let picker = PickerKeyValueInputCellViewModel(title: "x", items: [])
        let date = DateTimeKeyValueInputCellViewModel(title: "x")

        for viewModel in [number, picker, date] {
            XCTAssertEqual(viewModel.cellIdentifier(), "KeyValueInputTableViewCell")
            XCTAssertTrue(viewModel.makeCell() is KeyValueInputTableViewCell)
        }
    }

    func test_cellsLoadAndBind() {
        let title = TitleLabelCellViewModel(text: "Başlık")
        let search = SearchTextFieldCellViewModel(placeholder: "Fon ara")
        let textField = TextFieldCellViewModel(title: "Ad", value: "Ozan")
        let picker = PickerTextFieldCellViewModel(title: "Fon", items: ["AFT"], selectedIndex: 0)

        for viewModel in [title, search, textField, picker] {
            let cell = viewModel.makeCell()
            XCTAssertNotNil(cell, "\(viewModel.cellIdentifier()) yüklenemedi")
            cell?.set(viewModel: viewModel)
        }
        XCTAssertGreaterThan(title.fixedHeight(), 16)
        XCTAssertEqual(search.fixedHeight(), 64)

        let textFieldCell = textField.makeCell() as? TextFieldTableViewCell
        textFieldCell?.set(viewModel: textField)
        XCTAssertEqual(textFieldCell?.field.text, "Ozan")
    }
}
