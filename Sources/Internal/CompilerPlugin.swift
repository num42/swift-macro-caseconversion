import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CaseConversionPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    CaseConversionMacro.self,
  ]
}
