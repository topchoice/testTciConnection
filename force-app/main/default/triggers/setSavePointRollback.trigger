trigger setSavePointRollback on Account (after update) {

    Account a = new Account(Name = 'Dynasty Auto'); insert a;
    System.assertEquals(null, [SELECT Website FROM Account WHERE Id = :a.Id].Website);
    
    //Create a savepoint while website is null
    Savepoint sp = Database.setSavePoint();
    
    //Change the website address 
    a.Website = 'http://www.dynastyautogroup.com/';
    update a;
    System.assertEquals('http://www.dynastyautogroup.com/', [SELECT Website FROM Account WHERE Id = :a.Id].Website);
    
    //Rollback to the previous null value
    Database.rollback(sp);
    System.assertEquals(Null, [SELECT Website FROM Account WHERE Id = :a.Id].Website);

}