# Timeouts

Ensure concurrent tasks take at most specified amount of time to complete.

## Overview

To impose a timeout on an asynchronous function call ``withTimeout(_:tolerance:priority:isolation:operation:)`` 
from other asynchronous function or from a `Task` body:

```swift
Task {
    do {
        try await withTimeout(.seconds(1)) {
            try await crunchNumbers()
        }
        // Function completed within the time limit
    } catch is DeadlineExceededError {
        // Function exceeded the time limit and was cancelled
    } catch {
        // Function threw an error within the time limit
    }
}
```

## Topics

- ``withTimeout(_:tolerance:priority:isolation:operation:)``
- ``withTimeout(_:tolerance:clock:priority:isolation:operation:)``
- ``TimeoutError``
