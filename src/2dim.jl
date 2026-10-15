#2-dim CAs

# struct for tTo dimensional cellular automaton
struct CellularAutomaton2D
    # User given values
    k::Int #Number of states
    r::Int #r-nearest neigbors

    # Internal state values
    cells::Array{Int8, 3}
end

# backward compatibility
const CA2d = CellularAutomaton2D

"""
    CellularAutomaton2D(B::Array{Int,1},
        S::Array{Int,1},
        init::Array{Int,2},
        gen::Int,
        k::Int=2,
        r::Int=1)

Constructor for 2D cellular automaton.
    B and S are the birth and survival rules.
    init is the initial grid of cells.
    gen is the number of generations to simulate.
    k is the number of states.
    r is the neighborhood radius.    
"""
function CellularAutomaton2D(B::Array{Int,1},
              S::Array{Int,1},
              init::Array{Int,2},
              gen::Int,
              k::Int=2,
              r::Int=1)

    h, w = size(init)
    cells = zeros(Int8, h, w, gen)
    cells[:, :, 1] .= init[:, :]

    for g = 2:gen
        for i = 1:h, j = 1:w
            cc = -cells[i, j, g-1]
            for p = (i-r):(i+r), q = (j-r):(j+r)
                #Cyclic boundary conditions
                pi = mod1(p, h)
                qj = mod1(q, w)
                cc += cells[pi, qj, g-1]
            end
            cells[i, j, g] = eval_rule(cc, cells[i, j, g-1], B, S)
        end #hw ij
    end #gen

    CA2d(k, r, cells)
end

""" Evaluate life rules for the CA2d / CellularAutomaton2D automaton. Returns an Int not a Bool """
function eval_rule(cc, olds, B, S)::Int
    return cc in B || (olds == 1 && cc in S) ? 1 : 0
end
