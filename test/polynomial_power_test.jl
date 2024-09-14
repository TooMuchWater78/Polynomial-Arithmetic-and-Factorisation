#############################################################################
#############################################################################
#
# This file contains units tests for polynomial derivative operations
#                                                                               
#############################################################################
#############################################################################

function polynomial_power_tests()
    polyBig_pow_test()
    polyModP_pow_test()
    polyBig_pow_mod_test()
    polyModP_pow_mod_test()
end

"""
Test whether ^ raises the power of a PolynomialBig correctly.
"""
function polyBig_pow_test(; seed::Int = 0, N::Int = 10, n::Int = 10)
    Random.seed!(seed)
    for _ in 1:N
        p = rand(PolynomialBig)
        p_out = deepcopy(p)
        for _ in 1:n-1
            p_out *= p
        end
        @assert p^n == p_out
    end
    println("polyBig_pow_test - PASSED")
end

"""
Test whether ^ raises the power of a PolynomialModP correctly.
"""
function polyModP_pow_test(; seed::Int = 0, N::Int = 10, n::Int = 10)
    Random.seed!(seed)
    for _ in 1:N
        p = rand(PolynomialModP)
        p_out = deepcopy(p)
        for _ in 1:n-1
            p_out *= p
        end
        @assert p^n == p_out
    end
    println("polyModP_pow_test - PASSED")
end

"""
Test whether pow_mod raises the power of a PolynomialBig correctly.
"""
function polyBig_pow_mod_test(; seed::Int = 0, N::Int = 10, n::Int = 10, prime::Int = 17)
    Random.seed!(seed)
    for _ in 1:N
        p = rand(PolynomialBig)
        p_out = deepcopy(p)
        for _ in 1:n-1
            p_out = mod(p_out * p, prime)
        end
        @assert pow_mod(p, n, prime) == p_out
    end
    println("polyBig_pow_mod_test - PASSED")
end

"""
Test whether pow_mod raises the power of a PolynomialModP correctly.
"""
function polyModP_pow_mod_test(; seed::Int = 0, N::Int = 10, n::Int = 10, prime::Int = 17)
    Random.seed!(seed)
    for _ in 1:N
        # p = prime refers to rand input parameter, not the generated p polynomial; see PolynomialModP rand function
        p = rand(PolynomialModP, p = prime)
        p_out = deepcopy(p)
        for _ in 1:n-1
            p_out *= p
        end
        @assert pow_mod(p, n) == p_out
    end
    println("polyModP_pow_mod_test - PASSED")
end