View.Set("graphics, offscreenonly,color:red")
var frame0 : int := Pic.FileNew ("sprPWalkDoubleBarrel_0.bmp")
var sprite0 : int := Sprite.New (frame0)
var frame1 : int := Pic.FileNew ("sprPWalkDoubleBarrel_1.bmp")
var sprite1 : int := Sprite.New (frame1)
var frame2 : int := Pic.FileNew ("sprPWalkDoubleBarrel_2.bmp")
var sprite2 : int := Sprite.New (frame2)
var frame3 : int := Pic.FileNew ("sprPWalkDoubleBarrel_3.bmp")
var sprite3 : int := Sprite.New (frame3)
var frame4 : int := Pic.FileNew ("sprPWalkDoubleBarrel_4.bmp")
var sprite4 : int := Sprite.New (frame4)
var frame5 : int := Pic.FileNew ("sprPWalkDoubleBarrel_5.bmp")
var sprite5 : int := Sprite.New (frame5)
var frame6 : int := Pic.FileNew ("sprPWalkDoubleBarrel_6.bmp")
var sprite6 : int := Sprite.New (frame6)
var frame7 : int := Pic.FileNew ("sprPWalkDoubleBarrel_7.bmp")
var sprite7 : int := Sprite.New (frame7)
colorback(red)
cls
Sprite.SetPosition (sprite0, 50, 50, true)
Sprite.SetPosition (sprite1, 50, 50, true)
Sprite.SetPosition (sprite2, 50, 50, true)
Sprite.SetPosition (sprite3, 50, 50, true)
Sprite.SetPosition (sprite4, 50, 50, true)
Sprite.SetPosition (sprite5, 50, 50, true)
Sprite.SetPosition (sprite6, 50, 50, true)
Sprite.SetPosition (sprite7, 50, 50, true)
Pic.Draw(frame1,100,100,0)
procedure hide
    Sprite.Hide(sprite0)
    Sprite.Hide(sprite1)
    Sprite.Hide(sprite2)
    Sprite.Hide(sprite3)
    Sprite.Hide(sprite4)
    Sprite.Hide(sprite5)
    Sprite.Hide(sprite6)
    Sprite.Hide(sprite7)
end hide
    
loop
    for i : 1 .. 100
    Sprite.SetPosition (sprite0, 50, 50, true)
    Sprite.SetPosition (sprite1, 50, 50, true)
    Sprite.SetPosition (sprite2, 50, 50, true)
    Sprite.SetPosition (sprite3, 50, 50, true)
    Sprite.SetPosition (sprite4, 50, 50, true)
    Sprite.SetPosition (sprite5, 50, 50, true)
    Sprite.SetPosition (sprite6, 50, 50, true)
    Sprite.SetPosition (sprite7, 50, 50, true)
    Sprite.Show(sprite0)
    View.Update
    delay (300)
    hide
    Sprite.Show(sprite1)
    View.Update
    delay (300)
    hide
    View.Update
    Sprite.Show(sprite2)
    View.Update
    delay (300)
    hide
    View.Update
    Sprite.Show(sprite3)
    View.Update
    delay (300)
    hide
    View.Update
    Sprite.Show(sprite4)
    View.Update
    delay (300)
    hide
    View.Update
    Sprite.Show(sprite5)
    View.Update
    delay (300)
    hide
    View.Update
    Sprite.Show(sprite6)
    View.Update
    delay (300)
    hide
    View.Update
    Sprite.Show(sprite7)
    View.Update
    delay (300)
    hide
    end for
end loop