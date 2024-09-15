#############################################################################
#############################################################################
#
# This file implements polynomial multiplication 
#                                                                               
#############################################################################
#############################################################################

"""
Chinese remainder theorem for two polynomials.
"""
function poly_crt(a::AbsPoly, b::AbsPoly, n::Integer, m::Integer)::PolynomialBig
    @assert gcdx(n, m)[1] == 1
    c = PolynomialBig()
    a_index = 1  # index of term of degree k in a
    b_index = 1  # index of term of degree k in b

    for k in 0:max(degree(a), degree(b))
        # find the term of degree k in a and b; if it doesn't exist, stop at the term that would follow it
        # keep going if we aren't at the end of the array or we haven't reached the index
        while max(a_index, k) <= degree(a)  
            a.terms[a_index].degree >= k && break
            a_index += 1
        end
        while b_index <= degree(b) && k <= degree(b)
            b.terms[b_index].degree >= k && break
            b_index += 1
        end

        # get the coefficient of x^k in a and b
        a_k = (k > degree(a) || iszero(a) || a.terms[a_index].degree != k) ? 0 : a.terms[a_index].coeff
        b_k = (k > degree(b) || iszero(b) || b.terms[b_index].degree != k) ? 0 : b.terms[b_index].coeff
        c_k = int_crt([a_k, b_k], [n, m])  # integer chinese remainder theorem
        if c_k != 0
            c += TermBig(c_k, k)
        end
    end

    return c
end


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
function old_mult(p1::PolynomialBig, p2::PolynomialBig)::PolynomialBig  # old multiplication for timings
    p_out = PolynomialBig()
    for t in p1
        new_summand = (t * p2)
        p_out = p_out + new_summand
    end
    return p_out
end
function *(p1::PolynomialBig, p2::PolynomialBig)::PolynomialBig  # implementation of CRT polynomial product from class
    (iszero(p1) || iszero(p2)) && return PolynomialBig()

    height_p1 = maximum(map(term -> abs(term.coeff), p1.terms))
    height_p2 = maximum(map(term -> abs(term.coeff), p2.terms))

    # Calculates bound for the product of primes
    B = big(2) * height_p1 * height_p2 * min(length(p1.terms) + 1, length(p2.terms) + 1)
    p = 3
    M = big(p)  #product of primes
    c = (PolynomialModP(mod(p1, p), p) * PolynomialModP(mod(p2, p), p)).polynomial

    # Repeatedly calculates poly_crt until reaching the bound B from above
    while M < B
        p = nextprime(p + 1)
        c_prime = (PolynomialModP(mod(p1, p), p) * PolynomialModP(mod(p2, p), p)).polynomial
        c = poly_crt(c, c_prime, M, p)
        M *= p
    end

    return smod(c, M)
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
    n == 0 && return one(p)

    out = one(p)
    squares = p

    # find truncated binary representation of the exponent; starts from the first 1 in the string
    n_trunc_bin = reverse(bitstring(n)[findfirst('1', bitstring(n)):end])  # reverse for purposes of computation

    # iterate through in reverse order
    for b in n_trunc_bin
        # square the given term in iteration and if bit (b) is 1, multiply out by the current value of squares
        if parse(Int, b) == 1
            out *= squares
        end

        squares *= squares
    end

    return out
end
function ^(p::PolynomialModP, n::Int)::PolynomialModP
    n < 0 && error("No negative power")
    n == 0 && return PolynomialModP(one(Polynomial), p.prime)

    out = one(Polynomial)
    squares = p.polynomial

    # find truncated binary representation of the exponent; starts from the first 1 in the string
    n_trunc_bin = reverse(bitstring(n)[findfirst('1', bitstring(n)):end])  # reverse for purposes of computation

    # iterate through in reverse order
    for b in n_trunc_bin
        # square the given term in iteration and if bit (b) is 1, multiply out by the current value of squares
        if parse(Int, b) == 1
            out = mod(out * squares, p.prime)
        end

        squares = mod(squares * squares, p.prime)
    end

    return PolynomialModP(out, p.prime)
end

