#!/usr/bin/env escript

find_group_items(Group) ->
  BagSet = [sets:from_list(Bag) || Bag <- Group],
  GroupSet = sets:intersection(BagSet),
  sets:to_list(GroupSet).

prioritize_item(Item) ->
  if
    Item - 97 >= 0 -> Item - 96;
    true -> Item - 65 + 27
  end.

prioritize_groups(Bags) -> prioritize_groups(Bags, []).

prioritize_groups([], AllPriorities) -> AllPriorities;

prioritize_groups(Bags, AllPriorities) ->
  {Group, Rest} = lists:split(3, Bags),
  GroupItems = find_group_items(Group),
  GroupPriorities = [prioritize_item(Item) || Item <- GroupItems],

  prioritize_groups(Rest, AllPriorities ++ GroupPriorities).

priority_score(Bags) -> lists:sum(prioritize_groups(Bags)).

main([]) ->
  {ok, File} = file:read_file("a.txt"),
  Input = [binary:bin_to_list(Line) || Line <- string:split(File, <<"\n">>, all)],
  PriorityScore = priority_score(Input),
  io:format("Priority score: ~p~n", [PriorityScore]).