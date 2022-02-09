public virtual class test_Data 
{
	public Account acct1 { get; set; }
	public Account acct2 { get; set; }
	public Contact cont1 { get; set; }
	public Contact cont2 { get; set; }
	public Contact cont3 { get; set; }
	public Contact cont4 { get; set; }

	public test_Data() 
	{
		Database.DMLOptions dml = new Database.DMLOptions();
		dml.DuplicateRuleHeader.AllowSave = true; 

		acct1 = getAccountByName('TEST ACCT 1');

		if (acct1 == null)
		{
			acct1 = new Account();
			acct1.Name = 'TEST ACCT 1';
			acct1.NumberOfEmployees = 50;
			acct1.Industry = 'Construction';
			Database.insert(acct1, dml); 
		}
		
		acct2 = getAccountByName('TEST ACCT 2');

		if (acct2 == null)
		{
			acct2 = new Account();
			acct2.Name = 'TEST ACCT 2';
			acct2.NumberOfEmployees = 100;
			acct2.Industry = 'Energy';
			Database.insert(acct2, dml); 
		}

		cont1 = getContactByEmail('jdaniel@company.com');

		if (cont1 == null)
		{
			cont1 = new Contact();
			cont1.FirstName = 'John';
			cont1.LastName = 'Daniel';
			cont1.Email = 'jdaniel@company.com';
			cont1.AccountId = acct1.Id;
			cont1.Birthdate = Date.today();
			Database.insert(cont1, dml); 
		}

		cont2 = getContactByEmail('jsmith@company.com');

		if (cont2 == null)
		{
			cont2 = new Contact();
			cont2.FirstName = 'Jane';
			cont2.LastName = 'Smith';
			cont2.Email = 'jsmith@company.com';
			cont2.AccountId = acct1.Id;
			Database.insert(cont2, dml); 
		}
		
		cont3 = getContactByEmail('rjones@company.com');

		if (cont3 == null)
		{
			cont3 = new Contact();
			cont3.FirstName = 'Ralph';
			cont3.LastName = 'Jones';
			cont3.Email = 'rjones@company.com';
			cont3.AccountId = acct2.Id;
			cont3.Birthdate = Date.today();
			Database.insert(cont3, dml); 
		}
		
		cont4 = getContactByEmail('jdoe@company.com');

		if (cont4 == null)
		{
			cont4 = new Contact();
			cont4.FirstName = 'Jane';
			cont4.LastName = 'Doe';
			cont4.Email = 'jdoe@company.com';
			cont4.AccountId = acct2.Id;
			Database.insert(cont4, dml); 
		}
	}

	public Account getAccountByName(String name)
	{
		dao_Account dao = new dao_Account();
		List<Account> accts = dao.findAccountsByNames(new Set<String> { name });

		if (accts != null && !accts.isEmpty())
		{
			return accts[0];
		}

		return null;
	}

	public Contact getContactByEmail(String email)
	{
		dao_Contact dao = new dao_Contact();
		List<Contact> conts = dao.findContactsByEmails(new Set<String> { email });

		if (conts != null && !conts.isEmpty())
		{
			return conts[0];
		}

		return null;
	}
}