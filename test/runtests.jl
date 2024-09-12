#############################################################################
#############################################################################
#
# A script that runs all unit tests in the project.
#                                                                               
#############################################################################
#############################################################################

using Pkg
Pkg.activate(".")

include("../poly_factorization_project.jl")

include("factorization_test.jl")
include("integers_test.jl")
include("polynomial_derivative_test.jl")
include("polynomial_division_test.jl")
include("polynomial_ext_euclid_test.jl")
include("polynomial_overflow_test.jl")
include("polynomial_product_test.jl")

# Executes and times integer tests
println("--- Integer tests ---")
@time integers_tests()

# Executes and times factorization tests
println("--- Polynomial factorization tests ---")
@time factorization_tests()

# Executes and times polynomial derivative tests
println("--- Polynomial derivative tests ---")
@time polynomial_derivative_tests()

# Executes and times polynomial division tests
println("--- Polynomial divison tests ---")
@time polynomial_division_tests()

# Executes and times polynomial extended euclidean algorithm tests
println("--- Polynomial extended euclidean algorithm tests ---")
@time polynomial_ext_euclid_tests()

#Executes and times polynomial product tests
println("--- Polynomial product tests ---")
polynomial_product_tests()

#Executes and times polynomial overflow tests
println("--- Polynomial overflow tests ---")
@time polynomial_overflow_tests()