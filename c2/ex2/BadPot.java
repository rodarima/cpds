public class BadPot
{
	private int servings = 0;
	private int capacity;

	public BadPot(int _capacity)
	{
		capacity = _capacity;
		servings = _capacity;
		print_servings();
	}

	public synchronized void getserving() throws InterruptedException
	{
		// Condition synchronization: at least one serving available,
		// otherwise, go to the Waiting Set til the cook fill the pot
		if (servings == 0) {
			System.out.println(Thread.currentThread().getName() + " has to wait for some food");
			//Thread.sleep(100);
			//Thread.sleep(200);
			//return;
			wait();
			/* After calling wait() other threads could enter the mutual exclusion
			section, and bypassing the servings check. Once the cook is ready, they
			eventually wake up, without checking the counter anymore */
		}
		--servings;
		System.out.println(Thread.currentThread().getName() + " is served");
		// when necessary, wake up threadsin Waiting Set in order to asure
		// a runnable cook
		if (servings == 0) notifyAll();
		print_servings();
	}

	public synchronized void fillpot() throws InterruptedException
	{
		//Condition synchronization: .....
		//....
		if (servings > 0) {
			System.out.println(Thread.currentThread().getName() + 
				" has to wait until pot is empty");
			//Thread.sleep(200);
			//return;
			wait();
		}
		servings = capacity;
		System.out.println(Thread.currentThread().getName() +
			" fills the pot");
		print_servings();
		// wake up threads in Waiting Set in order to asure....
		print_servings();
		notifyAll();
	}

	//only for trace purposes
	public synchronized void print_servings() {
		System.out.println("servings in the pot: " + servings);
	}
}
