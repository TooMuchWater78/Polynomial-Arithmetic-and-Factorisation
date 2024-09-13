#############################################################################
#############################################################################
#
# This file defines the PolynomialModP type with several operations 
#                                                                               
#############################################################################
#############################################################################

########################################
# PolynomialModP type and construction #
########################################

"""
A PolynomialModP type - holds a Polynomial and a prime number.
"""
struct PolynomialModP <: AbsPoly
    polynomial::Polynomial
    primt::Integer

    # Inner constructor of PolynomialModP
    function PolynomialModP(p::Polynomial, prime::Integer)
        @assert isprime(prime)
        terms = map((term) -> Term(mod(term.coeff, prime), term.degree), p.terms)
        p = Polynomial(terms)
        return new(p, prime)
    end
end

"""
Constructor that takes a PolynomialBig and converts it to a Polynomial
"""
function PolynomialModP(p::PolynomialBig, prime::Integer)
    terms = map((term) -> Term(Int(mod(term.coeff, prime)), term.degree), p.terms)
    p = Polynomial(terms)
    return PolynomialModP(p, prime)
end

one(::Type{PolynomialModP}, prime::Int) = PolynomialModP(Polynomial(one(Term)), prime)
one(p::Polynomial, prime::Int) = one(typeof(p), prime)

###########
# Display #
###########
function show(io::IO, p::PolynomialModP)
    show(io, p.polynomial)
    print(io, " (mod $(p.prime))")
end

################################################
# Iteration over the terms of a PolynomialModP #
################################################

"""
Iteration over non-zero terms of a PolynomialModP. This implements the iteration interface.
"""
iterate(p::PolynomialModP, state=1) = iterate(p.polynomial)

##################################
# Queries about a PolynomialModP #
##################################

"""
Number of terms of the polynomial.
"""
length(p::PolynomialModP) = length(p.polynomial)

"""
The leading term of the polynomial.
"""
leading(p::PolynomialModP)::Term = leading(p.polynomial)

"""
Returns the coefficients of the polynomial.
"""
coeffs(p::PolynomialModP)::Vector{Int} = coeffs(p.polynomial)

"""
The degree of the polynomial.
"""
degree(p::PolynomialModP)::Int = degree(p.polynomial)

"""
The content of the polynomial is the GCD of its coefficients.
"""
content(p::PolynomialModP)::Int = content(p.polynomial)

"""
Evaluate the polynomial at a point `x`.
"""
evaluate(f::PolynomialModP, x::T) where {T<:Number} = evaluate(f.polynomial, x)

"""
Check if the polynomial is zero.
"""
iszero(p::PolynomialModP)::Bool = iszero(p.polynomial)

################################
# Pushing and popping of terms #
################################

"""
Push a new term into the polynomial.
"""
push!(p::PolynomialModP, t::Term) = push!(p.polynomial, t)

"""
Pop the leading term out of the polynomial.
"""
pop!(p::PolynomialModP)::Term = pop!(p.polynomial)

#################################################################
# Transformation of the polynomial to create another polynomial #
#################################################################

"""
The negative of a polynomial.
"""
-(p::PolynomialModP) = PolynomialModP(-(p.polynomial), p.prime)

"""
Create a new polynomial which is the derivative of the polynomial.
"""
function derivative(p::PolynomialModP)::PolynomialModP
    PolynomialModP(derivative(p.polynomial), p.prime)
end

"""
The prim part (multiply a polynomial by the inverse of its content).
"""
prim_part(p::PolynomialModP) = PolynomialModP(prim_part(p.polynomial)(p.prime), p.prime)

"""
A square free polynomial.
"""
function square_free(p::PolynomialModP)::PolynomialModP
    PolynomialModP(square_free(p.polynomial, p.prime)(p.prime), p.prime)
end

#################################
# Queries about two polynomials #
#################################

"""
Check if two polynomials are the same.
"""
function ==(p1::PolynomialModP, p2::PolynomialModP)::Bool
    p1.polynomial == p2.polynomial && p1.prime == p2.prime
end

"""
Check if a polynomial is equal to 0.
"""
# Note that in principle there is a problem here. E.g The polynomial 3 will return true to
# equalling the integer 2.
==(p::PolynomialModP, n::T) where {T<:Real} = ==(p.polynomial, n)

##################################################################
# Operations with two objects where at least one is a polynomial #
##################################################################

"""
Subtraction of two polynomials.
"""
function -(p1::PolynomialModP, p2::PolynomialModP)::PolynomialModP
    @assert p1.prime == p2.prime
    PolynomialModP(p1.polynomial + (-p2.polynomial), p1.prime)
end

"""
Multiplication of polynomial and term.
"""
function *(t::Term, p1::PolynomialModP)::PolynomialModP
    PolynomialModP(*(t, p1.polynomial), p.prime)
end

"""
Multiplication of polynomial and an integer.
"""
function *(n::Integer, p::PolynomialModP)::PolynomialModP
    PolynomialModP(*(n, p.polynomial), p.prime)
end

"""
Integer division of a polynomial by an integer.

Warning this may not make sense if n does not divide all the coefficients of p.
"""
÷(p::PolynomialModP, n::Int) = PolynomialModP(÷(p.polynomial, n)(p.prime), p.prime)

"""
Power of a polynomial mod prime.
"""
pow_mod(p::Polynomial, n::Int, prime::Int) = (PolynomialModP(p, prime)^n).polynomial
pow_mod(p::PolynomialModP, n::Int) = PolynomialModP(pow_mod(p.polynomial, n, p.prime), p.prime)

"""
Generate a random polynomial.
"""
function rand(::Type{PolynomialModP};
    degree::Int=-1,
    terms::Int=-1,
    max_coeff::Int=100,
    mean_degree::Float64=5.0,
    prob_term::Float64=0.7,
    monic=false,
    condition=(p) -> true,
    p::Int = 0)::PolynomialModP

    # randomly pick a prime if one hasn't been provided
    p = p == 0 ? prime(rand(1:100)) : p

    PolynomialModP(
        rand(Polynomial,
             degree=degree,
             terms=terms,
             max_coeff=max_coeff,
             mean_degree=mean_degree,
             prob_term=prob_term,
             monic=monic,
             condition=condition),
        p)
end