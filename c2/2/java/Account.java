public class Account
{
	private int balance = 0;
	public int N;

	public Account(int N)
	{
		this.N = N;
		print_balance();
	}

	public synchronized void deposit(int amount) throws InterruptedException
	{
		if (balance + amount > N) {
			System.out.println(Thread.currentThread().getName() + " cannot deposit");
			return;
		}
		balance += amount;
		System.out.println(Thread.currentThread().getName() + " deposits " + amount);
		print_balance();
	}

	public synchronized void withdraw(int amount) throws InterruptedException
	{
		if (balance - amount < 0) {
			System.out.println(Thread.currentThread().getName() + 
				" cannot withdraw");
			return;
		}
		balance -= amount;
		System.out.println(Thread.currentThread().getName() +
			" withdraws " + amount);
		print_balance();
	}

	public synchronized void print_balance() {
		System.out.println(" ------ balance in the account: " + balance);
	}
}
