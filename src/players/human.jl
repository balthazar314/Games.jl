
# the 'AI's here are actually just functions that take what token they are and the current game board
# they return a number from 1 to 9 that represents the square on the game board that they want to fill in with their token
# the squares are numbered like so
#=
	7|8|9
	-----
	4|5|6
	-----
	1|2|3

	I did it like this because this maps nicely to the numpad on my keyboard
=#
struct Human
end
# all the HumanPlayer function does is ask you which cell you want to fill in
function Games.pick_move(::Human, game, token)
	clear_screen()
	println(game)
	while true
		println("$token's turn! Select a square using the number keys.\n legal moves are $(Games.legal_moves(game, token))")

		input = tryparse(Int, readline())
		if input === nothing
			println("invalid input, must be an int")
			continue
		elseif input in LinearIndices(Games.legal_moves(game, token))
			return Games.legal_moves(game, token)[input]
		else
			clear_screen()
			println("that is not a legal move")
			println(game)
		end
	end
end

function clear_screen()
	print("\e[2J\e[H")
end

