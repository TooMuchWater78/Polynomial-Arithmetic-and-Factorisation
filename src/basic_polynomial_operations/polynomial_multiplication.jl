#############################################################################
#############################################################################
#
# This file implements polynomial multiplication 
#                                                                               
#############################################################################
#############################################################################

"""
Multiply two polynomials.
"""
function *(p1::P, p2::P)::P where P <: AbsPoly
    p_out = P()
    for t in p1
        new_summand = (t * p2)
        p_out = p_out + new_summand
    end
    return p_out
end
function *(p1::PolynomialModP, p2::PolynomialModP)
    @assert p1.prime == p2.prime
    return PolynomialModP(mod(p1.polynomial * p2.polynomial, p1.prime), p1.prime)
end

"""
Power of a polynomial.
"""
function ^(p::AbsPoly, n::Int)::AbsPoly
    n < 0 && error("No negative power")
    out = one(p)
    for _ in 1:n
        out *= p
    end
    return out
end
function ^(p::PolynomialModP, n::Int)::PolynomialModP
    return PolynomialModP(mod(^(p.polynomial, n), p.prime), p.prime)
end

