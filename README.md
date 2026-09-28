# CaseConversion

Adds `as<Case>` helpers for enum cases.

## Requirements

- Swift 6.3 toolchain or later (tested with Xcode 27)
- Platforms: macOS 14, iOS 13, tvOS 13, watchOS 6, macCatalyst 13

## Usage

```swift
@CaseConversion
enum TestEnum {
  case firstCase
  case secondCase(string: String, bool: Bool)
  case thirdCase(argument: String)
  case fourthCase(subtypeArgument: SubType.String)
}
```

Generated:

```swift
enum TestEnum {
  case firstCase
  case secondCase(string: String, bool: Bool)
  case thirdCase(argument: String)
  case fourthCase(subtypeArgument: SubType.String)

    var asSecondCase: (string: String, bool: Bool)? {
      if case let .secondCase(string, bool) = self {
        (string, bool)
      } else {
        nil
      }
    }

    var asThirdCase: String? {
      if case let .thirdCase(argument) = self {
        argument
      } else {
        nil
      }
    }

    var asFourthCase: SubType.String? {
      if case let .fourthCase(subtypeArgument) = self {
        subtypeArgument
      } else {
        nil
      }
    }
}
```

## Notes

Apply to enums only.
