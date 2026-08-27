// ArrayBuilder
// ArrayBuilder.swift
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

/// A result builder that builds an array from the statements in a closure.
///
/// Use `ArrayBuilder` to build an array with declarative, SwiftUI-style syntax.
/// Write one value per line instead of calling `append(_:)` or joining arrays by hand.
///
/// Inside the closure, you can:
///
/// - Write a single value. The builder adds it to the array.
/// - Write a collection of values. The builder adds all of its elements, in order.
/// - Use `if`, `else`, and `switch` to include values only when a condition holds.
/// - Use `for` loops to add values repeatedly.
/// - Run a statement that returns nothing, like a call to `print(_:)`.
///   The statement runs, but it adds nothing to the array.
///
/// The builder preserves the order of your statements. The first statement
/// produces the first elements of the array.
///
/// ## Example
///
/// The easiest way to use the builder is the array initializer,
/// ``Swift/Array/init(builder:)``. The following code builds an array of
/// integers. It mixes single values, a condition, a collection, and a loop:
///
/// ```swift
/// let numbers = Array {
///     if includeZero {
///         0
///     }
///     1
///     [2, 3]
///     for value in 4 ... 6 {
///         value
///     }
/// }
/// // [0, 1, 2, 3, 4, 5, 6] if includeZero is true
/// ```
///
/// You can also apply the builder to a function, a computed property,
/// or a closure parameter in your own API:
///
/// ```swift
/// @ArrayBuilder<String>
/// func makeList() -> [String] {
///     "Foo"
///     "Bar"
///     "Baz"
/// }
///
/// @ArrayBuilder<String>
/// var groceries: [String] {
///     "Milk"
///     "Eggs"
///     "Bread"
/// }
/// ```
///
/// > Note: You never call the builder's static methods yourself.
/// > The Swift compiler calls them for you when it transforms the closure.
///
/// ## Topics
///
/// ### Adding Values
///
/// - ``buildExpression(_:)-912pv``
/// - ``buildExpression(_:)-8b8j0``
/// - ``buildExpression(_:)-57dzl``
///
/// ### Handling Statements Without Values
///
/// - ``buildExpression(_:)-rx04``
/// - ``buildExpression(_:)-5df2v``
///
/// ### Combining Statements
///
/// - ``buildBlock(_:)``
/// - ``buildBlock()``
///
/// ### Supporting Conditions
///
/// - ``buildEither(first:)``
/// - ``buildEither(second:)``
/// - ``buildOptional(_:)``
///
/// ### Supporting Loops
///
/// - ``buildArray(_:)``
@resultBuilder
public enum ArrayBuilder<T> {

    /// Ignores a statement that produces no value.
    ///
    /// The compiler calls this method when a statement in the closure
    /// returns nothing — for example, a call to `print(_:)`.
    /// The statement still runs, but it adds nothing to the array.
    ///
    /// ```swift
    /// let numbers = Array {
    ///     1
    ///     print("Building…")
    ///     2
    /// }
    /// // Prints "Building…"
    /// // [1, 2]
    /// ```
    ///
    /// - Parameter expression: A value of type `Void`, which carries no information.
    /// - Returns: An empty array.
    public static func buildExpression(
        _ expression: Void
    ) -> [T] {
        []
    }

    /// Handles a statement that stops the program.
    ///
    /// The compiler calls this method when a statement in the closure
    /// has the type `Never` — for example, a call to `fatalError(_:)`.
    /// Such a statement stops the program before it can produce a value,
    /// so this method never runs.
    ///
    /// This overload exists so the compiler does not try to treat the
    /// statement as a value to add to the array.
    ///
    /// - Parameter expression: A value that can never exist.
    /// - Returns: No value. The program stops before this method can run.
    public static func buildExpression(
        _ expression: Never
    ) -> [T] {}

    /// Turns a single value into an array with one element.
    ///
    /// The compiler calls this method when a statement in the closure
    /// is a single value of the element type.
    ///
    /// For example, each line in this closure passes through this method:
    ///
    /// ```swift
    /// let numbers = Array {
    ///     1
    ///     2
    /// }
    /// // [1, 2]
    /// ```
    ///
    /// - Parameter expression: A single value to add to the array.
    /// - Returns: An array that contains only `expression`.
    public static func buildExpression(
        _ expression: T
    ) -> [T] {
        [expression]
    }

