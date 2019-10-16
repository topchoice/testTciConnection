@isTest
private class AutoCreateOppOnRelatedAccount_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Account account_Obj = new Account(Name = 'Name729', avfree__Billing_Do_Not_Verify__c = false, avfree__Billing_Verified__c = false, avfree__Shipping_Do_Not_Verify__c = false, avfree__Shipping_Verified__c = false, bz_elink__Master_Account__c = false, bz_elink__Send_to_Lexis_Nexis_Automatically__c = false, Team_Login__c = false);
    Insert account_Obj; 
    Lead lead_Obj = new Lead(LastName = 'LastName467', Company = 'Company325', Status = 'Open - Not Contacted', IsConverted = false, IsUnreadByOwner = false, avfree__Address_Do_Not_Verify__c = false, avfree__Address_Verified__c = false, Assign_Lead__c = false, Merge_Account__c = account_Obj.id, MappedID__c = 'Mappe794');
    Insert lead_Obj; 
    Opportunity opportunity_Obj = new Opportunity(AccountId = account_Obj.id, IsPrivate = false, Name = 'Name602', StageName = 'Prospecting', CloseDate = Date.today(), MappedID__c = 'Mappe294');
    Insert opportunity_Obj; 
    test.stopTest();
  }
  static testMethod void test_RelateOpportunity_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id,Name,avfree__Billing_Do_Not_Verify__c,avfree__Billing_Verified__c,avfree__Shipping_Do_Not_Verify__c,avfree__Shipping_Verified__c,bz_elink__Master_Account__c,bz_elink__Send_to_Lexis_Nexis_Automatically__c,Team_Login__c from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<Lead> lead_Obj  =  [SELECT Id,LastName,Company,Status,IsConverted,IsUnreadByOwner,avfree__Address_Do_Not_Verify__c,avfree__Address_Verified__c,Assign_Lead__c,Merge_Account__c,MappedID__c from Lead];
    System.assertEquals(true,lead_Obj.size()>0);
    List<Opportunity> opportunity_Obj  =  [SELECT Id,AccountId,IsPrivate,Name,StageName,CloseDate,MappedID__c from Opportunity];
    System.assertEquals(true,opportunity_Obj.size()>0);
    AutoCreateOppOnRelatedAccount obj01 = new AutoCreateOppOnRelatedAccount();
    AutoCreateOppOnRelatedAccount.RelateOpportunity(lead_Obj);
  }
}