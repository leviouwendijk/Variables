public enum KeyCaseMapping {
    /// Force all encoded keys to a style (your Swift properties can be any style).
    case encode(to: CaseStyle)
    /// On decode, transform incoming keys from their style to your property style.
    case decode(from: CaseStyle, to: CaseStyle = .camel)
}
