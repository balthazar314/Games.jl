module tictactoe
	using Games
	export TicTacToe, result, legal_moves, show, play_move, tokens, pick_move

	#  game definition
	@enum XorO X O

    const SquareValue = Union{Nothing, XorO}

    struct TicTacToe
        board::Matrix{SquareValue}
        TicTacToe(board::Matrix{SquareValue}) = new(board)
    end

    TicTacToe(w=3) = TicTacToe( Matrix{SquareValue}(fill(nothing, (w,w))))

    Games.tokens(::TicTacToe) = (X,O)

	Games.legal_moves(game::TicTacToe, token) = legal_moves(game)
    legal_moves(game::TicTacToe) = findall(==(nothing), game.board[:])

    Games.play_move!(game::TicTacToe, move, token::XorO) = (game.board[move]=token; game)
    Games.undo_move!(game::TicTacToe, move, token::XorO) = (game.board[move]=nothing; game)

    function Games.result(game::TicTacToe)
        won(game.board, X) && return Games.Win(X)
        won(game.board, O) && return Games.Win(O)
        is_draw(game.board) && return Games.Draw()
        return nothing
    end

    # function to check who won
    won(board, c::XorO) = all(board[[1,5,9]].==Ref(c)) || # check the diagonal
                                all(board[[7,5,3]].==Ref(c) ) || # check the opposite diagonal
                                any(1:3) do i;          # check the i'th row and collumn
                                    all(board[i,:] .== Ref(c)) || all(board[:,i].==Ref(c)) 
                                end

    # function to check if there was a draw
    is_draw(board) = all(!=(nothing), board)

	# TODO move somewhere else
    function Base.show(io::IO, game::TicTacToe)
        vertical_line = "\u2502"
        horizontal_line = "\u2500"
        corner = "\u253c"
        
        rows = axes(game.board,1)
        num_cols = size(game.board, 2)

        row_deliminer = '\n'*join(repeat(horizontal_line, num_cols), corner)*'\n'
        tokens = [ square === nothing ? i : square for (i, square) in enumerate(game.board)]
        
        join(io, reverse([join(tokens[:, row], vertical_line) for row in rows]), row_deliminer) 
    end
end
