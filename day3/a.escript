#!/usr/bin/env escript

split_compartments(Items) -> lists:split(trunc(length(Items) / 2), Items).

find_incorrect_items(Left, Right) ->
  LeftSet = sets:from_list(Left),
  RightSet = sets:from_list(Right),
  ItemSet = sets:intersection([LeftSet, RightSet]),
  sets:to_list(ItemSet).

prioritize_item(Item) ->
  if
    Item - 97 >= 0 -> Item - 96;
    true -> Item - 65 + 27
  end.

prioritize_items(Bags) -> prioritize_items(Bags, []).

prioritize_items([], AllPriorities) -> AllPriorities;

prioritize_items(Bags, AllPriorities) ->
  [Bag | Rest] = Bags,
  {Left, Right} = split_compartments(Bag),
  IncorrectItems = find_incorrect_items(Left, Right),
  Priorities = [prioritize_item(Item) || Item <- IncorrectItems],

  prioritize_items(Rest, AllPriorities ++ Priorities).

priority_score(Bags) -> lists:sum(prioritize_items(Bags)).

main([]) ->
  {ok, File} = file:read_file("a.txt"),
  Input = [binary:bin_to_list(Line) || Line <- string:split(File, <<"\n">>, all)],
  PriorityScore = priority_score(Input),
  io:format("Priority score: ~p~n", [PriorityScore]).