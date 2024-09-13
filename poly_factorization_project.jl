#############################################################################
#############################################################################
#
# This is the main project file for polynomial factorization
#                                                                               
#############################################################################
#############################################################################

using Distributions, StatsBase, Random, Primes

import Base: %
import Base: push!, pop!, iszero, show, isless, map, map!, iterate, length, last
import Base: +, -, *, mod, %, ÷, ==, ^, rand, rem, zero, one

lowest_to_highest = false

include("src/general_alg.jl")

include("src/term_abstract.jl")
include("src/term.jl")
include("src/termBig.jl")

include("src/polynomial.jl")
include("src/polynomialBig.jl")
include("src/PolynomialModP.jl")
    include("src/basic_polynomial_operations/polynomial_addition.jl")
    include("src/basic_polynomial_operations/polynomial_multiplication.jl")
    include("src/basic_polynomial_operations/polynomial_division.jl")
    include("src/basic_polynomial_operations/polynomial_gcd.jl")
include("src/polynomial_factorization/factor.jl")

nothing