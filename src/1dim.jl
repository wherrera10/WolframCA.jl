#1-dim CAs

""" Elementary & totalistic CA with r-nearest neighbor and k states """
struct CellularAutomaton

    # user given values
    N::Int # Wolfram code
    ruleset::Array{Int8,1} # set of rules
    k::Int # number of states
    r::Int # radius for r-nearest neighbor

    # internal state variables
    cells::Array{Int8,2}

    """ 
        CellularAutomaton(N::Int, init::Array{Int,1}, gen::Int; k::Int=2, r::Int=1)

    Constructor for CellularAutomaton.

    `N` is the Wolfram code.
    `init` is the initial state.
    `gen` is the number of generations.
    `k` is the number of states.
    `r` is the neighborhood radius.
    """
    function CellularAutomaton(N::Int, init::Array{Int,1}, gen::Int; k::Int=2, r::Int=1)
        ruleset = rule(N, k, r)

        w = length(init)
        cells = zeros(Int8, gen, w)
        cells[1,:] = Array{Int8}(init[:])'

        if k == 2
            #Elementary CA
            mp = reverse(Int8[k^i for i = 0:2r])
        else
            #Totalistic CA
            mp = Array{Int8}(ones(2r+1))
        end

        for i = 2:gen
            for j = 1:w
                ind = 0 ; s = 1
                for q = (j-r):(j+r)
                    idx = q

                    #Cyclic boundary conditions
                    if idx < 1
                        idx = w-idx
                    end
                    if idx > w
                        idx = idx-w
                    end

                    ind += mp[s]*cells[i-1, idx]
                    s += 1
                end
                cells[i,j] = ruleset[ind+1]
            end
        end

        new(N, ruleset, k, r, cells)
    end

    """ 
        CellularAutomaton(N::Int, gen::Int; kvs...)

    Quick setup for one seed cell in the center as init.

    `N` is the Wolfram code.
    `gen` is the number of generations.
    """
    function CellularAutomaton(N::Int, gen::Int; kvs...)
        init = Array{Int}(zeros(2*gen))
        init[gen] = 1

        CellularAutomaton(N, init, gen; kvs...)
    end
end

""" Parse rule numbering according to the Wolfram code """
function rule(n::Int, k=2, r=1)
    if k < 2
        error("number of states (k) must be larger than 1; you gave $k")
    elseif k == 2
        #Elementary CA
        return digits(n, base=k, pad=k^(2r+1))
    else
        #Totalistic CA
        return digits(n, base=k, pad=(2r+1)k-2)
    end
end
