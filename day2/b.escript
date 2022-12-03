#!/usr/bin/env escript

move_value(Value) ->
  Moves = #{"A" => 1, "X" => 1, "B" => 2, "Y" => 2, "C" => 3, "Z" => 3},
  map_entry(binary:bin_to_list(Value), Moves).

score_game(Rounds) -> score_game(Rounds, 0, 0).

score_game([], LeftScore, RightScore) -> [LeftScore, RightScore];

score_game(Rounds, LeftScore, RightScore) ->
  [Round | Rest] = Rounds,
  [LeftMove, RightInstruction] = [move_value(X) || X <- string:split(Round, " ", all)],
  Moves = [LeftMove, find_move(RightInstruction, LeftMove)],
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

find_move(Instruction, Left) ->
  case Instruction of
    1 -> lose_move(Left);
    2 -> Left;
    3 -> beat_move(Left)
  end.

beat_move(Move) ->
  Moves = #{3 => 1, 2 => 3, 1 => 2}, 
  map_entry(Move, Moves).

lose_move(Move) ->
  Moves = #{2 => 1, 1 => 3, 3 => 2},
  map_entry(Move, Moves).

map_entry(Value, Map) ->
  {_, Result} = maps:find(Value, Map),
  Result.

main([]) ->
  {ok, File} = file:read_file("a.txt"),
  Input = string:split(File, <<"\n">>, all),
  GameScore = score_game(Input),
  io:format("Game score [p1,p2]: ~p~n", [GameScore]).