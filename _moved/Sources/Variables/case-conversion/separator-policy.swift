// Public separator policy (fast ASCII table, optional non-ASCII closure)
public struct SeparatorPolicy: Sendable {
    @usableFromInline var ascii: [Bool] = Array(repeating: false, count: 128)
    public var nonASCII: (@Sendable (UnicodeScalar) -> Bool)?

    @inlinable
    public init<S: Sequence>(
        scalars: S,
        nonASCII: (@Sendable (UnicodeScalar) -> Bool)? = nil
    ) where S.Element == UnicodeScalar {
        self.nonASCII = nonASCII
        for u in scalars { insert(u) }
    }

    // Convenience initializer for Character sequences (e.g., [" ", "_", "."])
    @inlinable
    public init<C: Sequence>(
        chars: C,
        nonASCII: (@Sendable (UnicodeScalar) -> Bool)? = nil
    ) where C.Element == Character {
        self.nonASCII = nonASCII
        for c in chars {
            for u in c.unicodeScalars { insert(u) }
        }
    }

    // Convenience: build from a simple ASCII string of separators (e.g., " _-./+:,")
    @inlinable
    public init(
        asciiString: String,
        nonASCII: (@Sendable (UnicodeScalar) -> Bool)? = nil
    ) {
        self.nonASCII = nonASCII
        for u in asciiString.unicodeScalars { insert(u) }
    }

    @inlinable
    public mutating func insert(_ u: UnicodeScalar) {
        if u.value < 128 { ascii[Int(u.value)] = true }
    }

    @inlinable
    public func contains(_ u: UnicodeScalar) -> Bool {
        if u.value < 128 { return ascii[Int(u.value)] }
        return nonASCII?(u) ?? false
    }

    /// Default (includes dot).
    public static let commonWithDot   = SeparatorPolicy(
        chars: [
            " ",
            "_",
            "-",
            ".",
            "/",
            "+",
            ":",
            ","
        ]
    )
    /// Variant that excludes dot (keeps file extensions intact).
    public static let commonNoDot     = SeparatorPolicy(
        chars: [
            " ",
            "_",
            "-",
            "/",
            "+",
            ":",
            ","
        ]
    )
    /// Whitespace only.
    public static let whitespaceOnly  = SeparatorPolicy(
        chars: [
            " "
        ]
    )
    
    // alternative ways to initialize: 

    // public static let commonWithDot = SeparatorPolicy(chars: Array(" _-./+:,"))
    // public static let commonNoDot = SeparatorPolicy(chars: Array(" _-/+:,"))
    // public static let whitespaceOnly = SeparatorPolicy(chars: Array(" "))

    // public static let commonWithDot   = SeparatorPolicy(asciiString: " _-./+:,")
    // public static let commonNoDot     = SeparatorPolicy(asciiString: " _-/+:,")
    // public static let whitespaceOnly  = SeparatorPolicy(asciiString: " ")
}
