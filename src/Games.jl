module Games
	using Base.Iterators: cycle

	function play(game, players...)
		# each player plays until the game is over
		teams = assign_teams(game, players...)
		for team in cycle(teams)
			take_turn!(game, team)
			if is_over(game) 
				return result(game)
			end
		end
	end

	function take_turn!(game, team)
		player = leader(team)
		token = flag(team)
		move = pick_move(player, game, token)
		if move in legal_moves(game, token)
			play_move!(game, move, token)
		else
			error("player $player tried to play an illegal move $move")
		end
	end

	# usefull types
	struct Win{Team}
		winner::Team
	end
	
	struct Draw
	end		

	Base.show(io::IO, w::Win) = show(io, "team $(w.winner) won!")
	Base.show(io::IO, ::Draw) = show(io, "game ended in a draw")

	#  Default implementations
	is_over(game) = result(game) !== nothing

	# the default "team" is just a player/token pair
	# this is useful so that each player knows which side they're on
	assign_teams(game, players...) = zip(players, tokens(game))
	leader(team) = first(team)
	flag(team) = last(team)

	tokens(game) = error("game $(typeof(game)) needs to implement tokens")
	pick_move(player, game, token) = error("player $player needs to implement pick_move for $game")
	play_move!(game, move, token) = error("game $game needs to implement play_move")
	legal_moves(game, move, token) = error("game $game needs to implement legal_moves")
	result(game) = error("game $game must implement result")

	undo_move!(game, move, token) = error("tried to undo move $move on an irreversable game $game")
end # Module Games
