# Lab 4: Peterson exclusion algorithm

Rodrigo Arias Mallo - <rodrigo.arias@est.fib.upc.edu>

## 3.1 Homework

### 3.1.1 Peterson's exclusion algorithm

M&K 7.7, Peterson's Algorithm for two processes (Peterson, G.L., 1981).  
Fortunately for the warring neighbors, Gary Peterson visits one day and explains 
his algorithm to them. He explains that, in addition to the flags, the neighbors 
must share a turn indicator which can take the values 1 or 2. This is used to 
avoid potential deadlock.

When one neighbor wants to enter the field, he raises his flag and sets the turn 
indicator to indicate his neighbor turn. If he sees his neighbor's flag and it 
is his neighbor's turn, he can not enter but must try again later. Otherwise, he 
can enter the field and pick berries and must lower his flag after leaving the 
field.

For instance, neighbor n1 behaves as shown below, and neighbor n2 behaves 
symmetrically.

	while (true) {
		flag1 = true; turn = 2;
		while (flag2 and turn==2) {};
		enterField; pickBerries;
		flag1 = false;
	}

Solve the following questions:

1. Model Peterson's Algorithm for the two neighbors and provide its FSP 
   description. Check that it does indeed avoid deadlock and satisfy the mutual 
   exclusion (safety) and berrypicking (progress) properties, even in adverse 
   conditions as when both neighbors are greedy.
   Hint : The following FSP can be used to model the turn indicator.


	set CardActions = {set1,set2,[1],[2]}

	CARDVAR = VAL[1],
	VAL[i:Card] = ( set1 -> VAL[1]| set2 -> VAL[2] | [i] -> VAL[i]).

The model can be found in [1/model.fsp](1/model.fsp). The analyzer shows no deadlock:

	No deadlocks/errors

No progress violations:

	Progress Check...
	-- States: 100 Transitions: 168 Memory used: 4532K
	No progress violations detected.
	Progress Check in: 6ms

Even the GREEDY process shows no deadlocks:

	No deadlocks/errors

And now, no progress violations:

	Progress Check...
	-- States: 61 Transitions: 90 Memory used: 4389K
	No progress violations detected.
	Progress Check in: 5ms

Note: Again, the model completed from the snippets seems to be not working. It 
can be found in [1/wrong-model.fsp](1/wrong-model.fsp). The number of states and 
transitions of both models are different, even after minimization:

	model.fsp
	FIELD  Minimised States: 49
	GREEDY Minimised States: 49

	wrong-model.fsp
	FIELD  Minimised States: 63
	GREEDY Minimised States: 63

2. Implement in Java the warring neighbors system using the Peterson's protocol.  
   Check that this program version avoid the progress problems present in the 
   previous week code version when neighbors are greedy (code corresponding to 
   exercise 7.6 of M&K).

The java code can be found in the [2/](2/) directory. Now the output shows the 
processes accessing the field.

	$ java Field | head -20
	try again, my name is: alice
	try again, my name is: bob
	bob enters
	alice enters
	bob exits
	try again, my name is: bob
	alice exits
	bob enters
	try again, my name is: alice
	alice enters
	bob exits
	try again, my name is: bob
	alice exits
	bob enters
	try again, my name is: alice
	alice enters
	bob exits
	alice exits
	try again, my name is: bob
	try again, my name is: alice


