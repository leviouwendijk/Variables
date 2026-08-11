import Arguments

@main
enum CaseCon: ArgumentCommand {
    static let name = "casecon"
    static let defaultChild = Convert.self

    static let children: [ArgumentCommandType] = [
        Convert.self,
    ]

    static func components() throws -> [CommandComponentLowerable] {
        [
            about(
                "Convert identifiers between casing conventions."
            ),
        ]
    }
}
