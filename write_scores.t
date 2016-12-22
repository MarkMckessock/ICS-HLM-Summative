type score:
    record
        time_string : string
        miliseconds : int
        player_first_name : string
        player_last_name : string
    end record
var scores : array 1 .. 11 of score
for item : 1 .. 11
    scores(item).player_first_name := "null"
    scores(item).player_last_name := "null"
    scores(item).time_string := "999,999,999"
    scores(item).miliseconds := 999999999
end for
var file_num : int
open : file_num,"hot_data",write
    write: file_num, scores
close : file_num
    