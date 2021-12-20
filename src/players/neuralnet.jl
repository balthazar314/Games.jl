#
using Flux

using tictactoe: TicTacToe, XorO, X, O, EmptySquare
using Games: legal_moves

struct NeuralNetPlayer{Model}
    model::Model
end


function (nn::NeuralNetPlayer)(game::TicTacToe, token::XorO)
    representation = Dict(X=>2*(token==X)-1, O=>2*(token==O)-1, EmptySquare()=>0)
    game_board = getindex.(Ref(representation),game.board[:])
   
    move = nn.model(game_board).data |>               # step 1. run the moves through the model
         enumerate |> collect |>                      # turn them bak into actual moves
         x-> sort(x, by=last, rev=true) .|> first |>  # sort the best ones
         x->filter(in(legal_moves(game, token)), x) |>   # step 3. filter out the illegal ones
         first                                          # note that the sort function sorts descending by default
    return move
end

function LossFunction(nn::NeuralNetPlayer, other_player)
    player_list = Dict([X=>nn, O=>other_player])
    scoring_system = Dict(Winner(X)=> 2, Winner(O) => -1, Draw() => 1)
    N = 100
    return function ()
        score=0
        for _ in 1:N
             game = TicTacToe()
             # play the game
             result = Games.result(game)
              # get the first player
              player_token = next_player(game)
              while result == Inconclusive()

                  player_AI = player_list[player_token]

                  move = player_AI(game, player_token)
                  if is_legal_move(game, move)
	                  move!(game, player_token, move)
	                  result = Games.result(game)
	                  player_token = next_player(game, player_token)
                  else
	                  error("player $player_token attempted to play an illegal move: $move,
	                  legal moves are $(Games.legal_moves(game))")
                  end
              end

            # calculate score
            score += scoring_system[result]
            
        end
        return score/N
    end
end


model_from_gnome(genome) = Chain((Dense(a,b) for (a,b) in zip(genome[1:end-1], genome[2:end]))...)

p1 = NeuralNetPlayer(model_from_gnome([9,24,18,9]))
test = LossFunction(p1, randomplayer)


