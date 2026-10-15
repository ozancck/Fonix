//
//  URLSessionNetworkClientTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

private struct Ping: Decodable, Equatable {
    let assetCode: String
}

private struct PingRequest: APIRequest {
    typealias Response = Ping
    let path = "ping"
    var parameters: [String: Any] { ["server_key": "x"] }
}

private struct DebugRequest: APIRequest {
    typealias Response = Ping
    let path = "ping"
    var queryItems: [String: String] { ["_status": "500"] }
}

private struct ListRequest: APIRequest {
    typealias Response = Ping
    let path = "list"
    let method: HTTPMethod = .get
    var parameters: [String: Any] { ["page": 2, "q": "fon"] }
}

final class URLSessionNetworkClientTests: XCTestCase {
    private var client: URLSessionNetworkClient!

    override func setUp() {
        super.setUp()
        client = URLSessionNetworkClient(baseURL: URL(string: "https://example.test/")!,
                                         session: StubURLProtocol.makeSession(),
                                         tokenProvider: { "token123" })
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func test_send_decodesDataFromEnvelope_andConvertsSnakeCase() async throws {
        StubURLProtocol.respond(status: 200, json: #"{"success":true,"data":{"asset_code":"AFT"}}"#)

        let result = try await client.send(PingRequest())

        XCTAssertEqual(result, Ping(assetCode: "AFT"))
    }

    func test_send_throwsServerError_whenSuccessFalse() async {
        StubURLProtocol.respond(status: 200, json: #"{"success":false,"message":"Yetkisiz"}"#)

        do {
            _ = try await client.send(PingRequest())
            XCTFail("hata beklenirdi")
        } catch let error as APIError {
            XCTAssertEqual(error, .server("Yetkisiz"))
        } catch {
            XCTFail("APIError beklenirdi, gelen: \(error)")
        }
    }

    func test_send_throwsHttpStatus_onNon2xx() async {
        StubURLProtocol.respond(status: 500, json: "{}")

        do {
            _ = try await client.send(PingRequest())
            XCTFail("hata beklenirdi")
        } catch let error as APIError {
            XCTAssertEqual(error, .httpStatus(500))
        } catch {
            XCTFail("APIError beklenirdi, gelen: \(error)")
        }
    }

    func test_makeURLRequest_post_setsJsonBodyAndAuthHeader() throws {
        let request = try client.makeURLRequest(for: PingRequest())

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.absoluteString, "https://example.test/ping")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token123")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        let body = try XCTUnwrap(request.httpBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: String])
        XCTAssertEqual(json["server_key"], "x")
    }

    func test_makeURLRequest_get_putsParametersInQuery() throws {
        let request = try client.makeURLRequest(for: ListRequest())

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://example.test/list?page=2&q=fon")
        XCTAssertNil(request.httpBody)
    }

    func test_makeURLRequest_appendsQueryItems_onPost() throws {
        let request = try client.makeURLRequest(for: DebugRequest())
        XCTAssertEqual(request.url?.absoluteString, "https://example.test/ping?_status=500")
        XCTAssertEqual(request.httpMethod, "POST")
    }
}
