##############################
# TermBig type and construction #
##############################

"""
A TermBig.
"""
struct TermBig <: AbsTerm  #structs are immutable by default
    coeff::BigInt
    degree::Int
    function TermBig(coeff::Integer, degree::Int)
        degree < 0 && error("Degree must be non-negative")
        coeff != 0 ? new(big(coeff),degree) : new(big(coeff),0)
    end
end

"""
Define equality for TermBig
"""
==(a::TermBig, b::TermBig) = (a.coeff == b.coeff) && (a.degree == b.degree)