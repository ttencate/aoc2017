NB. Read stdin into a string, trimming off the trailing newline.
NB. 'se,sw,se,sw,sw'
NB. inputstr =: }: (1!:1) 3

NB. Tokenize to get a table (?) of boxed strings (?).
NB. See the "voyage of discovery": http://code.jsoftware.com/wiki/Vocabulary/eq#dyadic
NB. ┌──┬─┬──┬─┬──┬─┬──┬─┬──┐
NB. │se│,│sw│,│se│,│sw│,│sw│
NB. └──┴─┴──┴─┴──┴─┴──┴─┴──┘
NB. tokens =: ;: inputstr

NB. With the commas removed.
NB. ┌──┬──┬──┬──┬──┐
NB. │se│sw│se│sw│sw│
NB. └──┴──┴──┴──┴──┘
NB. input =: ((<,',') ~: tokens) # tokens

NB. Now all jammed together using a fork. Because I can. I think this could be
NB. a hook as well, to get rid of the ].
input =: ((<, ',') & ~: # ]) ;: }: (1!:1) 3

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
NB. stepindices =: stepnames i. input

NB. Look up the steps themselves.
NB. ┌────┬────┬────┬────┬────┐
NB. │1 _1│_1 0│1 _1│_1 0│_1 0│
NB. └────┴────┴────┴────┴────┘
NB. steps =: stepindices { stepsizes

NB. Add up all the steps, after unboxing them.
NB. position =: +/ > steps

NB. And now all together!
echo +/ > (stepnames i. input) { stepsizes
