public class Turn {
	private String turn;
	public Turn() {
		turn = "";
	}
	public synchronized void set(String s) {
		if (s.equals("alice")) { turn = "bob"; }
		else { turn = "alice"; }
	}
	public synchronized boolean is_my_turn(String name) {
		return turn.equals(name);
	}
}
