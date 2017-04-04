public class Field {
	public static void main(String args[]) {
		Flags flags = new Flags();

		Thread a = new Neighbor(flags);
		Thread b = new Neighbor(flags);

		a.setName("alice");
		b.setName("bob");

		a.start();
		b.start();
	}
}
