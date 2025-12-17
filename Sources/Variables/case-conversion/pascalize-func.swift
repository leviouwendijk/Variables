@inline(__always)
internal func pascalizePreservingAfterPunct(_ s: String) -> String {
    guard !s.isEmpty else { return s }
    let scalars = Array(s.unicodeScalars)
    var out: [UnicodeScalar] = []
    out.reserveCapacity(scalars.count)

    // Uppercase first char (ASCII fast path), copy others with rule below.
    func upperASCII(_ u: UnicodeScalar) -> UnicodeScalar {
        if isASCIILower(u) { return UnicodeScalar(u.value - 32)! }
        return u
    }
    func lowerASCII(_ u: UnicodeScalar) -> UnicodeScalar {
        if isASCIIUpper(u) { return UnicodeScalar(u.value + 32)! }
        return u
    }

    // First scalar
    var prevWasPunct = false
    var prevRunLen = 0
    var curRunLen = 0

    let first = scalars[0]
    out.append(upperASCII(first))
    curRunLen = isASCIIAlnum(first) ? 1 : 0
    prevWasPunct = !isASCIIAlnum(first)

    // Rest
    for i in 1..<scalars.count {
        let u = scalars[i]
        if isASCIIAlnum(u) {
            if prevWasPunct {
                // Starting a new alnum run after punctuation.
                // If the *previous* run had length ≥ 2, we preserve the original case
                // (e.g., "My.File" keeps 'F'); otherwise we normalize to lower
                // (e.g., "A.B" → 'b').
                if prevRunLen >= 2 {
                    out.append(u)
                } else {
                    out.append(lowerASCII(u))
                }
                prevWasPunct = false
                curRunLen = 1
            } else {
                out.append(lowerASCII(u))
                curRunLen += 1
            }
        } else {
            out.append(u)
            prevWasPunct = true
            prevRunLen = curRunLen
            curRunLen = 0
        }
    }

    return String(String.UnicodeScalarView(out))
}
