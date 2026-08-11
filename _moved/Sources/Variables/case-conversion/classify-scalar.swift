
@inline(__always)
internal func classify(_ u: UnicodeScalar, _ sep: SeparatorPolicy) -> CharKind {
    if sep.contains(u) { return .sep }
    if isASCIIUpper(u) { return .upper }
    if isASCIILower(u) { return .lower }
    if isASCIIDigit(u) { return .digit }
    return .other
}

