# Swift Concurrency Test


This is a testing project to check the behaviour of swift concurrency.

Here is the console log after running (Please make a side-by-side checking with [ContentView.swift](./TestConcurrency/ContentView.swift)):

```
[body:16:main-thread] > 0 
[body:46:main-thread] > 6 
[body:34:bg-thread] > 4 detached (p:default)
[body:28:bg-thread] > 2 detached (p:bg)
[body:31:main-thread] > 3 
[body:38:main-thread] > 5 start
[body:19:main-thread] > 1 start
[backgroundAction(step:):53:bg-thread] > 5a detached
[backgroundAction(step:):53:bg-thread] > 1a detached
[backgroundAction(step:):56:bg-thread] > 5b 
[backgroundAction(step:):56:bg-thread] > 1b 
[body:40:main-thread] > 5 return-result
[body:44:main-thread] > 5 done
[body:21:main-thread] > 1 return-result
[body:25:main-thread] > 1 done
```

## Some findings

1. `Task.detached{}` executed earlier than `Task{}`.
2. When a funciton is marked with `async`, it will run under background thread.
3. When a funciton runs under `Task.detached{}`, it will run under background thread.
4. Please notice that `task(priority: .background)` never make your function run under background thread.
