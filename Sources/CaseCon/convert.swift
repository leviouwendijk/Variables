import Arguments
import Primitives

enum Convert: RunnableArgumentCommand {
    static let name = "convert"

    static func components() throws -> [CommandComponentLowerable] {
        [
            about(
                "Convert identifiers between casing conventions."
            ),
            arg(
                "inputs",
                as: String.self,
                arity: .variadic,
                help: "Identifiers to convert."
            ),
            opt(
                "casing",
                alias: "style",
                short: "c",
                as: Casing.self,
                default: .snake,
                help: "Target casing: camel, pascal, snake, or kebab."
            ),
            opt(
                "separators",
                as: SeparatorPreset.self,
                default: .common,
                help: "Separators: common, commonNoDot, space, or none."
            ),
            flag(
                "json",
                short: "j",
                help: "Output the result as JSON."
            ),
        ]
    }

    static func run(
        _ invocation: ParsedInvocation
    ) async throws {
        let inputs = try invocation.values(
            "inputs",
            as: String.self
        )

        guard !inputs.isEmpty else {
            throw ArgumentValidationError(
                "No inputs provided."
            )
        }

        let casing = try invocation.value(
            "casing",
            as: Casing.self,
            default: .snake
        )

        let separators = try invocation.value(
            "separators",
            as: SeparatorPreset.self,
            default: .common
        ).value

        let converted = inputs.map { input in
            input.casing.as(
                casing,
                separators: separators
            )
        }

        if try invocation.flag("json") {
            let result = JSONValue.object(
                [
                    "ok": .bool(true),
                    "result": .array(
                        converted.map(JSONValue.string)
                    ),
                ]
            )

            print(
                try result.toJSONString(
                    prettyPrinted: true
                )
            )

            return
        }

        for value in converted {
            print(
                value
            )
        }
    }
}

private enum SeparatorPreset: String, ArgumentValue {
    case common
    case commonNoDot
    case space
    case none

    var value: Separators {
        switch self {
        case .common:
            .common

        case .commonNoDot:
            .commonNoDot

        case .space:
            .space

        case .none:
            .none
        }
    }
}
