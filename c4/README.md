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
	-- States: 864 Transitions: 7200 Memory used: 24105K
	No progress violations detected.
	Progress Check in: 11ms

Even the GREEDY process shows no deadlocks:

	No deadlocks/errors

And now, no progress violations:

	Progress Check...
	-- States: 171 Transitions: 378 Memory used: 12379K
	No progress violations detected.
	Progress Check in: 6ms

