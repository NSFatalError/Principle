# Deadlines

Ensure concurrent tasks complete before the specified point in time.

## Overview

To impose a deadline on an asynchronous function call ``withDeadline(until:tolerance:priority:isolation:operation:)`` 
from other asynchronous function or from a `Task` body:

```swift
Task {
    do {
        try await withDeadline(until: .now + .seconds(1)) {
            try await crunchNumbers()
        }
        // Function completed before the deadline
    } catch is DeadlineExceededError {
        // Function exceeded the deadline and was cancelled
    } catch {
        // Function threw an error before the deadline
    }
}
```

## Topics

- ``withDeadline(until:tolerance:priority:isolation:operation:)``
- ``withDeadline(until:tolerance:clock:priority:isolation:operation:)``
- ``DeadlineExceededError``
