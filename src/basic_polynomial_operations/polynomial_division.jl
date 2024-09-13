#############################################################################
#############################################################################
#
# This file implements polynomial division 
#                                                                               
#############################################################################
#############################################################################

"""  Modular algorithm.
f divide by g

f = q*g + r

p is a prime
"""
function divide(num::P, den::P) where P <: AbsPoly
    function division_function(p::Int)
        f, g = mod(num,p), mod(den,p)
        degree(f) < degree(num) && return nothing 
        iszero(g) && throw(DivideError())
        q = P()
        prev_degree = degree(f)
        while degree(f) ≥ degree(g) 
            h = P( (leading(f) ÷ leading(g))(p) )  #syzergy 
            f = mod((f - h*g), p)
            q = mod((q + h), p)  
            prev_degree == degree(f) && break
            prev_degree = degree(f)
        end
        @assert iszero(mod((num - (q*g + f)),p))
        return q, f
    end
    return division_function
end
function divide(num::PolynomialModP, den::PolynomialModP)
    @assert num.prime == den.prime
    return divide(num.polynomial, den.polynomial)(num.prime)
end

"""
The quotient from polynomial division. Returns a function of an integer.
"""
÷(num::AbsPoly, den::AbsPoly)  = (p::Int) -> first(divide(num,den)(p))
÷(num::PolynomialModP, den::PolynomialModP) = begin
    @assert num.prime == den.prime
    return ÷(num.polynomial, den.polynomial)(num.prime)
end

"""
The remainder from polynomial division. Returns a function of an integer.
"""
rem(num::AbsPoly, den::AbsPoly)  = (p::Int) -> last(divide(num,den)(p))
rem(num::PolynomialModP, den::PolynomialModP) = begin
    @assert num.prime == den.prime
    return rem(num.polynomial, den.polynomial)(num.prime)
end