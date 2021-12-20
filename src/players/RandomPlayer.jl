using Games

struct Noob
end

Games.pick_move(::Noob,game,token) = rand(Games.legal_moves(game, token))
