#############################################################################
#############################################################################
#
# This file defines the polynomial type with several operations 
#                                                                               
#############################################################################
#############################################################################

###########################################
# Abstract polynomial type and operations #
###########################################

"""
Abstract polynomial type
"""
abstract type AbsPoly end

"""
This function maintains the invariant of the Polynomial type so that there are no zero terms beyond the highest
non-zero term.
"""
function trim!(p::AbsPoly)::AbsPoly
    i = length(p.terms)
    while i > 1
        if iszero(p.terms[i])
            pop!(p.terms)
        else
            break
        end
        i -= 1
    end
    return p
end

"""
Construct a polynomial of the form x^p-x.
"""
function (cyclotonic_polynomial(p::Int, ::Type{P})::P) where P <: AbsPoly
    if P == Polynomial
        return P([Term(1,p), Term(-1,0)])
    else
        return P([TermBig(1,p), TermBig(-1,0)])
    end
end

"""
Construct a polynomial of the form x-n.
"""
function linear_monic_polynomial(n::Int, ::Type{P}) where {P <: AbsPoly}
    if P == Polynomial
        return P([Term(1,1), Term(-n,0)])
    else
        return P([TermBig(1,1), TermBig(-n,0)])
    end
end

"""
Construct a polynomial of the form x.
"""
function x_poly(::Type{P}) where P <: AbsPoly 
    if P == Polynomial
        P(Term(1,1))
    else
        P(TermBig(1,1))
    end
end

"""
Creates the zero polynomial.
"""
(zero(::Type{P})::P) where P <: AbsPoly = P()

"""
Creates the unit polynomial.
"""
function (one(::Type{P})::P) where P <: AbsPoly
    if P == Polynomial 
        P(one(Term))
    else
        P(one(TermBig))
    end
end
one(p::AbsPoly) = one(typeof(p))

"""
Generates a random polynomial.
"""
function rand(::Type{P} ; 
                degree::Int = -1, 
                terms::Int = -1, 
                max_coeff::Int = 100, 
                mean_degree::Float64 = 5.0,
                prob_term::Float64  = 0.7,
                monic = false,
                condition = (p)->true) where P <: AbsPoly
        
    while true 
        _degree = degree == -1 ? rand(Poisson(mean_degree)) : degree
        _terms = terms == -1 ? rand(Binomial(_degree,prob_term)) : terms
        degrees = vcat(sort(sample(0:_degree-1,_terms,replace = false)),_degree)
        coeffs = rand(1:max_coeff,_terms+1)
        monic && (coeffs[end] = 1)
        if P == Polynomial
            p = P( [Term(coeffs[i],degrees[i]) for i in 1:length(degrees)] )
        else
            p = P( [TermBig(coeffs[i],degrees[i]) for i in 1:length(degrees)] )
        end
        condition(p) && return p
    end
end

###########
# Display #
###########

"""
Show a polynomial.
"""
function show(io::IO, p::AbsPoly)
    if iszero(p)
        print(io,"0")
    else
        n = length(p.terms)
        if (@isdefined lowest_to_highest) && lowest_to_highest == true
            for (i,t) in enumerate(p.terms)
                if !iszero(t)
                    print(io, i == 1 ? t : (t.coeff < 0 ? " - $(string(t)[2:end])" : " + $t"))  # if coefficient is negative, print minus sign
                end
            end
        else
            for (i,t) in enumerate(reverse(p.terms))  # if lowest_to_highest is false, print polynomial in descending order
                if !iszero(t)
                    print(io, i == 1 ? t : (t.coeff < 0 ? " - $(string(t)[2:end])" : " + $t"))  # if coefficient is negative, print minus sign
                end
            end
        end
    end
end

##############################################
# Iteration over the terms of the polynomial #
##############################################

"""
Allows to do iteration over the non-zero terms of the polynomial. This implements the iteration interface.
"""
iterate(p::AbsPoly, state=1) = iterate(p.terms, state)

##############################
# Queries about a polynomial #
##############################

"""
The number of terms of the polynomial.
"""
length(p::AbsPoly) = length(p.terms) 

"""
The leading term of the polynomial.
"""
function leading(p::P) where P <: AbsPoly
    if P == Polynomial
        return isempty(p.terms) ? zero(Term) : last(p.terms) 
    else
        return isempty(p.terms) ? zero(TermBig) : last(p.terms)
    end
end

"""
Returns the coefficients of the polynomial.
"""
coeffs(p::AbsPoly) = [t.coeff for t in p]

"""
The degree of the polynomial.
"""
degree(p::AbsPoly)::Int = leading(p).degree 

"""
The content of the polynomial is the GCD of its coefficients.
"""
content(p::AbsPoly)::Int = euclid_alg(coeffs(p))

"""
Evaluate the polynomial at a point `x`.
"""
evaluate(f::AbsPoly, x::T) where T <: Number = sum(evaluate(t,x) for t in f)

"""
Check if the polynomial is zero.
"""
function iszero(p::P)::Bool where P <: AbsPoly
    if P == Polynomial
        p.terms == [Term(0,0)]
    else
        p.terms == [TermBig(0,0)]
    end
end

#################################################################
# Transformation of the polynomial to create another polynomial #
#################################################################

"""
The negative of a polynomial.
"""
-(p::P) where P <: AbsPoly = P(map((pt)->-pt, p.terms))

"""
Create a new polynomial which is the derivative of the polynomial.
"""
function derivative(p::P)::P where P <: AbsPoly 
    der_p = P()
    for term in p
        der_term = derivative(term)
        !iszero(der_term) && push!(der_p,der_term)
    end
    return trim!(der_p)
