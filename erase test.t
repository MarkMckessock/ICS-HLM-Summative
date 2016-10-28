
%Pic.ScreenLoad("MainLevel.jpg",0,0,0)
%Draw.FillBox(0,0,300,300,white)
%cls
%View.Update
%put "cat"

var font1 : int := Font.New("serif:12")
var x,y,button : int
View.Set("offscreenonly")
loop
%Pic.ScreenLoad("MainLevel.jpg",0,0,0)
Draw.FillOval(50,50,50,50,red)
Font.Draw("Hello",100,100,font1,red)

mousewhere(x,y,button)
View.UpdateArea(x-10,y-10,x+10,y+10)
end loop
