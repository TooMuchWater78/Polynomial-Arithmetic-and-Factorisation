#############################################################################
#############################################################################
#
# This file implements polynomial GCD 
#                                                                               
#############################################################################
#############################################################################

"""
The extended euclid algorithm for polynomials modulo prime.
"""
function extended_euclid_alg(a::P, b::P, prime::Int) where P <: AbsPoly
    old_r, r = mod(a, prime), mod(b, prime)
    old_s, s = one(P), zero(P)
    old_t, t = zero(P), one(P)

    while !iszero(mod(r,prime))
        q = first(divide(old_r, r)(prime))
        old_r, r = r, mod(old_r - q*r, prime)
        old_s, s = s, mod(old_s - q*s, prime)
        old_t, t = t, mod(old_t - q*t, prime)
    end
    g, s, t = old_r, old_s, old_t

    @assert mod(s*a + t*b - g, prime) == 0
    return g, s, t  
end
extended_euclid_alg(a::PolynomialModP, b::PolynomialModP, prime::Int) = begin
    return extended_euclid_alg(a.polynomial, b.polynomial, prime)
end

"""
The GCD of two polynomials modulo prime.
"""
gcd(a::AbsPoly, b::AbsPoly, prime::Int) = extended_euclid_alg(a,b,prime) |> first
function gcd(a::PolynomialModP, b::PolynomialModP)
    @assert a.prime == b.prime
    return (extended_euclid_alg(a, b, a.prime) |> first)
end