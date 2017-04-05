public class FieldGreedy {
	public static void main(String args[]) {
		Flags flags = new Flags();

		Thread a = new NeighborGreedy(flags);
		Thread b = new NeighborGreedy(flags);

		a.setName("alice");
		b.setName("bob");

		a.start();
		b.start();
	}
}
