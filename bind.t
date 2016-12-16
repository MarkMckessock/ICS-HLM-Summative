var test : flexible array 1 .. 5 of int
var test2 : flexible array 1 .. 3 of int

proc binding (number : int)
    if number = 1 then
        bind var ref to test
        put upper(ref)
    elsif number =2 then
        bind var ref to test2
        put upper(ref)
    end if 
    
end binding
binding(1)
binding(2)
