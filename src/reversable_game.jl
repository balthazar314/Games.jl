using Games

struct ReversableGame{Game<:AbstractGame} <: AbstractGame
   initial_state::Game
   current_state::Game
   moves_played::Vector{eltype(legal_moves(initial_state))}
end

function move!(game::ReversableGame{Game}, move)
   push!(moves_played, move)   
   reutrn move!(current_state)
end

legal_moves(game::ReversableGame) = legal_moves(current_state)

   

