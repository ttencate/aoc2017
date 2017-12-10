input =: ". }: (1!:1) 3
initlist =: i.5
current =: 0
rotateleft =: (current ,: y) |.;.0 x
copyright =: ((y + 1) ,: _) ];.0 x
step =: x (rotateleft , copyright)
echo step/ (<initlist) , ;/ input
