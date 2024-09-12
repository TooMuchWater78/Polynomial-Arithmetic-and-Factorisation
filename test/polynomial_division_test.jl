#############################################################################
#############################################################################
#
# This file contains units tests for polynomial division operations
#                                                                               
#############################################################################
#############################################################################

"""
Executes all polynomial division tests in this file.
"""
function polynomial_division_tests()
    division_test_poly()
    division_test_polyBig()
end

"""
Test division of polynomials modulo p.
"""
function division_test_poly(;prime::Int = 101, N::Int = 10^4, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        p_prod = p1*p2
        q, r = Polynomial(), Polynomial()
        try
            q, r = divide(p_prod, p2)(prime)
            if (q, r) == (nothing,nothing)
                println("Unlucky prime: $p1 is reduced to $(p1 % prime) modulo $prime")
                continue
            end
        catch e
            if typeof(e) == DivideError
                @assert mod(p2, prime) == 0
            else
                throw(e)
            end
        end
        @assert iszero( mod(q*p2+r - p_prod, prime) )
    end
    println("division_test_poly - PASSED")
end

"""
Test division of BigInt polynomials modulo p.
"""
function division_test_polyBig(;prime::Int = 101, N::Int = 10^4, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialBig)
        p2 = rand(PolynomialBig)
        p_prod = p1*p2
        q, r = PolynomialBig(), PolynomialBig()
        try
            q, r = divide(p_prod, p2)(prime)
            if (q, r) == (nothing,nothing)
                println("Unlucky prime: $p1 is reduced to $(p1 % prime) modulo $prime")
                continue
            end
        catch e
            if typeof(e) == DivideError
                @assert mod(p2, prime) == 0
            else
                throw(e)
            end
        end
        @assert iszero( mod(q*p2+r - p_prod, prime) )
    end
    println("division_test_polyBig - PASSED")
end