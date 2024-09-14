#############################################################################
#############################################################################
#
# This file defines the Term type with several operations 
#                                                                               
#############################################################################
#############################################################################

#####################################
# Abstract Term type and operations #
#####################################

abstract type AbsTerm end

"""
Creates the zero term.
"""
(zero(::Type{T})::T) where T <: AbsTerm = T(0,0)

"""
Creates the unit term.
"""
(one(::Type{T})::T) where T <: AbsTerm = T(1,0)

########################
# Queries about a term #
########################

"""
Check if a term is 0.
"""
(iszero(t::T)::Bool) where T <: AbsTerm = iszero(t.coeff)

"""
Compare two terms.
"""
(isless(t1::T,t2::T)::Bool) where T <: AbsTerm =  t1.degree == t2.degree ? (t1.coeff < t2.coeff) : (t1.degree < t2.degree)  

"""
Evaluate a term at a point x.
"""
evaluate(t::A, x::T) where {A <: AbsTerm, T <: Number} = t.coeff * x^t.degree

##########################
# Operations with a term #
##########################

"""
Add two terms of the same degree.
"""
function +(t1::T,t2::T)::T where T <: AbsTerm
    @assert t1.degree == t2.degree
    T(t1.coeff + t2.coeff, t1.degree)
end

"""
Negate a term.
"""
-(t::T,) where T <: AbsTerm = T(-t.coeff,t.degree)  

"""
Subtract two terms with the same degree.
"""
(-(t1::T, t2::T)::T) where T <: AbsTerm = t1 + (-t2) 

"""
Multiply two terms.
"""
(*(t1::T, t2::T)::T) where T <: AbsTerm = T(t1.coeff * t2.coeff, t1.degree + t2.degree)


"""
Compute the symmetric mod of a term with an integer.
"""
mod(t::T, p::Integer) where T <: AbsTerm = T(mod(t.coeff,p), t.degree)

"""
Compute the derivative of a term.
"""
derivative(t::T) where T <: AbsTerm = T(t.coeff*t.degree,max(t.degree-1,0))

"""
Divide two terms. Returns a function of an integer.
"""
function ÷(t1::T,t2::T) where T <: AbsTerm
    @assert t1.degree ≥ t2.degree
    f(p::Int)::T = T(mod((t1.coeff * int_inverse_mod(t2.coeff, p)), p), t1.degree - t2.degree)
end

"""
Integer divide a term by an integer.
"""
÷(t::T, n::Integer) where T <: AbsTerm = t ÷ T(n,0)

###########
# Display #
###########

"""
Print a number in unicode superscript.
"""
function number_superscript(i::Int)
    if i < 0
        c = [Char(0x207B)]  # superscript minus sign
    else
        c = []
    end

    # digits separates the digits of i into an array in reverse order (right to left); this order must be reversed for correct printing
    for j in reverse(digits(abs(i)))
        # 1, 2 and 3 do not follow the same unicode pattern as 4 onwards
        if j == 0
            push!(c, Char(0x2070))
        elseif j == 1
            push!(c, Char(0x00B9))
        elseif j == 2
            push!(c, Char(0x00B2))
        elseif j == 3
            push!(c, Char(0x00B3))
        else
            push!(c, Char(0x2070+j))
        end
    end
    return join(c)
end

"""
Show a term.
"""
function show(io::IO, t::T) where T <: AbsTerm
    t.degree == 0 && return print(io, "$(t.coeff)")  # do not print x for constant terms
    if abs(t.coeff) == 1  # do not print coefficient 1 explicitly
        t.degree == 1 ? print(io, "x") : print(io, "x$(number_superscript(t.degree))")
    else # do not print exponent if degree is 1; otherwise print exponent with unicode superscript
        t.degree == 1 ? print(io, "$(t.coeff)⋅x") : print(io, "$(t.coeff)⋅x$(number_superscript(t.degree))")
    end
end