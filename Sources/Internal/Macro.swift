import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct CaseConversionMacro: MemberMacro {
  public enum MacroDiagnostic: String, DiagnosticMessage {
    case requiresEnum = "#CaseConversion requires an enum"

    public var message: String { rawValue }

    public var diagnosticID: MessageID {
      MessageID(domain: "CaseConversion", id: rawValue)
    }

    public var severity: DiagnosticSeverity { .error }
  }

  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let modifiers = declaration.accessModifierPrefix

    guard declaration.as(EnumDeclSyntax.self) != nil else {
      let diagnostic = Diagnostic(node: Syntax(attribute), message: MacroDiagnostic.requiresEnum)
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let elements = declaration.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .flatMap(\.elements)

    return
      elements
      .filter(\.hasAssociatedValues)
      .map { ($0, $0.name.initialUppercased, $0.associatedValues) }
      .map { original, uppercased, associatedValues in
        // TODO: add test for enum case with a single optional associated value. this lead to "??" types without the check below
        let tuple = associatedValues.asTypedTuple

        return """
          \(raw: modifiers)var as\(raw: uppercased): \(raw: tuple)\(raw: tuple.hasSuffix("?") ? "" : "?") {
            if case let .\(raw: original.name)(\(raw: associatedValues.asParameters)) = self {
              \(raw: associatedValues.asUntypedList)
            } else {
              nil
            }
          }
          """
      }
  }
}
