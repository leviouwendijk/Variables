// checks
@inline(__always)
internal func isASCIIUpper(_ u: UnicodeScalar) -> Bool { u.value >= 65 && u.value <= 90 }   // A-Z
@inline(__always)
internal func isASCIILower(_ u: UnicodeScalar) -> Bool { u.value >= 97 && u.value <= 122 }  // a-z
@inline(__always)
internal func isASCIILetter(_ u: UnicodeScalar) -> Bool { isASCIIUpper(u) || isASCIILower(u) }
@inline(__always)
internal func isASCIIDigit(_ u: UnicodeScalar) -> Bool { u.value >= 48 && u.value <= 57 }   // 0-9
@inline(__always)
internal func isASCIIAlnum(_ u: UnicodeScalar) -> Bool { isASCIILetter(u) || isASCIIDigit(u) }

// manipulators
@inline(__always)
internal func lowerASCII(_ s: String) -> String { s.lowercased() }

@inline(__always)
internal func upperFirstLowerRestASCII(_ s: String) -> String {
    guard let first = s.unicodeScalars.first else { return s }
    var out = String(UnicodeScalar(isASCIILower(first) ? first.value - 32 : first.value)!) // uppercased first (ASCII)
    if s.unicodeScalars.count > 1 {
        let rest = String(s.unicodeScalars.dropFirst())
        out += rest.lowercased()
    }
    return out
}
