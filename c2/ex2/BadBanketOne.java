public class BadBanketOne
{

	public static void main(String args[])
	{
		BadPot pot = new BadPot(5);
		String[] savages = {"alice", "bob", "peter", "xana", "tom",
			"jerry", "kim", "berta"};

		for (int i = 0; i < savages.length; i++)
		{
			String name = savages[i];
			Thread s = new Savage(pot);
			s.setName(name);
			s.start();
		}

		Thread c = new Cook(pot);
		c.setName("cook");
		c.start();
	}
}
