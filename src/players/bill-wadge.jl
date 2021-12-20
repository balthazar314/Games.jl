using Games

struct BillWadge
end

function try_move(game, move, token) 
	Games.play_move!(game,move, token)
	result = Games.result(game)
	Games.undo_move!(game, move, token)
	return result
end

function Games.pick_move(::BillWadge, game::TicTacToe, token)
	# find wins
	for move in Games.legal_moves(game, token)
		result = try_move(game, move,token)

		if result == Games.Win(token)
			return move
		end
	end

	# block wins for the opponent
	opponent = only(findfirst(!=(token), Games.tokens(game)))
	for move in Games.legal_moves(game, opponent)
		result = try_move(game, move, opponent)
		if result == Games.Wind(opponent)
			return move
		end
	end

	if 5 in legal_moves(game, token)
		return 5
	end

	return rand(legal_moves(game,token))
end
