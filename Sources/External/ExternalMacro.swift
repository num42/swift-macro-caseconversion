@attached(member, names: arbitrary)
public macro CaseConversion(public: Bool = false) =
  #externalMacro(
    module: "CaseConversionMacros",
    type: "CaseConversionMacro"
  )
