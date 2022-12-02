#!/usr/bin/env escript

top_three_most_calories(Input) ->
  AllTotals = sum_calories(Input),
  SortedTotals = lists:reverse(lists:sort(AllTotals)),
  lists:sum(lists:sublist(SortedTotals, 3)).

sum_calories(Input) -> sum_calories(Input, [], []).

sum_calories([], Entries, Totals) ->
  LastTotal = lists:sum(Entries),
  Totals ++ [LastTotal];

sum_calories(Input, Entries, Totals) ->
  [Head | Tail] = Input,

  case string:length(Head) of
    0 -> sum_calories(Tail, [], Totals ++ [lists:sum(Entries)]);
    _ -> sum_calories(Tail, Entries ++ [as_integer(Head)], Totals)
  end.

as_integer(Value) ->
  {Integer, _} = string:to_integer(Value),
  Integer.

main([]) ->
  {ok, File} = file:read_file("a.txt"),
  Input = string:split(File, <<"\n">>, all),
  Result = top_three_most_calories(Input),
  io:format("Top three most calories: ~p~n", [Result]).
