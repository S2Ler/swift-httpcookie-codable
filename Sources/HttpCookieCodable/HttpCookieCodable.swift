import Foundation

/// Wraps `HTTPCookie` in a container which conforms to `Codable` protocol.
public final class CodableHttpCookieContainer: Codable {
  public enum Error: Swift.Error {
    case failedToUnarchive
  }
  public let cookie: HTTPCookie

  public init(_ cookie: HTTPCookie) {
    self.cookie = cookie
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let data = try container.decode(Data.self)
    guard let cookie = NSUnarchiver.unarchiveObject(with: data) as? HTTPCookie else {
      throw Error.failedToUnarchive
    }
    self.cookie = cookie
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    let data = NSArchiver.archivedData(withRootObject: cookie)
    try container.encode(data)
  }
}
