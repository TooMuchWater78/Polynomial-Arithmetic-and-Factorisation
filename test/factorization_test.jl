#############################################################################
#############################################################################
#
# This file contains units tests for polynomial factorization
#                                                                               
#############################################################################
#############################################################################

"""
Executes all polynomial factorization tests in this file.
"""
function factorization_tests()
    factor_test_poly()
    factor_test_polyBig()
end

"""
Test factorization of polynomials.
"""
function factor_test_poly(;N::Int = 5, seed::Int = 0, primes::Vector{Int} = [5,7,23])
    Random.seed!(seed)
    for prime in primes
        print("\ndoing prime = $prime \t")
        for _ in 1:N
            print(".")
            p = rand(Polynomial)
            factorization = factor(p, prime)
            pr = mod(expand_factorization(factorization),prime)
            @assert mod(p-pr,prime) == 0 
        end
    end

    println("\nfactor_test_poly - PASSED")
end

"""
Test factorization of BigInt polynomials.
"""
function factor_test_polyBig(;N::Int = 5, seed::Int = 0, primes::Vector{Int} = [5,7,23])
    Random.seed!(seed)
    for prime in primes
        print("\ndoing prime = $prime \t")
        for _ in 1:N
            print(".")
            p = rand(PolynomialBig)
            factorization = factor(p, prime)
            pr = mod(expand_factorization(factorization),prime)
            @assert mod(p-pr,prime) == 0 
        end
    end

    println("\nfactor_test_polyBig - PASSED")
end