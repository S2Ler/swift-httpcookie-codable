import XCTest
@testable import HttpCookieCodable

final class HttpCookieCodableTests: XCTestCase {
  func testRoundTrip() throws {
    let cookie = HTTPCookie(properties: [
      .domain: "cookie.com",
      .name: "JSESSIONID",
      .init(rawValue: "HttpOnly"): true,
      .value: "192837192873",
      .discard: true,
      .path: "/",
      .secure: true,
      .init(rawValue: "Created"): 123297,
    ])!

    let encoder = JSONEncoder()
    let data = try encoder.encode(CodableHttpCookieContainer(cookie))

    let decoder = JSONDecoder()
    let decodedCookieContainer = try decoder.decode(CodableHttpCookieContainer.self, from: data)
    let decodedCookie = decodedCookieContainer.cookie
    XCTAssertEqual(cookie.domain, decodedCookie.domain)
    XCTAssertEqual(cookie.name, decodedCookie.name)
    XCTAssertEqual(cookie.value, decodedCookie.value)
    XCTAssertEqual(cookie.isSecure, decodedCookie.isSecure)
    XCTAssertEqual(cookie.path, decodedCookie.path)
    assertRawValue([cookie, decodedCookie], rawKey: "HttpOnly")
    assertRawValue([cookie, decodedCookie], rawKey: "Created")
  }

  static var allTests = [
    ("testRoundTrip", testRoundTrip),
  ]

  private func assertRawValue(_ cookies: [HTTPCookie], rawKey: String) {
    precondition(cookies.count >= 2)

    let key = HTTPCookiePropertyKey(rawValue: rawKey)
    let values = cookies
      .compactMap { $0.properties?[key] as? NSObject }
    XCTAssertEqual(cookies.count, values.count)
    let firstValue = values[0]
    let otherValues = values.dropFirst()

    for value in otherValues {
      XCTAssertEqual(value, firstValue)
    }
  }
}
