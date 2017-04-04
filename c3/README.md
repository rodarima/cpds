# Lab 3: Safety and Progress

Rodrigo Arias Mallo - <rodrigo.arias@est.fib.upc.edu>

## 3.2 Homework

### 3.2.2 Exercises

1. (M&K 7.6: The Warring Neighbors) Two warring neighbors are separated by a 
   field with wild berries. They agree to permit each other to enter the field 
   to pick berries, but also need to ensure that only one of them is ever in the 
   field at a time. After negotiation, they agree to the following protocol.
   
   When one neighbor wants to enter the field, he raises a flag. If he sees his 
   neighbor’s flag, he does not enter but lowers his flag and tries again. If he 
   does not see his neighbor’s flag, he enters the field and picks berries. He 
   lowers his flag after leaving the field. Model this algorithm for two 
   neighbors, n1 and n2.

The following schema can be used to model the flags. Please complete the snipped
code.

	const False = 0
	const True = 1
	range Bool = False..True

	set BoolActions={setTrue, setFalse,[False],[True]}

	BOOLVAR=VAL[False],
	VAL[v:Bool]=(setTrue-> VAL[True]
					|setFalse->VAL[False]
					|[v]-> VAL[v]
	).

	||FLAGS =(flag1:BOOLVAR || flag2:BOOLVAR).


	NEIGHBOR1=(flag1.setTrue -> TEST),
	TEST=(flag2[raised:Bool]->
				if(raised) then
					(flag1.setFalse-> NEIGHBOR1)
				else
					(enter->exit->flag1.setFalse->NEIGHBOR1)
	)+ {{flag1,flag2}.BoolActions}.


	NEIGHBOR2=(flag2.setTrue -> TEST),
	TEST=(flag1[raised:Bool]->
				if(raised) then
					(flag2.setFalse -> NEIGHBOR2)
				else
					(enter->exit->flag2.setFalse->NEIGHBOR2)
	)+ {{flag1,flag2}.BoolActions}.




Specify the required safety property MUTEX for the field and check that it does indeed
ensure mutually exclusive access. In order to do the check, define a FIELD process by
composing processes FLAGS, NEIGHBORs and MUTEX and do the test with the 
analyser.

	property ||MUTEX = (n1:MUTEX_1||n2:MUTEX_2).
	MUTEX_1 = (flag1.setTrue -> SAFE),
	SAFE= ( flag2[False] -> flag1.setFalse -> MUTEX_1
		  | flag2[True] -> flag1.setFalse -> MUTEX_1).

	MUTEX_2 = (flag2.setTrue -> SAFE),
	SAFE= (flag1[False] -> flag2.setFalse -> MUTEX_2
		  |flag1[True] ->flag2.setFalse->MUTEX_2).

	||FIELD=(n1:NEIGHBOR1 || n2:NEIGHBOR2 || FLAGS || MUTEX ).

Specify progress properties for the neighbors in order to check that, under fair 
scheduling policies, they eventually enter to the field to pick berries.


	progress ENTER1={n1.enter} //neigh 1 always gets to enter
	progress ENTER2={n2.enter} //neigh 2 always gets to enter


Are there any adverse circumstances in which neighbors would not make progress?
What if the neighbors are greedy?
Hint: Greedy neighbors - make setting the flags high priority - eagerness to enter.
Provide the FSP description of the greedy neighbors and use the analyser to 
check progress violations to enter.

	||GREEDY = FIELD << {flag1.setTrue, flag2.setTrue}.

