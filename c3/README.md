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

	const False =0
	const True=1
	range Bool = False..True
	set BoolActions = {setTrue, setFalse, [False], [True]}

	BOOLVAR = VAL[False], VAL[v:Bool] = (
		setTrue	-> VAL[True] |
		setFalse-> VAL[False] |
		[v] -> VAL[v]
	).

	||FLAGS =(flag1:BOOLVAR || flag2:BOOLVAR).

	NEIGHBOR1 = (flag1.setTrue -> TEST),
		TEST = (flag2[raised:Bool]  ->
			if(raised) then
				(flag1.setFalse -> NEIGHBOR1)
			else
				(enter1 -> exit1 -> flag1.setFalse -> NEIGHBOR1)
	).

	NEIGHBOR2=(flag2.setTrue -> TEST),
		TEST=(flag1[raised:Bool] ->
			if(raised) then
				(flag2.setFalse -> NEIGHBOR2)
			else
				(enter2->exit2->flag2.setFalse->NEIGHBOR2)
	).


Specify the required safety property MUTEX for the field and check that it does indeed
ensure mutually exclusive access. In order to do the check, define a FIELD process by
composing processes FLAGS, NEIGHBORs and MUTEX and do the test with the 
analyser.


	property MUTEX = (enter1 -> exit1 -> MUTEX | enter2 -> exit2 -> MUTEX).

	||FIELD=(NEIGHBOR1 || NEIGHBOR2 || FLAGS || MUTEX ).


The analyzer shows no progress violations:

	Progress Check...
	-- States: 27 Transitions: 54 Memory used: 6152K
	No progress violations detected.
	Progress Check in: 7ms

Specify progress properties for the neighbors in order to check that, under fair 
scheduling policies, they eventually enter to the field to pick berries.

	progress ENTER1={enter1} //neigh 1 always gets to enter
	progress ENTER2={enter2} //neigh 2 always gets to enter

Are there any adverse circumstances in which neighbors would not make progress?

Yes, if both raise the flag at the same time and none gets in.

What if the neighbors are greedy?
Hint: Greedy neighbors - make setting the flags high priority - eagerness to enter.
Provide the FSP description of the greedy neighbors and use the analyser to 
check progress violations to enter.

	||GREEDY = FIELD << {flag1.setTrue, flag2.setTrue}.

Now the analyzer detects a progress violation.

	Progress Check...
	-- States: 9 Transitions: 14 Memory used: 4319K
	Finding trace to cycle...
	Finding trace in cycle...
	Progress violation: ENTER2 ENTER1
	Trace to terminal set of states:
		flag2.setTrue
	Cycle in terminal set:
		flag1.setTrue
		flag2.1
		flag1.setFalse
	Actions in terminal set:
		{flag1, flag2}.{[1], {setFalse, setTrue}}
	Progress Check in: 7ms

The full model can be found in [1/model.fsp](1/model.fsp).

Note: There is a model following the snippets of code in the statement in 
[1/wrong-model.fsp](1/wrong-model.fsp) but doesn't work. The progress properties 
are never violated. I don't understand why occurs nor I don't understand the 
prefix n1. and n2. scope.

2.  Field Program We ask to develop a Field Java program corresponding to the 
    Warring Neighbors exercise. As usual neighbors are alice denoted as a and 
    bob denoted as b.

Complete the following snipped code:

	$ cat 2/Field.java
	public class Field {
		public static void main(String args[]) {
			Flags flags = new Flags();

			Thread a = new Neighbor(flags);
			Thread b = new Neighbor(flags);

			a.setName("alice");
			b.setName("bob");

			a.start();
			b.start();
		}
	}

Following a snipped for Flag

	$ cat 2/Flags.java
	public class Flags {
		private boolean flag_alice;
		private boolean flag_bob;
		public Flags() {
			flag_alice = false;
			flag_bob = false;
		}
		public synchronized boolean query_flag(String s) {
			//no condition synchronization is needed
			if (s.equals("alice")) return flag_bob;
			return flag_bob ;
		}
		public synchronized void set_true(String s) {
			//no condition synchronization is needed
			if (s.equals("alice")) { flag_alice = true;}
			else { flag_bob = true; }
		}
		public synchronized void set_false(String s) {
			//no condition synchronization is needed
			if (s.equals("alice")) { flag_alice = false; }
			else { flag_bob = false; }
		}
	}

Finally the neighbor (with no stress).

	$ cat 2/Neighbor.java
	public class Neighbor extends Thread {
		private Flags flags;
		public Neighbor(Flags flags) {
			this.flags = flags;
		}
		public void run() {
			while (true) {
				try {
					String name = Thread.currentThread().getName();
					System.out.println("try again, my name is: "+ name);
					Thread.sleep((int)(200 * Math.random()));
					flags.set_true(name);
					if ( flags.query_flag(name) == false ) {
						System.out.println(name + " enter");
						Thread.sleep(400);
						System.out.println(name + " exits");
					}
					Thread.sleep((int)(200 * Math.random()));
					flags.set_false(name);
				}
				catch (InterruptedException e) {};
			}
		}
	}

A possible printout could be

	$ java Field | head -20
	try again, my name is: alice
	try again, my name is: bob
	alice enter
	try again, my name is: bob
	try again, my name is: bob
	try again, my name is: bob
	alice exits
	try again, my name is: alice
	try again, my name is: bob
	alice enter
	try again, my name is: bob
	try again, my name is: bob
	alice exits
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: bob
	alice enter
	try again, my name is: bob

In order to model stress (or greedy), just change the sleep

	$ cat 2/NeighborGreedy.java
	public class NeighborGreedy extends Thread {
		private Flags flags;
		public NeighborGreedy(Flags flags) {
			this.flags = flags;
		}
		public void run() {
			while (true) {
				try {
					String name = Thread.currentThread().getName();
					System.out.println("try again, my name is: "+ name);
					flags.set_true(name);
					//To model greedy write the sleep as follows
					Thread.sleep((int)(200 * Math.random()));
					if ( flags.query_flag(name) == false ) {
						System.out.println(name + " enter");
						Thread.sleep(400);
						System.out.println(name + " exits");
					}
					Thread.sleep((int)(200 * Math.random()));
					flags.set_false(name);
				}
				catch (InterruptedException e) {};
			}
		}
	}

and in this case the printout should be:

	$ java FieldGreedy | head -20
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: bob
	try again, my name is: alice
	try again, my name is: alice
	try again, my name is: bob

All the java source code can be found in the [2/](2/) folder.
