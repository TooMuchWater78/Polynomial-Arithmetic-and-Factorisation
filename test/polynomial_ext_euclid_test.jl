#############################################################################
#############################################################################
#
# This file contains units tests for extended euclidean algorithm polynomial
# operations
#                                                                               
#############################################################################
#############################################################################

"""
Executes all extended euclidean algorithm tests in this file.
"""
function polynomial_ext_euclid_tests()
    ext_euclid_test_poly()
    ext_euclid_test_polyBig()
end

"""
Test the extended euclid algorithm for polynomials modulo p.
"""
function ext_euclid_test_poly(;prime::Int=101, N::Int = 10^3, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        g, s, t = extended_euclid_alg(p1, p2, prime)
        @assert mod(s*p1 + t*p2 - g, prime) == 0
    end
    println("ext_euclid_test_poly - PASSED")
end

"""
Test the extended euclid algorithm for BigInt polynomials modulo p.
"""
function ext_euclid_test_polyBig(;prime::Int=101, N::Int = 10^3, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialBig)
        p2 = rand(PolynomialBig)
        g, s, t = extended_euclid_alg(p1, p2, prime)
        @assert mod(s*p1 + t*p2 - g, prime) == 0
    end
    println("ext_euclid_test_polyBig - PASSED")
end