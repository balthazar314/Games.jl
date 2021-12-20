module DrawUtils
    export draw_board, clear_screen 

    vertical_line = "\u2502"
    horizontal_line = "\u2500"
    corner = "\u253c"
    row_deliminer = "\n$(horizontal_line)$(corner)$(horizontal_line)$(corner)$(horizontal_line)\n"

    function draw_board(board::Matrix)
        @assert size(board) == (3,3)
        vertical_line = "\u2502"
        horizontal_line = "\u2500"
        corner = "\u253c"
        row_deliminer = "\n$(horizontal_line)$(corner)$(horizontal_line)$(corner)$(horizontal_line)\n"
        
        map(1:3) do i
            join(board[:, i], vertical_line)
        end |> reverse |> a->join(a, row_deliminer)  |> println
    end

    function clear_screen()
        print("\e[2J\e[H")
    end

end
