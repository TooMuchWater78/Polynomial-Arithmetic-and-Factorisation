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
include("polynomial_power_test.jl")

# Executes and times integer tests
println("--- Integer tests ---")
integers_tests()

# Executes and times factorization tests
println("--- Polynomial factorization tests ---")
factorization_tests()

# Executes and times polynomial derivative tests
println("--- Polynomial derivative tests ---")
polynomial_derivative_tests()

# Executes and times polynomial division tests
println("--- Polynomial divison tests ---")
polynomial_division_tests()

# Executes and times polynomial extended euclidean algorithm tests
println("--- Polynomial extended euclidean algorithm tests ---")
polynomial_ext_euclid_tests()

# Executes and times polynomial product tests
println("--- Polynomial product tests ---")
polynomial_product_tests()

# Executes and times polynomial overflow tests
println("--- Polynomial overflow tests ---")
polynomial_overflow_tests()

# Executes and times polynomial power tests
println("--- Polynomial power tests ---")
polynomial_power_tests()