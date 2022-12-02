#!/usr/bin/env escript

max_calories(Input) ->
  AllTotals = sum_calories(Input),
  lists:max(AllTotals).

sum_calories(Input) -> sum_calories(Input, [], []).

sum_calories([], Entries, Totals) ->
  LastTotal = lists:sum(Entries),
  Totals ++ [LastTotal];

sum_calories(Input, Entries, Totals) ->
  [Head | Tail] = Input,

  case string:length(Head) of
    0 -> sum_calories(Tail, [], Totals ++ [lists:sum(Entries)]);
    _ -> sum_calories(Tail, Entries ++ [as_integer(Head)], Totals)
  end;

as_integer(Value) ->
  {Integer, _} = string:to_integer(Value),
  Integer.

main([]) ->
  {ok, File} = file:read_file("a.txt"),
  Input = string:split(File, <<"\n">>, all),
  MaxCalories = max_calories(Input),
  io:format("Max calories: ~p~n", [MaxCalories]).
