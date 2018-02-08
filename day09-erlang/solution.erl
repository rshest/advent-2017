-module(solution).
-export([solution/0]).

skip_garbage([$> | Text], GarbageChars) -> {Text, GarbageChars};
skip_garbage([$!, _ | Text], GarbageChars) -> skip_garbage(Text, GarbageChars);
skip_garbage([_ | Text], GarbageChars) -> skip_garbage(Text, GarbageChars + 1).

process(Text) -> process(Text, 0, 0, 1).
process([], Score, GarbageChars, _) -> {Score, GarbageChars};
process([Token | Text], Score, GarbageChars, Level) ->
    case Token of
        $} when Level =:= 1 -> {Score, GarbageChars};
        $} -> process(Text, Score, GarbageChars, Level - 1);
        ${ -> process(Text, Score + Level, GarbageChars, Level + 1);
        $< ->
            {Text1, GarbageChars1} = skip_garbage(Text, GarbageChars),
            process(Text1, Score, GarbageChars1, Level);
        _ -> process(Text, Score, GarbageChars, Level)
    end.

solution() ->
    {ok, File} = file:open("input.txt", [read]),
    Text = io:get_line(File, ""),
    {Score, GarbageChars} = process(Text),
    io:format("Part 1: ~p~nPart 2: ~p~n", [Score, GarbageChars]).
