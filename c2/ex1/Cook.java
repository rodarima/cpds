public class Cook extends Thread
{
	Pot pot;
	public Cook(Pot pot)
	{
		this.pot = pot;
	}
	public void run()
	{
		while (true) {
			System.out.println(Thread.currentThread().getName() +
				" would like to fill the pot");
			try {
				System.out.println(Thread.currentThread().getName() +
					" waits for a while");
				Thread.sleep(200);
				System.out.println(Thread.currentThread().getName() +
					" tries to fill the pot");
				pot.fillpot();
			}
			catch(InterruptedException e) {};
		}
	}
}
