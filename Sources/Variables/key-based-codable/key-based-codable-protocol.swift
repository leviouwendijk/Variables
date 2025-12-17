public protocol KeyBasedCodable: Sendable, Codable, CaseIterable, RawRepresentable where RawValue == String {
    static var keyFormatting: KeyFormattingStrategy { get }
    var key: String { get }
}
