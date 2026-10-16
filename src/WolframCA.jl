module WolframCA

import Base.show
using Cairo: CairoRGBSurface, write_to_png

include("1dim.jl")
include("2dim.jl")

# Forward declarations for static analysis / editor tooling when the concrete
# types are provided by the included files.
if !isdefined(@__MODULE__, :CellularAutomaton)
    abstract type CellularAutomaton end
end
if !isdefined(@__MODULE__, :CA2d)
    abstract type CA2d <: CellularAutomaton end
end

export CellularAutomaton1D,
       CellularAutomaton2D,
       CellularAutomaton,
       CA2d,
       rule,
       show

"""
    Base.show(io::IO, ca::CA2d)

Print CA to screen from CA as CellularAutomaton
"""
function Base.show(io::IO, ca::CellularAutomaton)
    io2 = IOBuffer()

    arr = ca.cells
    h, w = size(arr)

    print(io2, "$(w)x$(h) Cellular Automaton")
    print(io2, "\n")

    # print rule as in the Wolfram notation
    println(io2, "Rule: $(ca.rule)")

    for i = 1:h
        print(io2,"\t")
        for j = 1:w
            if arr[i,j] == 0
                print(io2," ")
            elseif ca.k == 2 && arr[i,j] == 1
                print(io2,"#")
            elseif ca.k == 3 && arr[i,j] == 1
                print(io2,"X")
            elseif arr[i,j] == 2
                print(io2, "#")
            end
        end
        print(io2,"\n")
    end

    print(io, String(take!(io2)))
end

"""
    Base.show(io::IO, ca::CA2d)

Print CA to screen as CA2d
"""
function Base.show(io::IO, ca::CA2d)
    io2 = IOBuffer()

    arr = ca.cells
    h, w, gen = size(arr)

    print(io2, "$(w)x$(h)x$(gen) Cellular Automaton")
    print(io2, "\n")

    # print rule as in the Wolfram notation
    println(io2, "Rule: $(ca.rule)")

    for g in 1:gen
        for i = 1:h
            print(io2,"\t")
            for j = 1:w
                if arr[i,j, g] == 0
                    print(io2," ")
                elseif arr[i,j, g] == 1
                    print(io2, "#")
                end
            end
            print(io2,"\n")
        end
        print(io2,"\n\n")
    end

    print(io, String(take!(io2)))
end

# Number of output image pixels used per automaton cell, so that grids with
# few cells still render as a visible image rather than a few stray pixels.
const CELL_PIXELS = 8

""" 
    cell_rgb(ca::CellularAutomaton, state::Integer)

Packed 0x00RRGGBB color for a single cell's state: white when dead, black
when alive, and gray for the second "alive" state of a k=3 totalistic CA. 
"""
cell_rgb(ca::CellularAutomaton, state::Integer) =
    state == 0 ? 0x00ffffff : (ca.k == 3 && state == 2 ? 0x00999999 : 0x00000000)
cell_rgb(::CA2d, state::Integer) = state == 0 ? 0x00ffffff : 0x00000000

"""
    grid_to_image(ca, grid::AbstractMatrix)

Build a pixel buffer for a 2-dim grid of cell states, scaling each cell up
to a CELL_PIXELS x CELL_PIXELS block so the image is visible.
"""
function grid_to_image(ca, grid::AbstractMatrix)
    h, w = size(grid)
    img = Matrix{UInt32}(undef, h * CELL_PIXELS, w * CELL_PIXELS)
    for i = 1:h, j = 1:w
        color = cell_rgb(ca, grid[i, j])
        img[(i-1)*CELL_PIXELS+1:i*CELL_PIXELS, (j-1)*CELL_PIXELS+1:j*CELL_PIXELS] .= color
    end
    img
end

"""
        Base.show(io::IO, ::MIME"image/png", ca::CellularAutomaton)

Render CA to a PNG image (e.g. for Jupyter/Pluto/VS Code's plot pane), with
each generation on its own row, as in the text representation above.
"""
function Base.show(io::IO, ::MIME"image/png", ca::CellularAutomaton)
    img = grid_to_image(ca, ca.cells)
    write_to_png(CairoRGBSurface(img), io)
end

"""
    Render CA2d to a PNG image, stacking each generation's grid vertically,
    separated by a blank gap, as in the text representation above.
"""
function Base.show(io::IO, ::MIME"image/png", ca::CA2d)
    h, w, gen = size(ca.cells)
    frame_h = h * CELL_PIXELS
    gap = CELL_PIXELS
    img = fill(0x00ffffff, gen * frame_h + (gen - 1) * gap, w * CELL_PIXELS)

    y0 = 0
    for g = 1:gen
        img[y0+1:y0+frame_h, :] .= grid_to_image(ca, @view ca.cells[:, :, g])
        y0 += frame_h + gap
    end

    write_to_png(CairoRGBSurface(img), io)
end


end # module WolframCA
