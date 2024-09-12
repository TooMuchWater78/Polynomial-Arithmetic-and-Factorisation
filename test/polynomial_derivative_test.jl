#############################################################################
#############################################################################
#
# This file contains units tests for polynomial derivative operations
#                                                                               
#############################################################################
#############################################################################

"""
Executes all polynomial derivative tests in this file.
"""
function polynomial_derivative_tests()
    prod_derivative_test_poly()
    prod_derivative_test_polyBig()
end

"""
Test derivative of polynomials (as well as product).
"""
function prod_derivative_test_poly(;N::Int = 10^2,  seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        p1d = derivative(p1)
        p2d = derivative(p2)
        @assert (p1d*p2) + (p1*p2d) == derivative(p1*p2)
    end
    println("prod_derivative_test_poly - PASSED")
end

"""
Test derivative of BigInt polynomials (as well as product).
"""
function prod_derivative_test_polyBig(;N::Int = 10^2,  seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialBig)
        p2 = rand(PolynomialBig)
        p1d = derivative(p1)
        p2d = derivative(p2)
        @assert (p1d*p2) + (p1*p2d) == derivative(p1*p2)
    end
    println("prod_derivative_test_polyBig - PASSED")
end