pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
cartdata("nlb_batshit_basement")
ending_type = dget(63)
tick = 0
end

function _update()
 if ending_type == 1 then
  update_bus()
 end
end

function _draw()
if ending_type == 1 then
  draw_bus()
 end

end
-->8
function update_bus()
 tick += 1
 if s == nil then
  s = 19
 elseif tick % 5 == 0 then
   if s == 19 then
    s = 23 
   else s = 19
   end
 end
end

function draw_bus()
 cls(15)
 palt(0,true)
 palt(11,true)
 map(0,0,0,20,16,8)
 rectfill(0,84,128,128,0)
 rectfill(0,0,128,20,0)
  palt(0,false)
 spr(s, 30,34,4,4)
 
 if tick < 90 then
  print("THREE BLOCKS WERE DESTROYED", 2,90,7)
  print("WITHOUT WARNING LAST NIGHT,", 10,100,7)
 elseif tick < 180 then
  print("WHEN A SINKHOLE OPENED UP.", 2, 90,7)
 elseif tick < 270 then
  print("WITNESSES SAID THEY SAW, QUOTE,", 2,90,7)
 elseif tick < 400 then
    print("'THE SOULS OF THE DAMNED",2,90,7)
    print("ESCAPING INTO THE SKY...'", 10, 100, 7)
 else
  cls(0)
  palt(11,false)
  print("THE END!", 45,30,11)
  print("you... win?",40,40,11)
 end
 
 
end
__gfx__
00000000444444449999999944444444555555555555555511111111555555555511111111111155111111111111115555111111000000007777777700000000
00000000444444444444444444444444555555555555555511111111555555555511111111111155111111111111115555111111000000007cccc77700000000
00700700444444444444444444444444551111111111111111111111111111555511111111111155111111111111115555111111000000007cccc77700000000
00077000444444444444444444444444551111111111111111111111111111555511111111111155111111111111115555111111000000007766777700000000
00077000444444444444444444444444551111111111111111111111111111555511111111111155111111111111115555111111000000007677677700000000
00700700444444444444444444444444551111111111111111111111111111555511111111111155111111111111115555111111000000006777767700000000
00000000444444444444444444444444551111111111111155555555111111555555555555555555111111111111115555111111000000006cccc67700000000
00000000444444444444444499999999551111111111111155555555111111555555555555555555111111111111115555111111000000006cccc67700000000
000000009999900000044444bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb7777777700000000000000006cccc67700000000
000000004444440000444444bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb77777777000000000066600076cc677700000000
000000004444444004444444bbbbbbbbbbbb44444444bbbbbbbbbbbbbbbbbbbbbbbb44444444bbbbbbbbbbbb77777777000000000600060076cc677700000000
000000004444444004444444bbbbbbbbb444444444444444bbbbbbbbbbbbbbbbb444444444444444bbbbbbbb7777777700000000060006006cccc67700000000
000000004444444444444444bbbbbbb444444444444444444bbbbbbbbbbbbbb444444444444444444bbbbbbb7777777700000000600000606cccc67700000000
000000004444444444444444bbbbbb44444444444444444444bbbbbbbbbbbb44444444444444444444bbbbbb7777777700000000600000606cccc67700000000
000000004444444444444444bbbbb4444444444444444444444bbbbbbbbbb4444444444444444444444bbbbb7777777700000000600000606cccc67700000000
000000004444444444444444bbbbb4444444444444444444444bbbbbbbbbb4444444444444444444444bbbbb7777777700000000666666607666677700000000
000000000000000000000000bbbbb444444444ffff4444444444bbbbbbbbb444444444ffff4444444444bbbb0000000000000000000000000000000000000000
000000000000000000000000bbbb444444444fffffff44444444bbbbbbbb444444444fffffff44444444bbbb0000000000000000000000000000000000000000
000000000000000000000000bbbb444444444ffffffff44444444bbbbbbb444444444ffffffff44444444bbb0000000000000000000000000000000000000000
000000000000000000000000bbb444444444fffffffff44444444bbbbbb444444444fffffffff44444444bbb0000000000000000000000000000000000000000
000000000000000000000000bbb44444444ffffffffff44444444bbbbbb44444444ffffffffff44444444bbb0000000000000000000000000000000000000000
000000000000000000000000bbb44444fffffffffffff44444444bbbbbb44444fffffffffffff44444444bbb0000000000000000000000000000000000000000
000000000000000000000000bbb4444fffff777fff777ff4444444bbbbb4444fffff777fff777ff4444444bb0000000000000000000000000000000000000000
000000000000000000000000bbb4444fffff740fff740ff4444444bbbbb4444fffff740fff740ff4444444bb0000000000000000000000000000000000000000
000000000000000000000000bbb4444fffff700fff700ff44444444bbbb4444fffff700fff700ff44444444b0000000000000000000000000000000000000000
000000000000000000000000bbb4444fffffffffffffffff4444444bbbb4444fffffffffffffffff4444444b0000000000000000000000000000000000000000
000000000000000000000000bb44444fffffffffffffffff4444444bbb44444fffffffffffffffff4444444b0000000000000000000000000000000000000000
000000000000000000000000bb44444ffffffff444fffffff444444bbb44444ffffffff444fffffff444444b0000000000000000000000000000000000000000
000000000000000000000000bb444444fffffffffffffffff444444bbb444444fffffffffffffffff444444b0000000000000000000000000000000000000000
000000000000000000000000bb444444fffff5555555fffff444444bbb444444fffffffffffffffff444444b0000000000000000000000000000000000000000
000000000000000000000000bb4444444ffff5555555ffff4444444bbb4444444fffff55555ffffff444444b0000000000000000000000000000000000000000
000000000000000000000000bb44444444fffffffffffff44444444bbb4444444fffff55555fffff4444444b0000000000000000000000000000000000000000
000000000000000000000000bb444444444fffffffffff444444444bbb44444444ffff55555ffff44444444b0000000000000000000000000000000000000000
000000000000000000000000bb444444444fffffffffff44444444bbbb444444444fff55555ffff4444444bb0000000000000000000000000000000000000000
000000000000000000000000bb444444444fffffffffff44444444bbbb444444444fffffffffff44444444bb0000000000000000000000000000000000000000
000000000000000000000000bb4444444666ffffffffff6644444bbbbb4444444666ffffffffff6644444bbb0000000000000000000000000000000000000000
000000000000000000000000bbb44466660677777777660064444bbbbbb44466660677777777660064444bbb0000000000000000000000000000000000000000
000000000000000000000000bbbb66600006677777766000044466bbbbbb66600006677777766000044466bb0000000000000000000000000000000000000000
000000000000000000000000bbb6600000006677776600000004066bbbb6600000006677776600000004066b0000000000000000000000000000000000000000
000000000000000000000000b6600000000006777760000000000066b66000000000067777600000000000660000000000000000000000000000000000000000
__map__
1b1b00001b1b00001b1b00001b1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b040505050505050700001b1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b0c0a0a0a0a0a0a0b00001b1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b0c0a0a0a0a0a0a0b00001b1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b0c0a0a0a0a0a0a0b00000e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b0806060606060609001d1e1e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102020202020101020202020201010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000