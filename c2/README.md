## 2.2 Homework

### 2.2.1 Exercises

1. BanketNoWait. It is possible to "repair" easily the BadPotTwo keeping the
same approach. That is "just try but not wait", later you will try again. We
call such a program BanketNoWait. Compare the approaches between Banket and
BanketNoWait, which one is better (if any)?

Yes, it is possible by using `syncronized` methods `getservings` and `fillpot`.  
The complete solution code is in the [hw1](hw1/) directory.

The solution `Banket` is better, because once a proccess enters the 
`getservings` zone and no servings are available, the proccess is set to the 
waiting state. In such state, the CPU is free to attend other proccesses. Once 
the cook fills the pot, the proccess in notified, and restarts the execution.  
Also no other proccess is allowed to access the `getservings` method, while one 
proccess is waiting.

However, in the `BanketNoWait` solution, once a proccess tries to get servings 
from an empty pot, returns to check again later. This continuous polling, is not 
necesary in the `Banket`, so leaving the CPU free.

2. (M&K 5.6) The Saving Account Problem: A saving account is shared by Alice
and Bob.  Each one may deposit or withdraw funds from the account subject to the
constraint that the balance of the account must never become negative. Develop a
model for the problem and from the model derive a Java implementation for the
saving account system.  First, fill in the snipped code to obtain the FSP model


	```
	Const N = 10 //actually, it has to be a big number...

	PERSON = (deposit[0..N] -> PERSON
		|withdraw[0..N] -> ...

	).

	ACCOUNT[balance: 0..N] = (deposit[amount:0..N] -> ...
		|when(balance > 0) ..
	).
	
	||SAVING_ACCOUNT = (a:PERSON || ... || {.. , ...}::ACCOUNT).
	```

The completed model can be found under hw2/fsp [here](hw2/fsp/model.fsp)

Now develop the Java program for the Saving Account problem. In order to avoid
the execution get stuck when the balance is not enough to satisfy withdraw
orders of Alice and Bob you can assume that a third participant (perhaps a
company) shares the account and only engages in the deposit action.  Java codes
that stick to recommendations on Magge and Kramer book in Chapter 5 will get a
higher score.


