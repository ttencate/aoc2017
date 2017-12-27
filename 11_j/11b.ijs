NB. Read stdin into a string, trimming off the trailing newline.
NB. 'se,sw,se,sw,sw'
inputstr =: }: (1!:1) 3

NB. Tokenize to get a table (?) of boxed strings (?).
NB. See the "voyage of discovery": http://code.jsoftware.com/wiki/Vocabulary/eq#dyadic
NB. ┌──┬─┬──┬─┬──┬─┬──┬─┬──┐
NB. │se│,│sw│,│se│,│sw│,│sw│
NB. └──┴─┴──┴─┴──┴─┴──┴─┴──┘
tokens =: ;: inputstr

NB. With the commas removed.
NB. ┌──┬──┬──┬──┬──┐
NB. │se│sw│se│sw│sw│
NB. └──┴──┴──┴──┴──┘
input =: ((<,',') ~: tokens) # tokens

NB. Tabulate the steps.
NB. ┌─┬──┬──┬──┬──┬─┐
NB. │n│nw│ne│sw│se│s│
NB. └─┴──┴──┴──┴──┴─┘
NB. ┌───┬────┬───┬────┬────┬────┐
NB. │0 1│_1 1│1 0│_1 0│1 _1│0 _1│
NB. └───┴────┴───┴────┴────┴────┘
NB. Single characters get rank 0 (atoms) while multiple characters get rank 1
NB. (lists), which is why we need 1$ on the single-char names.
stepnames =: (1$'n'); 'nw'; 'ne'; 'sw'; 'se'; (1$'s')
stepsizes =:    0 1 ; _1 1; 1 0 ; _1 0; 1 _1;   0 _1

NB. Look up the index of each step.
NB. 4 3 4 3 3
NB. I'm not sure why the 6 | is needed, but index 0 somehow comes back as 6.
stepindices =: stepnames i. input

NB. Look up the steps themselves.
NB. ┌────┬────┬────┬────┬────┐
NB. │1 _1│_1 0│1 _1│_1 0│_1 0│
NB. └────┴────┴────┴────┴────┘
steps =: stepindices { stepsizes

NB. Add up all the steps cumulatively, after unboxing them.
positions =: +/\ > steps

NB. Mirror negative-x positions in the origin to make all x coordinates
NB. nonnegative.
rightpositions =: ((0 <: 0 }"1 positions) * positions) + ((-0 > 0 }"1 positions) * positions)

NB. Now distance = max(x, -y, x+y).
xs =: 0 }"1 rightpositions
ys =: 1 }"1 rightpositions
distances =: xs >. (-ys) >. (xs + ys)

NB. Finally, print the maximum distance.
echo >./ distances
