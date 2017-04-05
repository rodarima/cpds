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
