internal import MacroTester
internal import SwiftSyntaxMacros
internal import SwiftSyntaxMacrosTestSupport
internal import Testing

#if canImport(CaseConversionMacros)
  import CaseConversionMacros

  @Suite struct CaseConversionMacroDiagnosticsTests {
    let testMacros: [String: Macro.Type] = [
      "CaseConversion": CaseConversionMacro.self
    ]

    @Test func structThrowsError() throws {
      assertMacroExpansion(
        """
        @CaseConversion
        struct AStruct {}
        """,
        expandedSource: """
          struct AStruct {}
          """,
        diagnostics: [
          .init(
            message: CaseConversionMacro.MacroDiagnostic.requiresEnum.message,
            line: 1,
            column: 1
          )
        ],
        macros: testMacros
      )
    }

    @Test func unlabeledAssociatedValueExpands() throws {
      assertMacroExpansion(
        """
        @CaseConversion
        enum Route {
          case detail(Int)
        }
        """,
        expandedSource: """
          enum Route {
            case detail(Int)
            var asDetail: Int? {
              if case let .detail(int) = self {
                int
              } else {
                nil
              }
            }
          }
          """,
        diagnostics: [],
        macros: testMacros
      )
    }
  }
#endif
