public class Field {
	public static void main(String args[]) {
		Flags flags = new Flags();
		Turn turn = new Turn();

		Thread a = new Neighbor(flags, turn);
		Thread b = new Neighbor(flags, turn);

		a.setName("alice");
		b.setName("bob");

		a.start();
		b.start();
	}
}
