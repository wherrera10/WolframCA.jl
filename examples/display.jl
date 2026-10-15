# Demo: visualizes a 2-dim Cellular Automaton (e.g. Conway's Game of Life)
# as a PNG image, using the package's built-in `show(io, MIME("image/png"), ca)`
# method (Cairo-based, no GUI toolkit required).
#
# In a rich front-end (Jupyter, Pluto, VS Code's Julia plot pane) simply
# calling `display(ca)` renders the automaton's generations inline. This
# script instead writes the result to a PNG file so it can be viewed anywhere.
using WolframCA

""" make a png of the game of life graphic """
function life_png(path::AbstractString, init::Array{Int,2}, B, S, gen::Int)
    ca = CA2d(B, S, init, gen)
    open(path, "w") do io
        show(io, MIME("image/png"), ca)
    end
    ca
end

# turbine pattern
init = zeros(Int, 20, 20)
init[4, 4:9] .= 1
init[5, 4:9] .= 1

init[4:9, 11] .= 1
init[4:9, 12] .= 1

init[11, 7:12] .= 1
init[12, 7:12] .= 1

init[7:12, 4] .= 1
init[7:12, 5] .= 1

# random blob
#init = zeros(Int, 40, 40)
#init[15:25, 15:25] = rand(0:1, 11, 11)

# game of life
life_png("game_of_life.png", init, [3], [2,3], 9)

#morley
#life_png("morley.png", init, [3,6,8], [2,4,5], 9)

#2x2
#life_png("2x2.png", init, [3,6], [1,2,5], 9)

#replicator
#life_png("replicator.png", init, [1,3,5,7], [1,3,5,7], 9)

#dimoeba
#life_png("dimoeba.png", init, [3,5,6,7,8], [5,6,7,8], 9)

#no death
#life_png("no_death.png", init, [3], [0,1,2,3,4,5,6,7,8], 9)

#34 life
#life_png("34_life.png", init, [3,4], [3,4], 9)
