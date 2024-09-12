#############################################################################
#############################################################################
#
# This file contains tests for polynomial operations that could overflow
#                                                                               
#############################################################################
#############################################################################

function polynomial_overflow_tests()
    poly_overflow()
    polyBig_overflow()
end

"""
Tests whether a polynomial can overflow (note: should fail).
"""
function poly_overflow(; N::Int = 128)
    p = x_poly(Polynomial)
    for _ in 1:N
        @assert leading(p*2) > leading(p)
        p *= 2
    end
    println("poly_overflow - PASSED")
end

"""
Tests whether a BigInt polynomial can overflow.
"""
function polyBig_overflow(; N::Int = 128)
    p = x_poly(PolynomialBig)
    for _ in 1:N
        @assert leading(p*2) > leading(p)
        p *= 2
    end
    println("polyBig_overflow - PASSED")
end