var welcome = "Hello BIX"

func double(_ x: Int) -> Int {
    return 2 * x
}

func triple(_ x: Int) -> Int {
    return 3 * x
}

func quadruple(_ x: Int) -> Int {
    return 4 * x
}

// Traditional way
let x = quadruple(triple(double(2)))

// A more readable approach but also more wordy
let a = double(2)
let b = triple(a)
let c = quadruple(b)

// INTRODUCING SOME FUNCTIONAL OPERATORS
infix operator |>: ForwardApplication
precedencegroup ForwardApplication {
    associativity: left // Execution order from left to right
}

// y = f(x)
func |> <A,B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

2
    |> double
    |> triple
    |> quadruple

/*
 No intermediary variables introduces. Clean and forward-readable
 Can keep chaining methods. Two requirements:
 1) can only chain a function
 2) the output of the first function has to match the input of the second one
 */


// WHAT'S NEXT?
// Let's see if we can integrate these with higher order functions and try some functional composition

let numbers = [1,2,3,4,5]
let numbersTimesSix = numbers.map { $0 |> double |> triple }
numbersTimesSix
// We'd like to compute n * 6 for each element of the array
// Because we don't have a `x * 6` method, we pipe `x * 2` and `x * 3`
// Now let's see if we can compose those two methods to define `x * 6`

infix operator >>>: ForwardComposition
precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
    // Because compiler doesn't know which operator to use first (|> vs >>>), we give priority to composition
    // We can't apply the result of a function to composition. We can only apply functions in there.
}

// This is the equivalent of y = g(f(x))
func >>> <A,B,C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { a in
        g(f(a))
    }
}

let timesSix = double >>> triple
2 |> timesSix
let numbersTimesSixComposition = numbers.map { $0 |> timesSix }
numbersTimesSixComposition
