#############################################################################
#############################################################################
#
# This file contains units tests for polynomial product operations
#                                                                               
#############################################################################
#############################################################################

"""
Executes all polynomial product tests in this file.
"""
function polynomial_product_tests()
    @time prod_test_poly()
    @time prod_test_polyBig()
    @time prod_test_polyModP()
end

"""
Test product of polynomials.
"""
function prod_test_poly(;N::Int = 100, N_prods::Int = 10, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        prod = p1*p2
        @assert leading(prod) == leading(p1)*leading(p2)
    end

    for _ in 1:N
        p_base = Polynomial(Term(1,0))
        for _ in 1:N_prods
            p = rand(Polynomial)
            prod = p_base*p
            @assert leading(prod) == leading(p_base)*leading(p)
            p_base = prod
        end
    end
    println("prod_test_poly - PASSED")
end

"""
Test product of BigInt polynomials.
"""
function prod_test_polyBig(;N::Int = 100, N_prods::Int = 10, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialBig)
        p2 = rand(PolynomialBig)
        prod = p1*p2
        @assert leading(prod) == leading(p1)*leading(p2)
    end

    for _ in 1:N
        p_base = PolynomialBig(TermBig(1,0))
        for _ in 1:N_prods
            p = rand(PolynomialBig)
            prod = p_base*p
            @assert leading(prod) == leading(p_base)*leading(p)
            p_base = prod
        end
    end
    println("prod_test_polyBig - PASSED")
end

"""
Test product of polynomials modulo some prime.
"""
function prod_test_polyModP(; N::Int=100, N_prods::Int=10, seed::Int=0)
    Random.seed!(seed)
    for _ in 1:N
        # make sure we are using the same prime for p1 and p2
        rand_prime = prime(rand(1:100))
        p1 = rand(PolynomialModP, p=rand_prime)
        p2 = rand(PolynomialModP, p=rand_prime)
        prod = p1 * p2
        @assert leading(prod) == mod(leading(p1) * leading(p2), rand_prime)
    end

    for _ in 1:N
        rand_prime = prime(rand(1:100))
        p_base = PolynomialModP(Polynomial(Term(1, 0)), rand_prime)
        for _ in 1:N_prods
            p = rand(PolynomialModP, p=rand_prime)
            prod = p_base * p
            @assert (leading(prod.polynomial) ==
                mod(leading(p_base.polynomial) * leading(p.polynomial), rand_prime))
            p_base = prod
        end
    end
    println("prod_test_polyModP - PASSED")
end