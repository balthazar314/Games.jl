module NimGame
	import Games
	using Base.Iterators
	export Nim, legal_moves,tokens

	struct Nim
    	heaps::Vector{Int}
    	last_player::Ref{Int}
    	Nim(heaps::Vector{Int}) = new(heaps, Ref(1))
	end	

	struct NimMove
		take::Int
		heapIndex::Int
	end

	take(n::Int; from::Int) = NimMove(n, from)

	Games.legal_moves(game::Nim, _) = Games.legal_moves(game)
	Games.legal_moves(game::Nim) = [take(m, from=heapIndex) for (heapIndex, heapSize) in enumerate(game.heaps) for m in 1:heapSize]

	Games.play_move!(game::Nim, move::NimMove, player) = (game.heaps[move.heapIndex] -= move.take; game.last_player[]=player)
	Games.undo_move!(game::Nim, move::NimMove, player) = (game.heaps[move.heapIndex] += move.take; game.last_player[]=player)

	Games.result(game::Nim) = all(game.heaps .== 0) ? Games.Win(game.last_player) : nothing
	Games.tokens(::Nim) = 1:2

	function Base.show(io::IO, game::Nim)
    	# get (roughly) how long heach number will be when printed
    	spacing = round.(Int, max.(1, log10.(game.heaps))) .+ 1
    	block = "\u2588"
    	join(io, game.heaps, ",")
    	println()
    	for i in 1:maximum(game.heaps)
        	for j in LinearIndices(game.heaps)
            	print(io, if game.heaps[j] >= i; block else " " end, " "^spacing[j])
        	end
        	println(io)
    	end
	end

	function Base.show(io::IO, move::NimMove)
		write(io, "Take $(move.take) items from heap $(move.heapIndex)\n")
	end
	
end
