//
//  ExploreViewModel.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation

@MainActor
  final class ExploreViewModel: BaseViewModel {
      enum Segment: String, CaseIterable {
          case fund
          case pension
          case autoEnrollment

          var titleKey: String {
              switch self {
              case .fund: return "explore_segment_fund"
              case .pension: return "explore_segment_pension"
              case .autoEnrollment: return "explore_segment_auto_enrollment"
              }
          }
      }

      enum State: Equatable {
          case idle
          case loading
          case loaded
          case failed(String)
      }

      private(set) var state: State = .idle
      private(set) var categories: [FundCategory] = []
      private(set) var topFunds: [AssetSummary] = []
      private(set) var searchResults: [AssetSummary] = []
      private(set) var selectedSegment: Segment = .fund
      private(set) var selectedTopFundType: TopFundType = .earned
      private(set) var selectedCategoryCode: String?
      private(set) var searchQuery = ""
      /// Ana yükleme dışındaki isteklerin hatası; bir kez okunup temizlenir.
      private var pendingError: String?

      var onChange: (() -> Void)?

      let formatter: AmountFormatter
      private let service: FundServicing
      private weak var navigator: ExploreNavigating?

      static let minimumSearchLength = 2

      init(service: FundServicing,
           navigator: ExploreNavigating?,
           formatter: AmountFormatter = AmountFormatter()) {
          self.service = service
          self.navigator = navigator
          self.formatter = formatter
      }

      var isSearching: Bool { searchQuery.count >= Self.minimumSearchLength }

      func load() async {
          state = .loading
          onChange?()
          do {
              async let categories = service.fundCategories()
              async let funds = service.topFunds(type: selectedTopFundType)
              self.categories = try await categories
              self.topFunds = try await funds
              state = .loaded
          } catch let error as APIError {
              state = .failed(message(for: error))
          } catch {
              state = .failed(error.localizedDescription)
          }
          onChange?()
      }

      func selectSegment(_ segment: Segment) {
          guard segment != selectedSegment else { return }
          selectedSegment = segment
          onChange?()
      }

      func selectTopFundType(_ type: TopFundType) async {
          guard type != selectedTopFundType else { return }
          selectedTopFundType = type
          do {
              topFunds = try await service.topFunds(type: type)
          } catch {
              pendingError = message(for: error)
          }
          onChange?()
      }

      func selectCategory(code: String) {
          selectedCategoryCode = selectedCategoryCode == code ? nil : code
          onChange?()
          if let selectedCategoryCode {
              navigator?.showCategory(code: selectedCategoryCode)
          }
      }

      func search(query: String) async {
          searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
          guard isSearching else {
              searchResults = []
              onChange?()
              return
          }
          do {
              searchResults = try await service.searchFunds(query: searchQuery)
          } catch {
              searchResults = []
              pendingError = message(for: error)
          }
          onChange?()
      }

      func takeError() -> String? {
          defer { pendingError = nil }
          return pendingError
      }

      func showAssetDetail(assetCode: String) {
          guard !assetCode.isEmpty else { return }
          navigator?.showAssetDetail(assetCode: assetCode)
      }

      func showAllFunds() {
          navigator?.showAllFunds(type: selectedTopFundType)
      }

      private func message(for error: Error) -> String {
          guard let error = error as? APIError else { return error.localizedDescription }
          switch error {
          case .server(let message), .httpStatus(_, .some(let message)): return message
          case .transport: return "error_network".localized
          default: return "error_generic".localized
          }
      }
  }
