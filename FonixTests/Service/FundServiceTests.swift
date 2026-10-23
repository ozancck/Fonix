//
//  FundServiceTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import XCTest
@testable import Fonix

final class FundServiceTests: XCTestCase {
    private var service: FundService!

    override func setUp() {
        super.setUp()
        let client = URLSessionNetworkClient(baseURL: URL(string: "https://example.test/")!,
                                             session: StubURLProtocol.makeSession())
        service = FundService(client: client)
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func test_homeData_decodesFixture() async throws {
        StubURLProtocol.respond(status: 200, json: try Fixture.json("home_data"))

        let home = try await service.homeData()

        XCTAssertEqual(home.totalAmount, 184250.75)
        XCTAssertEqual(home.userPortfolios.map(\.portfolioTitle), ["Uzun Vade", "Emeklilik"])
        XCTAssertEqual(home.userAssets.map(\.assetType), ["fund", "gold", "currency"])
        XCTAssertEqual(home.userAssets.first?.items.first?.quantityValue, 1250)
    }

    func test_topEarners_decodesFixture_sortedByRatio() async throws {
        StubURLProtocol.respond(status: 200, json: try Fixture.json("top_earners"))

        let earners = try await service.topEarners()

        XCTAssertEqual(earners.count, 5)
        XCTAssertEqual(earners.first?.assetCode, "MAC")
        XCTAssertEqual(earners.first?.ratio, 3.05)
        XCTAssertNotNil(earners.first?.imageURL)
        XCTAssertTrue(earners.first?.isGain ?? false)
    }

    func test_favoriteAssets_decodesFixture_withDetail() async throws {
        StubURLProtocol.respond(status: 200, json: try Fixture.json("favorite_assets"))

        let favorites = try await service.favoriteAssets()

        XCTAssertEqual(favorites.map(\.assetCode), ["AFT", "YAY"])
        XCTAssertEqual(favorites.first?.detail?.fundType, "Hisse Senedi Şemsiye Fonu")
        XCTAssertEqual(favorites.first?.summary.assetPrice, "48.213456")
    }

    func test_httpError_carriesServerMessage() async {
        StubURLProtocol.respond(status: 404, json: #"{"success":false,"message":"Fon bulunamadı","data":null}"#)

        do {
            _ = try await service.homeData()
            XCTFail("hata beklenirdi")
        } catch let error as APIError {
            XCTAssertEqual(error, .httpStatus(404, "Fon bulunamadı"))
        } catch {
            XCTFail("APIError beklenirdi: \(error)")
        }
    }
    
    func test_fundCategories_decodesFixture() async throws {
        StubURLProtocol.respond(status: 200, json: try Fixture.json("fund_categories"))

        let categories = try await service.fundCategories()

        XCTAssertEqual(categories.count, 5)
        XCTAssertEqual(categories.first?.categoryCode, "equity")
        XCTAssertEqual(categories.first?.categoryTitle, "Hisse Senedi")
        XCTAssertNotNil(categories.first?.iconURL)
    }

    func test_topFunds_decodesFixture_sortedByRatio() async throws {
        StubURLProtocol.respond(status: 200, json: try Fixture.json("top_funds"))

        let funds = try await service.topFunds(type: .earned)

        XCTAssertEqual(funds.count, 6)
        XCTAssertEqual(funds.first?.assetCode, "MAC")
        XCTAssertEqual(funds.last?.assetCode, "TTE")
        XCTAssertFalse(funds.last?.isGain ?? true)
    }
}
