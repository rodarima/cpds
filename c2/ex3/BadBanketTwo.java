public class BadBanketTwo
{

	public static void main(String args[])
	{
		BadPotTwo pot = new BadPotTwo(5);
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
