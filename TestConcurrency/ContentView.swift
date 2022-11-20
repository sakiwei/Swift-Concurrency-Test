//
//  ContentView.swift
//  TestConcurrency
//
//  Created by Wai Cheung on 20/11/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .task {
            printLine("0")
            Task(priority: .background) {
                do {
                    printLine("1", "start")
                    let result = try await backgroundAction(step: "1")
                    printLine("1", result)
                } catch {
                    printLine("1", "error = \(error)")
                }
                printLine("1", "done")
            }
            Task.detached(priority: .background) {
                printLine("2", "detached (p:bg)")
            }
            Task {
                printLine("3")
            }
            Task.detached {
                printLine("4", "detached (p:default)")
            }
            Task.detached { @MainActor in
                do {
                    printLine("5", "start")
                    let result = try await backgroundAction(step: "5")
                    printLine("5", result)
                } catch {
                    printLine("5", "error = \(error)")
                }
                printLine("5", "done")
            }
            printLine("6")
        }
        .padding()
    }
    
    private func backgroundAction(step: String) async throws -> String {
        Task.detached {
            printLine("\(step)a", "detached")
        }
        try await Task.sleep(for: .milliseconds(1000))
        printLine("\(step)b")
        return "return-result"
    }
    
    private func printLine(_ tag: String,
                           _ message: @autoclosure () -> String = "",
                           _ functionName: String = #function,
                           _ line: Int = #line) {
        let msg = message()
        let isMainThread = Thread.isMainThread
        print("[\(functionName):\(line):\(isMainThread ? "main-thread" : "bg-thread")] > \(tag) \(msg)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
