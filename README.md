# Principle

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FNSFatalError%2FPrinciple%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/NSFatalError/Principle)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FNSFatalError%2FPrinciple%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/NSFatalError/Principle)
[![Codecov](https://codecov.io/gh/NSFatalError/Principle/graph/badge.svg?token=ITK16CK7NL)](https://codecov.io/gh/NSFatalError/Principle)

Essential tools that extend the capabilities of Swift Standard Library.

#### Contents
- [PrincipleConcurrency](#principleconcurrency)
- [PrincipleCollections](#principlecollections)
- [Documentation](#documentation)
- [Installation](#installation)

## PrincipleConcurrency

`PrincipleConcurrency` introduces `SingleUseTransfer` - an important utility that allows to safely capture `sending` values in closures where the compiler would otherwise prohibit it.

Since Swift currently lacks a built-in annotation to indicate that a closure is guaranteed to be invoked at most once, the compiler may reject code that programmers can prove to be safe. 
`SingleUseTransfer` shifts the responsibility of ensuring single invocation to the developer while preserving all the benefits of strict concurrency checking - without resorting 
to tempting workarounds like `@unchecked` or `nonisolated(unsafe)`:

```swift
let mutex = Mutex(NonSendable())
let instance = NonSendable()
var transfer = SingleUseTransfer(instance)

mutex.withLock { protected in
    protected = transfer.finalize()
}
```

Additionally, `PrincipleConcurrency` contains multiple tools to impose time-based constraints for `async` operations:

```swift
Task {
    do {
        try await withTimeout(.seconds(1)) {
            try await crunchNumbers()
        }
    } catch is TimeoutError {
        print("Operation took too long to finish and got cancelled.")
    }
}
```

## PrincipleCollections

`PrincipleCollections` contains extensions to expressively sort collections of types which can't naturally conform to `Comparable` protocol:

```swift
struct Person: Equatable {
    let age: Int
    let name: String
}

var people: [Person] = [...]
people.sort(on: \.age)
```

## Documentation

[Full documentation is available on the Swift Package Index.](https://swiftpackageindex.com/NSFatalError/Principle/documentation/principle)

## Installation

```swift
.package(
    url: "https://github.com/NSFatalError/Principle",
    from: "1.0.0"
)
```
