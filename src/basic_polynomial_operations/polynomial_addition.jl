#############################################################################
#############################################################################
#
# This file implements polynomial addition 
#                                                                               
#############################################################################
#############################################################################

"""
Add a polynomial and a term.
"""
function +(p::Polynomial, t::Term)
    p = deepcopy(p)
    if t.degree > degree(p)
        push!(p, t)
    else
        if !iszero(p.terms[t.degree + 1]) #+1 is due to indexing
            p.terms[t.degree + 1] += t
        else
            p.terms[t.degree + 1] = t
        end
    end

    return trim!(p)
end
+(t::Term, p::Polynomial) = p + t

"""
Add a PolynomialBig and a TermBig.
"""
function +(p::PolynomialBig, t::TermBig)
    p = deepcopy(p)
    if t.degree > degree(p)
        push!(p, t)
    else
        if !iszero(p.terms[t.degree + 1]) #+1 is due to indexing
            p.terms[t.degree + 1] += t
        else
            p.terms[t.degree + 1] = t
        end
    end

    return trim!(p)
end
+(t::TermBig, p::PolynomialBig) = p + t

"""
Add two polynomials.
"""
function +(p1::AbsPoly, p2::AbsPoly)::AbsPoly
    p = deepcopy(p1)
    for t in p2
        p += t
    end
    return p
end

"""
Add a polynomial and an integer.
"""
function +(p::P, n::Int) where P <: AbsPoly
    if P == Polynomial
        p + Term(n,0)
    else
        p + TermBig(n,0)
    end
end

function +(n::Int, p::P) where P <: AbsPoly
    if P == Polynomial
        p + Term(n,0)
    else
        p + TermBig(n,0)
    end
end