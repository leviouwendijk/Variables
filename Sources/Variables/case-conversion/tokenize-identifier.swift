internal func tokenizeIdentifier(_ input: String, separators: SeparatorPolicy) -> [String] {
    if input.isEmpty { return [] }

    var tokens: [String] = []
    var current: [UnicodeScalar] = []

    let scalars = Array(input.unicodeScalars)
    let n = scalars.count

    @inline(__always)
    func flush() {
        if !current.isEmpty {
            tokens.append(String(String.UnicodeScalarView(current)))
            current.removeAll(keepingCapacity: true)
        }
    }

    for i in 0..<n {
        let u = scalars[i]
        let k = classify(u, separators)
        let prev = i > 0 ? scalars[i-1] : nil
        let next = i+1 < n ? scalars[i+1] : nil
        let pk = prev.map { classify($0, separators) }
        let nk = next.map { classify($0, separators) }

        switch k {
        case .sep:
            flush()

        case .other:
            current.append(u)

        case .digit:
            if let pk = pk, (pk == .upper || pk == .lower) {
                flush()
            }
            current.append(u)
            if let nk = nk, (nk == .upper || nk == .lower) {
                flush()
            }

        case .lower:
            if let pk = pk, pk == .upper, current.count >= 2 {
                // Only split if we truly had TWO consecutive uppers right before this lower,
                // e.g. "...HTMLP" + "arser" → split before 'P'.
                let beforeLast = current[current.count - 2]
                if isASCIIUpper(beforeLast) {
                    let last = current.removeLast()
                    flush()
                    current.append(last)
                }
            }
            current.append(u)

        case .upper:
            if let pk = pk {
                switch pk {
                case .lower, .digit, .sep:
                    // lower→Upper OR digit→Upper → boundary before this char
                    flush()
                    current.append(u)
                case .other:
                    // punctuation (not configured as separator) should NOT force a boundary
                    // keep accumulating into the same token (e.g., "My.File" stays one token)
                    current.append(u)
                case .upper:
                    // Upper followed by Upper:
                    // keep accumulating; we might split on next lower to handle acronyms
                    current.append(u)
                }
            } else {
                // start of string: include the first uppercase
                current.append(u)
            }
        }
    }
    flush()
    return tokens
}