end

"""
The prim part (multiply a polynomial by the inverse of its content).
"""
prim_part(p::AbsPoly) = p ÷ content(p)


"""
A square free polynomial.
"""
square_free(p::AbsPoly, prime::Int)::AbsPoly = (p ÷ gcd(p,derivative(p),prime))(prime)

#################################
# Queries about two polynomials #
#################################

"""
Check if two polynomials are the same
"""
(==(p1::P, p2::P)::Bool) where P <: AbsPoly = p1.terms == p2.terms


"""
Check if a polynomial is equal to 0.
"""
#Note that in principle there is a problem here. E.g The polynomial 3 will return true to equalling the integer 2.
==(p::AbsPoly, n::T) where T <: Real = iszero(p) == iszero(n)

##################################################################
# Operations with two objects where at least one is a polynomial #
##################################################################

"""
Subtraction of two polynomials.
"""
-(p1::AbsPoly, p2::AbsPoly)::AbsPoly = p1 + (-p2)


"""
Multiplication of polynomial and term.
"""
function *(t::T, p1::P)::P where {T <: AbsTerm, P <: AbsPoly}
    iszero(t) ? P() : P(map((pt)->t*pt, p1.terms))
end
*(p1::AbsPoly, t::AbsTerm)::AbsPoly = t*p1

"""
Multiplication of polynomial and an integer.
"""
function *(n::Integer, p::P)::P where P <: AbsPoly
    if P == Polynomial
        p*Term(n,0)
    else
        p*TermBig(n,0)
    end
end
*(p::AbsPoly, n::Integer)::AbsPoly = n*p

"""
Integer division of a polynomial by an integer.

Warning this may not make sense if n does not divide all the coefficients of p.
"""
÷(p::P, n::Integer) where P <: AbsPoly = (prime)->P(map((pt)->((pt ÷ n)(prime)), p.terms))

"""
Take the mod of a polynomial with an integer.
"""
function mod(f::P, p::Integer)::P where P <: AbsPoly
    f_out = P()
    for i in 1:length(f.terms)
        term = mod(f.terms[i], p)
        !iszero(term) && push!(f_out, term)
    end
    return trim!(f_out)
end

"""
Take the symmetric mod of a polynomial with an integer.
"""
function smod(f::P, p::Integer)::P where P <: AbsPoly
    f_out = P()
    for i in 1:length(f.terms)
        term = smod(f.terms[i], p)
        !iszero(term) && push!(f_out, term)
    end
    return trim!(f_out)
end

"""
Power of a polynomial mod prime.
"""
function pow_mod(p::P, n::Int, prime::Int) where P <: AbsPoly
    n < 0 && error("No negative power")
    n == 0 && return one(p)

    out = one(p)
    squares = p

    # find truncated binary representation of the exponent; starts from the first 1 in the string
    n_trunc_bin = reverse(bitstring(n)[findfirst('1', bitstring(n)):end])  # reverse for purposes of computation

    # iterate through in reverse order
    for b in n_trunc_bin
        # square the given term in iteration and if bit (b) is 1, multiply out by the current value of squares
        if parse(Int, b) == 1
            out = mod(out * squares, prime)
        end

        squares *= squares
    end

    return out
end

####################################
# Polynomial type and construction #
####################################

"""
A Polynomial type - designed to be for polynomials with integer coefficients.
"""
struct Polynomial <: AbsPoly

    #A zero packed vector of terms
    #Terms are assumed to be in order
    #until the degree of the polynomial. The leading term (i.e. last) is assumed to be non-zero except 
    #for the zero polynomial where the vector is of length 1.
    #Note: at positions where the coefficient is 0, the power of the term is also 0 (this is how the Term type is designed)
    #The maximum length allowed for the vector is max_degree+1
    terms::Vector{Term}   
    
    #Inner constructor of 0 polynomial
    Polynomial() = new([zero(Term)])

    #Inner constructor of polynomial based on arbitrary list of terms
    function Polynomial(vt::Vector{Term})

        #Filter the vector so that there is not more than a single zero term
        vt = filter((t)->!iszero(t), vt)
        if isempty(vt)
            vt = [zero(Term)]
        end

        max_degree = maximum((t)->t.degree, vt)
        terms = [zero(Term) for i in 0:max_degree] #First set all terms with zeros

        #now update based on the input terms
        for t in vt
            terms[t.degree + 1] = t #+1 accounts for 1-indexing
        end
        return new(terms)
    end
end

"""
Construct a polynomial with a single term.
"""
Polynomial(t::Term) = Polynomial([t])

################################
# Pushing and popping of terms #
################################

"""
Push a new term into the polynomial.
"""
#Note that ideally this would throw and error if pushing another term of degree that is already in the polynomial
function push!(p::Polynomial, t::Term)
    if t.degree <= degree(p)
        p.terms[t.degree + 1] = t
    else
        append!(p.terms, zeros(Term, t.degree - degree(p)-1))
        push!(p.terms, t)
    end
    return p        
end

"""
Pop the leading term out of the polynomial. When polynomial is 0, keep popping out 0.
"""
function pop!(p::Polynomial)::Term 
    popped_term = pop!(p.terms) #last element popped is leading coefficient

    while !isempty(p.terms) && iszero(last(p.terms))
        pop!(p.terms)
    end

    if isempty(p.terms)
        push!(p.terms, zero(Term))
    end

    return popped_term
end