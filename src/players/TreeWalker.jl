#using Games

@warn "only works for reversible games"
@warn "also doesn't play optimally for nim out of the box"

struct TreeWalker
end

Games.pick_move(::TreeWalker, game, token) = first(width_first_search(game, token))

function width_first_search(game, me)

    # a collection of all legal moves
    moves = Games.legal_moves(game, me)
    draw = nothing
    loss = nothing
    loss_result = nothing
    for_later = []
    sizehint!(for_later, length(moves))

    # look for any easy wins
    for move in moves
        Games.play_move!(game, move, me)
        local result = Games.result(game)
		Games.undo_move!(game, move, me)
		# undo a move
        # if any options are wins, break out early
        if result == Games.Win(me)
        	@debug "found a win"
            return (move, result)
        # save a draw as a backup plan
        elseif result == Games.Draw()
            draw=move
        # don't calculate these unless you have to
        elseif result === nothing
            push!(for_later, move)
        # save a loss so we can loose with honor
        elseif result.winner != me
            loss=move
            loss_result = result
        else
            error("unrecognised result $result")
        end

    end

    # since there aren't any short term wins at this point, it is time to start looking a few steps ahead
    # this basically means evaluating all the Inconclusive elements by looking at what our opponent would do
    # meanwhile also looking for any wins (see if you can spot a pattern)
    for move in for_later
        Games.play_move!(game, move, me)

		next_player = only(filter(!=(me), Games.tokens(game)))
        local (_, result) = width_first_search(game, next_player) # here `last` means the econd element of the tuple
                                                            # i.e. the result, not the opponents move
		Games.undo_move!(game, move, me)
		
        # if any options are wins break out early
         if  result == Games.Win(me)
         	@debug "found a win"
            return (move, result)
        # save a draw as a backup plan
        elseif result == Games.Draw()
            draw=move
        # save a loss so we can loose with honor
        elseif result.winner != me
            loss=move
            loss_result = result
        # at this stage the algorithm should never return an inconclusive result
        # so if that happens something has gone wrong
        elseif result == nothing
            error("unexpected inconclusive result")
        else
            error("unrecognised result $result")
        end
    end

    # at this point there is no hope of winning, so if we have a draw, we return that instead
    if draw != nothing
    	@debug "settled on a draw"
        return draw, Games.Draw()
    # the only option now is to admit defete and accept our fate
    elseif loss != nothing
        return loss, loss_result
    else
        error("no win's losses, or draws recorded")
    end

end
