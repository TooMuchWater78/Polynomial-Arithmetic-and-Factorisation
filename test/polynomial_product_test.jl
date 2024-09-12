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