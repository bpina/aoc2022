#!/usr/bin/env escript

move_value(Value) ->
  Moves = #{"A" => 1, "X" => 1, "B" => 2, "Y" => 2, "C" => 3, "Z" => 3},
  {_, Move} = maps:find(binary:bin_to_list(Value), Moves),
  Move.

score_game(Rounds) -> score_game(Rounds, 0, 0).

score_game([], LeftScore, RightScore) -> [LeftScore, RightScore];

score_game(Rounds, LeftScore, RightScore) ->
  [Round | Rest] = Rounds,
  Moves = [move_value(X) || X <- string:split(Round, " ", all)],
  [LeftPoints, RightPoints] = score_round(Moves),

  score_game(Rest, LeftScore + LeftPoints, RightScore + RightPoints).

score_round([L, R]) when L =:= R -> [L + 3, R + 3];

score_round(Moves) ->
  [Left, Right] = Moves,
  LeftWins = #{[1,3] => 0, [2,1] => 0, [3, 2] => 0},

  case maps:find(Moves, LeftWins) of
    {ok, _} -> [6 + Left, Right];
    _ -> [Left, 6 + Right]
  end.

main([]) ->
  {ok, File} = file:read_file("a.txt"),
  Input = string:split(File, <<"\n">>, all),
  GameScore = score_game(Input),
  io:format("Game score [p1,p2]: ~p~n", [GameScore]).