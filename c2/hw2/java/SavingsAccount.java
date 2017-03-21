class SavingsAccount{

	public static void main(String args[])
	{
		int N = 10;
		Account ac = new Account(N);

		Thread alice = new Person(ac);
		alice.setName("Alice");

		Thread bob = new Person(ac);
		bob.setName("Bob");

		Thread bank = new Bank(ac);
		bank.setName("Bank");

		alice.start();
		bob.start();
		bank.start();

	}
}
