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
    @time factor_test_poly()
    @time factor_test_polyBig()
    @time big_factor_test_poly()
end

"""
Test factorization of polynomials.
"""
function factor_test_poly(;N::Int = 10, seed::Int = 0, primes::Vector{Int} = [5,11,17])
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
function factor_test_polyBig(;N::Int = 10, seed::Int = 0, primes::Vector{Int} = [5,11,17])
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

"""
Test factorization of large BigInt polynomial
"""
function big_factor_test_poly(;N::Int = 13, seed::Int = 0, prime = 17)
    Random.seed!(seed)
    prod = PolynomialBig(TermBig(1,0))
    p_base = PolynomialBig(TermBig(1,0))
    for _ in 1:N
        p = rand(PolynomialBig)
        prod = p_base*p
        @assert leading(prod) == leading(p_base)*leading(p)
        p_base = prod
    end
    @show prod
    factorization = factor(prod, prime)
    pr = mod(expand_factorization(factorization),prime)
    @assert mod(prod-pr,prime) == 0

    println("big_factor_test_poly - PASSED")
end