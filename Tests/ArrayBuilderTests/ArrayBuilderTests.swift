// ArrayBuilder
// ArrayBuilderTests.swift
//
// MIT License
//
// Copyright (c) 2026 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import ArrayBuilder
import Testing

@Suite("Builder Syntax")
struct BuilderSyntaxTests {

    @Test("A single value builds a one-element array")
    func singleValue() {
        let result: [Int] = Array {
            1
        }
        #expect(result == [1])
    }

    @Test("Multiple values combine in source order")
    func multipleValues() {
        let result: [Int] = Array {
            1
            2
            3
        }
        #expect(result == [1, 2, 3])
    }

    @Test("Collections contribute their elements in order")
    func collectionValues() {
        let result: [Int] = Array {
            [1, 2]
            3 ... 5
            [6, 7, 8].dropFirst()
        }
        #expect(result == [1, 2, 3, 4, 5, 7, 8])
    }

    @Test("Single values and collections mix in source order")
    func mixedValues() {
        let result: [Int] = Array {
            0
            [1, 2]
            3
            4 ... 5
        }
        #expect(result == [0, 1, 2, 3, 4, 5])
    }

    @Test("An empty builder produces an empty array")
    func emptyBuilder() {
        let result: [Int] = Array {}
        #expect(result.isEmpty)
    }

    @Test("A statement that returns nothing runs but adds nothing")
    func voidStatement() {
        var sideEffects = 0
        func recordSideEffect() {
            sideEffects += 1
        }
        let result: [Int] = Array {
            1
            recordSideEffect()
            2
        }
        #expect(result == [1, 2])
        #expect(sideEffects == 1)
    }

    @Test("A statement that stops the program exits before the array is built")
    func neverStatement() async {
        await #expect(processExitsWith: .failure) {
            let result: [Int] = Array {
                1
                fatalError("The builder should never reach this point")
            }
            _ = result
        }
    }

    @Test("An if without an else includes values only when the condition holds", arguments: [true, false])
    func ifWithoutElse(condition: Bool) {
        let result: [Int] = Array {
            1
            if condition {
                2
            }
            3
        }
        #expect(result == (condition ? [1, 2, 3] : [1, 3]))
    }

    @Test("An if/else includes values from the branch that runs", arguments: [true, false])
    func ifElse(condition: Bool) {
        let result: [Int] = Array {
            if condition {
                1
            } else {
                2
            }
        }
        #expect(result == (condition ? [1] : [2]))
    }

    @Test("A switch includes values from the case that matches", arguments: 1 ... 3)
    func switchStatement(value: Int) {
        let result: [String] = Array {
            switch value {
            case 1:
                "one"
            case 2:
                "two"
            default:
                "many"
            }
        }
        let expected = switch value {
        case 1: ["one"]
        case 2: ["two"]
        default: ["many"]
        }
        #expect(result == expected)
    }

    @Test("A for loop adds values from every iteration in order")
    func forLoop() {
        let result: [Int] = Array {
            for value in 1 ... 3 {
                value * 10
            }
        }
        #expect(result == [10, 20, 30])
    }

    @Test("Nested statements compose")
    func nestedStatements() {
        let result: [Int] = Array {
            0
            for value in 1 ... 4 {
                if value.isMultiple(of: 2) {
                    value
                }
            }
            [5, 6]
        }
        #expect(result == [0, 2, 4, 5, 6])
    }

    @Test("The builder attribute works on a function")
    func builderFunction() {
        @ArrayBuilder<String>
        func makeList(includeBaz: Bool) -> [String] {
            "Foo"
            "Bar"
            if includeBaz {
                "Baz"
            }
        }
        #expect(makeList(includeBaz: true) == ["Foo", "Bar", "Baz"])
        #expect(makeList(includeBaz: false) == ["Foo", "Bar"])
    }

    @Test("The builder attribute works on a closure parameter")
    func builderClosureParameter() {
        func makeList(@ArrayBuilder<String> items: () -> [String]) -> [String] {
            items()
        }
        let result = makeList {
            "Milk"
            "Eggs"
            "Bread"
        }
        #expect(result == ["Milk", "Eggs", "Bread"])
    }

}

@Suite("Builder Methods")
struct BuilderMethodTests {

    @Test("buildExpression wraps a single value in an array")
    func buildExpressionSingleValue() {
        #expect(ArrayBuilder<Int>.buildExpression(1) == [1])
    }

    @Test("buildExpression converts a collection into an array")
    func buildExpressionCollection() {
        #expect(ArrayBuilder<Int>.buildExpression(1 ... 3) == [1, 2, 3])
        #expect(ArrayBuilder<Int>.buildExpression([Int]()) == [])
    }

    @Test("buildExpression runs a nested builder closure")
    func buildExpressionNestedBuilder() {
        let result = ArrayBuilder<Int>.buildExpression {
            1
            [2, 3]
        }
        #expect(result == [1, 2, 3])
    }

    @Test("buildExpression ignores a Void value")
    func buildExpressionVoid() {
        #expect(ArrayBuilder<Int>.buildExpression(()) == [])
    }

    @Test("buildBlock joins partial arrays in order")
    func buildBlock() {
        #expect(ArrayBuilder<Int>.buildBlock([1], [], [2, 3]) == [1, 2, 3])
    }

    @Test("buildBlock with no components builds an empty array")
    func buildBlockEmpty() {
        #expect(ArrayBuilder<Int>.buildBlock() == [])
    }

    @Test("buildEither passes both branches through unchanged")
    func buildEither() {
        #expect(ArrayBuilder<Int>.buildEither(first: [1, 2]) == [1, 2])
        #expect(ArrayBuilder<Int>.buildEither(second: [3, 4]) == [3, 4])
    }

    @Test("buildOptional passes a value through and turns nil into an empty array")
    func buildOptional() {
        #expect(ArrayBuilder<Int>.buildOptional([1, 2]) == [1, 2])
        #expect(ArrayBuilder<Int>.buildOptional(nil) == [])
    }

    @Test("buildArray joins loop iterations in order")
    func buildArray() {
        #expect(ArrayBuilder<Int>.buildArray([[1], [2, 3], []]) == [1, 2, 3])
        #expect(ArrayBuilder<Int>.buildArray([]) == [])
    }

}

@Suite("Array Initializer")
struct ArrayInitializerTests {

    @Test("init(builder:) creates an array from the closure's values")
    func initializerBuildsArray() {
        let result = Array(builder: {
            1
            2
        })
        #expect(result == [1, 2])
    }

    @Test("init(builder:) supports trailing closure syntax")
    func trailingClosure() {
        let result: [String] = Array {
            "a"
            "b"
        }
        #expect(result == ["a", "b"])
    }

}