    /// Turns a collection of values into an array of its elements.
    ///
    /// The compiler calls this method when a statement in the closure
    /// is a collection — for example, an array, a set, or a range.
    /// The builder adds every element of the collection, in its original order.
    ///
    /// ```swift
    /// let numbers = Array {
    ///     [1, 2]
    ///     3 ... 5
    /// }
    /// // [1, 2, 3, 4, 5]
    /// ```
    ///
    /// - Parameter expression: A collection of values to add to the array.
    /// - Returns: An array that contains the elements of `expression`.
    public static func buildExpression(
        _ expression: some Collection<T>
    ) -> [T] {
        .init(expression)
    }

    /// Runs a nested builder closure and adds its result.
    ///
    /// The compiler calls this method when a statement in the closure
    /// is itself an `ArrayBuilder` closure. This lets you compose
    /// smaller builders into larger ones.
    ///
    /// - Parameter expression: A closure that builds an array of values.
    /// - Returns: The array that `expression` builds.
    public static func buildExpression(
        @ArrayBuilder<T> _ expression: () -> [T]
    ) -> [T] {
        expression()
    }

    /// Combines the statements in a closure into a single array.
    ///
    /// The compiler calls this method with one partial array per statement.
    /// This method joins them into one array and preserves their order.
    ///
    /// - Parameter components: The partial arrays, one per statement, in source order.
    /// - Returns: A single array that contains the elements of every partial array, in order.
    public static func buildBlock(
        _ components: [T]...
    ) -> [T] {
        components
            .flatMap(\.self)
    }

    /// Builds an empty array from a closure with no statements.
    ///
    /// The compiler calls this method when the closure is empty.
    ///
    /// ```swift
    /// let numbers = Array<Int> {}
    /// // []
    /// ```
    ///
    /// - Returns: An empty array.
    public static func buildBlock() -> [T] {
        []
    }

    /// Passes through the values from the first branch of a condition.
    ///
    /// The compiler calls this method when an `if`/`else` or `switch`
    /// statement takes its first branch. The values from that branch
    /// become part of the array. The other branch contributes nothing.
    ///
    /// - Parameter component: The partial array that the first branch built.
    /// - Returns: `component`, unchanged.
    public static func buildEither(
        first component: [T]
    ) -> [T] {
        component
    }

    /// Passes through the values from the second branch of a condition.
    ///
    /// The compiler calls this method when an `if`/`else` or `switch`
    /// statement takes its second branch. The values from that branch
    /// become part of the array. The other branch contributes nothing.
    ///
    /// - Parameter component: The partial array that the second branch built.
    /// - Returns: `component`, unchanged.
    public static func buildEither(
        second component: [T]
    ) -> [T] {
        component
    }

    /// Handles an `if` statement that has no `else` branch.
    ///
    /// The compiler calls this method for an `if` statement without an `else`.
    /// If the condition holds, the branch's values become part of the array.
    /// If the condition fails, this method returns an empty array,
    /// so the statement adds nothing.
    ///
    /// ```swift
    /// let numbers = Array {
    ///     1
    ///     if includeTwo {
    ///         2
    ///     }
    /// }
    /// // [1, 2] if includeTwo is true; otherwise [1]
    /// ```
    ///
    /// - Parameter component: The partial array from the branch,
    ///   or `nil` if the condition failed.
    /// - Returns: `component` if it has a value; otherwise, an empty array.
    public static func buildOptional(
        _ component: [T]?
    ) -> [T] {
        component ?? []
    }

    /// Combines the results of a `for` loop into a single array.
    ///
    /// The compiler calls this method after a `for` loop finishes.
    /// Each iteration builds one partial array. This method joins them
    /// into one array and preserves the iteration order.
    ///
    /// ```swift
    /// let numbers = Array {
    ///     for value in 1 ... 3 {
    ///         value
    ///     }
    /// }
    /// // [1, 2, 3]
    /// ```
    ///
    /// - Parameter components: The partial arrays, one per iteration, in order.
    /// - Returns: A single array that contains the elements of every iteration, in order.
    public static func buildArray(
        _ components: [[T]]
    ) -> [T] {
        components
            .flatMap(\.self)
    }

}

extension Array {

    /// Creates an array from the values you list in a builder closure.
    ///
    /// Use this initializer to build an array with ``ArrayBuilder`` syntax.
    /// List one value or collection per line. You can also use `if`, `else`,
    /// `switch`, and `for` statements to decide which values to include.
    ///
    /// ```swift
    /// let numbers = Array {
    ///     1
    ///     [2, 3]
    ///     if includeMore {
    ///         4 ... 6
    ///     }
    /// }
    /// // [1, 2, 3, 4, 5, 6] if includeMore is true; otherwise [1, 2, 3]
    /// ```
    ///
    /// - Parameter builder: A closure that lists the values for the new array.
    public init(
        @ArrayBuilder<Element> builder: () -> [Element]
    ) {
        self = builder()
    }

}
