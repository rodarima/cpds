import java.util.Random;

public class Person extends Thread
{
	Account account;
	int N;

	public Person(Account account)
	{
		this.account = account;
		this.N = account.N;
	}

	public void run()
	{
		Random r = new Random();
		while (true)
		{
			try
			{
				boolean is_deposit = r.nextBoolean();
				int amount = r.nextInt(N) + 1;
				String op = is_deposit ? "deposit" : "withdraw";
				System.out.println(Thread.currentThread().getName() +
					" is going to " + op + " " + amount);

				if (is_deposit)
					account.deposit(amount);
				else
					account.withdraw(amount);

				System.out.println(Thread.currentThread().getName() +
					" is going to sleep");
				Thread.sleep(20);
			}
			catch(InterruptedException e) {};
		}
	}
}
