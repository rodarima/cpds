import java.util.Random;

class Bank extends Thread
{
	Account account;
	int N;

	public Bank(Account account)
	{
		this.account = account;
		this.N = account.N;
	}

	public void run()
	{
		while(true)
		{
			Random rnd = new Random();
			int amount;

			try
			{
				amount = rnd.nextInt(N) + 1;

				System.out.println(Thread.currentThread().getName() +
					" is going to deposit " + amount);

				account.deposit(amount);
				Thread.sleep(20);
			}
			catch(InterruptedException e){};
		}
	}
}

