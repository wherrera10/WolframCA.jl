# WolframCA

A Wolfram cellular automaton package

[![Documentation Status](https://img.shields.io/badge/docs-latest-blue.svg)](https://wherrera10.github.io/WolframCA.jl/)

> A cellular automaton is a collection of "colored" cells on a grid of specified shape that evolves through a number of discrete time steps according to a set of rules based on the states of neighboring cells. 
> The rules are then applied iteratively for as many time steps as desired.

[mathworld.wolfram.com/CellularAutomaton](http://mathworld.wolfram.com/CellularAutomaton.html)

This package implements elementary and totalistic 1-dim cellular automata using Wolfram's rule-numbering scheme, as well as Game-of-Life-style 2-dim cellular automata.

> **Note:** This project was originally [CellularAutomata.jl](https://github.com/natj/CellularAutomata.jl) by Joonas Nättilä, which has been unmaintained since 2017. It is continued here as WolframCA.jl (renamed to avoid a naming conflict with an unrelated, actively maintained [`CellularAutomata.jl`](https://github.com/MartinuzziFrancesco/CellularAutomata.jl) package already registered in the Julia General registry). See [LICENSE](LICENSE) for attribution.
The package has code for two cellular automaton objects: CellularAutomaton1D and CellularAutomaton2D. Originally, CellularAutomaton1D was named CellularAutomaton and CellularAutomaton2D was named CA2d. The older names are implemented as const set equal to their successor structs, and still work as aliases, as below. In general,
all prior code using the original package should work the same under the new naming scheme, because of aliasing.

### Elementary CA


To generate an elementary cellular automaton, use
```julia
ca = CellularAutomaton(rule, init, gen) # or CellularAutomaton1D(rule, init, gen)
```
where `rule` is the Wolfram code (integer), `init` is a vector containing the initial starting condition and `gen` is the number of generations to be computed.
For a single starting cell in the middle just omit the `init` vector.

To generate 15 generations of elementary cellular automaton of rule 90 use
```julia
using WolframCA

ca90 = CellularAutomaton(90, 16)
```
                                #                                    
                               # #                                   
                              #   #                                  
                             # # # #                                 
                            #       #                                
                           # #     # #                               
                          #   #   #   #                              
                         # # # # # # # #                             
                        #               #                            
                       # #             # #                           
                      #   #           #   #                          
                     # # # #         # # # #                         
                    #       #       #       #                        
                   # #     # #     # #     # #                       
                  #   #   #   #   #   #   #   #                      
                 # # # # # # # # # # # # # # # #                     


### Totalistic CA


For a more complex cellular automaton you can change the number of states `k` the cell can be and the radius `r` of neighbors that can influence the states.
If `k` is changed to be larger than 2, a totalistic CA is computed where only the average value of all neighbors count.
This can be done like this
```julia
ca = CellularAutomaton(993, 15, k=3)
```
	                        X                         
	                       XXX                        
	                      X# #X                       
	                     X     X                      
	                    XXX   XXX                     
	                   X# #X X# #X                    
	                  X     #     X                   
	                 XXX   ###   XXX                  
	                X# #X # X # X# #X                 
	               X      # X #      X                
	              XXX    ## X ##    XXX               
	             X# #X  #   X   #  X# #X              
	            X     X### XXX ###X     X             
	           XXX   X XX  # #  XX X   XXX            
	          X# #X XX###X## ##X###XX X# #X           


### 2 dimensional CAs

Note that when plotted with generation number as one axis, a CellularAutomaton1D actually produces a 2-dimensional graph or heatmap.
Likewise, a true 2-dimensional automaton will thus produce a 3-dimensional plot is generation number is an axis. More commonly, the 
CellularAutomaton2D evolution over time is expressed as an animation, as, for example, Conway's Game of Life is often shown as video.

Two dimensional cellular automata (as in Conway's Game of Life) can be created by

```julia
ca = CA2d(B, S, init, gen)
```

where `B` and `S` are vectors that have the numbers of neighboring cells that define when cell is born or survives, `init` (matrix) is the initial starting condition and `gen` is the number of generations the CA is to be computed.

Game of life is then run for 9 generations for e.g. a turbine pattern by typing

```julia
ca = CA2d([3], [2, 3], init, 9)
```

1st step

	   ###### ##        
	   ###### ##        
	          ##        
	   ##     ##        
	   ##     ##        
	   ##     ##        
	   ##               
	   ## ######        
	   ## ######        
	                    

2nd	       
             
	    ####            
	   #    # ##        
	   #    #   #       
	      ##    #       
	   ##    #  #       
	  #  #   #  #       
	  #  #    ##        
	  #    ##           
	  #   #    #        
	   ## #    #        
	       ####         
	               
     
3rd	     
               
	     ##             
	    ####            
	   # ## ## #        
	        ##  #       
	   ##  ##  ###      
	   #### #  ###      
	  #  #   #  #       
	 ###  # ####        
	 ###  ##  ##        
	  #  ##             
	   # ## ## #        
	       ####         
	        ##          
	             
       
4th

	    #  #            
	        #           
	         ##         
	   # ##      #      
	   #  #   #         
	  #   # ###         
	 #           #      
	    ### #   #       
	    #   #  #        
	 #      ## #        
	    ##              
	      #             
	       #  #         

	                    
5th

	        ##          
	         #          
	    ###  ##         
	  ### #   #         
	  #    # ##         
	      # #           
	    ## #    #       
	    #   # ###       
	    ##  ###         
	     #              
	     ##             


6th

	        ##          
	     #              
	    # #  ##         
	  # # ###  #        
	  #  ######         
	     ## ##          
	    ######  #       
	   #  ### # #       
	    ##  # #         
	         #          
	     ##             

	                    
7th	 
                   
	     #  # #         
	   ## # ###         
	    #      #        
	   ##     #         
	                    
	    #     ##        
	   #      #         
	    ### # ##        
	    # #  #          
	     
               
8th	                    

	    ## ## #         
	   ##  ## ##        
	           #        
	   ##               
	   ##     ##        
	          ##        
	   #                
	   ## ##  ##        
	    # ## ##         

	                    
9th	                    

	   ###### ##        
	   ###### ##        
	          ##        
	   ##     ##        
	   ##     ##        
	   ##     ##        
	   ##               
	   ## ######        
	   ## ######        
	            	                    
	                    
	                    
### Image Display:

Any `CellularAutomaton` or `CA2d` can also be rendered as a PNG image (via Cairo), in addition to the text representation shown above.
In a rich front-end that supports image display (e.g. Jupyter, Pluto, or VS Code's Julia extension), simply calling `display(ca)` shows the automaton's generations as an image.
To save the image to a file instead, use

```julia
open("ca.png", "w") do io
    show(io, MIME("image/png"), ca)
end
```

See [examples/display.jl](examples/display.jl) for a more complete example.


### Installation:

To install from a Julia REPL command line session you may use `]add WolframCA` at the command line, or with Pkg:

    using Pkg
    Pkg.add("EDFPlus"))

Toa add the current main branch code"

    Pkg.add("https//github.com/wherrera10/WolframCA.jl")


### Running Tests:


To run tests, execute the following command from the root folder of the repository:

```julia
julia tests/run_tests.jl
```

