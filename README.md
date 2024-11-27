# Polynomial Airthmetic and Factorization

Student Number: 47483073

This project implements polynomial arithmetic and polynomial factorization for polynomials with integer coefficients. 

[Assignment Instructions](https://courses.smp.uq.edu.au/MATH2504/2024/assessment_html/project1.html).

To load all functionality, in the directory of the repo:

```
] activate .
```

```
] instantiate
```

```
julia> include("poly_factorization_project.jl")
```

You may then use functionality such as,

```
julia> gcd(rand(Polynomial) + rand(Polynomial), rand(Polynomial), 101)
```

To execute all unit tests run:

```
julia> include("test/runtests.jl")
```

You may see examples of functionality in `example_script_2.jl`.
