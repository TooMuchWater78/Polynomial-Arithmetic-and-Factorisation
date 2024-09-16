using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

println("There are two fundamental polynomial types in this project: `Polynomial` and `PolynomialBig`. Their \n" *
        "basic functionality is the same; `Polynomial` uses `Int64` coefficients while `PolynomialBig` uses \n" * 
        "`BigInt`. Consequently, `PolynomialBig` is substantially slower and should only be used when there is \n" * 
        "a risk of integer overflow with `Polynomial`. `PolynomialModP` is a `Polynomial` type mod some prime `p`. \n" * 
        "All other functionality is the same.")
println("To construct a 'random' polynomial, use `rand(P)` where `P` is one of the above polynomial types. For \n" *
        "conscious construction, one can define `x = x_poly(P)` and then use `x` like a 'regular' mathematical variable. \n" * 
        "For example:")

x = x_poly(Polynomial)
prime = 19
p1 = x^2 - 2x + 1
p2 = 3x^3 + 14x^2 + 5

println("p₁ = ", p1)
println("p₂ = ", p2)

println("Creating a random `PolynomialModP`:")

println("p₃ = $(rand(PolynomialModP, p = 3))")

println("We can perform all basic arithmetic operations on these polynomials that one would expect.")
println("Addition:")
println("p₁ + p₂ = ", p1 + p2)
println("Subtraction:")
println("p₁ - p₂ = ", p1 - p2)
println("Multiplication:")
println("p₁ * p₂ = ", p1 * p2)
println("Division mod p (e.g. p = 19):")
println("p₁ ÷ p₂ = ", (p1 ÷ p2)(prime))
println("Differentation (including of products):")
println("p₁' = ", derivative(p1))
println("(p₁ * p₂)' = ", derivative(p1 * p2), " = ", derivative(p1) * p2 + p1 * derivative(p2), " = p₁' * p₂ + p₁ * p₂'")

factorisation = factor(p1 * p2, prime)

println("Factorisation modulo a prime has also been implemented.")
println("p₁ factored mod $(prime) = ", factor(p1, prime))
println("p₁ * p₂ factored mod $(prime) = ", factorisation)

println("We can also construct p₁ * p₂ again using its facotrisation from above: ", mod(expand_factorization(factorisation), prime))
