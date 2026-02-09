/// Add computed properties named `as<Case>` for each case element in the enum.
@attached(member, names: arbitrary)
public macro CaseConversion(public: Bool = false) =
  #externalMacro(module: "CaseConversionMacros", type: "CaseConversionMacro")
