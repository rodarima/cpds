public class BadPotTwo
{
	private int servings = 0;
	private int capacity;

	public BadPotTwo(int _capacity)
	{
		capacity = _capacity;
		servings = _capacity;
		print_servings();
	}

	public void getserving() throws InterruptedException
	{
		// Condition synchronization: at least one serving available,
		// otherwise, go to the Waiting Set til the cook fill the pot
		if (servings == 0) {
			System.out.println(Thread.currentThread().getName() + " go walk");
			return;
		}
		Thread.sleep(200);
		/* As this method is not sync, other threads could enter here,
		so during the time that servings kept not updated, other threads could pass
		the if and acess here at the same time. Using a sleep helps to other
		threads to get here. */
		--servings;
		System.out.println(Thread.currentThread().getName() + " is served");
		print_servings();
	}

	public void fillpot() throws InterruptedException
	{
		//Condition synchronization: .....
		//....
		if (servings > 0) {
			System.out.println(Thread.currentThread().getName() + 
				" has to wait until pot is empty");
			return;
		}
		servings = capacity;
		System.out.println(Thread.currentThread().getName() +
			" fills the pot");
		print_servings();
		// wake up threads in Waiting Set in order to asure....
		print_servings();
	}

	//only for trace purposes
	public synchronized void print_servings() {
		System.out.println("servings in the pot: " + servings);
	}
}
