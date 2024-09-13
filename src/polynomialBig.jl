#############################################################################
#############################################################################
#
# This file defines the polynomial type with several operations 
#                                                                               
#############################################################################
#############################################################################

#######################################
# PolynomialBig type and construction #
#######################################

"""
A PolynomialBig type - designed to be for polynomials with integer coefficients.
"""
struct PolynomialBig <: AbsPoly

    #A zero packed vector of terms
    #Terms are assumed to be in order
    #until the degree of the polynomial. The leading term (i.e. last) is assumed to be non-zero except 
    #for the zero polynomial where the vector is of length 1.
    #Note: at positions where the coefficient is 0, the power of the term is also 0 (this is how the TermBig type is designed)
    #The maximum length allowed for the vector is max_degree+1
    terms::Vector{TermBig}
    
    #Inner constructor of 0 polynomial
    PolynomialBig() = new([zero(TermBig)])

    #Inner constructor of polynomial based on arbitrary list of terms
    function PolynomialBig(vt::Vector{TermBig})

        #Filter the vector so that there is not more than a single zero term
        vt = filter((t)->!iszero(t), vt)
        if isempty(vt)
            vt = [zero(TermBig)]
        end

        max_degree = maximum((t)->t.degree, vt)
        terms = [zero(TermBig) for i in 0:max_degree] #First set all terms with zeros

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
PolynomialBig(t::TermBig) = PolynomialBig([t])

################################
# Pushing and popping of terms #
################################

"""
Push a new term into the polynomial.
"""
#Note that ideally this would throw and error if pushing another term of degree that is already in the polynomial
function push!(p::PolynomialBig, t::TermBig)
    if t.degree <= degree(p)
        p.terms[t.degree + 1] = t
    else
        append!(p.terms, zeros(TermBig, t.degree - degree(p)-1))
        push!(p.terms, t)
    end
    return p        
end

"""
Pop the leading term out of the polynomial. When polynomial is 0, keep popping out 0.
"""
function pop!(p::PolynomialBig)::TermBig 
    popped_term = pop!(p.terms) #last element popped is leading coefficient

    while !isempty(p.terms) && iszero(last(p.terms))
        pop!(p.terms)
    end

    if isempty(p.terms)
        push!(p.terms, zero(TermBig))
    end

    return popped_term
end