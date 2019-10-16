@isTest
private class AutoConvertLeads_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Account account_Obj = new Account(
    	Name = 'Name715', 
    	avfree__Billing_Do_Not_Verify__c = false, 
    	avfree__Billing_Verified__c = false, 
    	avfree__Shipping_Do_Not_Verify__c = false, 
    	avfree__Shipping_Verified__c = false, 
    	bz_elink__Master_Account__c = false, 
    	bz_elink__Send_to_Lexis_Nexis_Automatically__c = false, 
    	Team_Login__c = false);
    Insert account_Obj; 
    
    Contact contact_Obj = new Contact(
    	LastName = 'LastName481', 
    	avfree__Mailing_Do_Not_Verify__c = false, 
    	avfree__Mailing_Verified__c = false, 
    	avfree__Other_Do_Not_Verify__c = false, 
    	avfree__Other_Verified__c = false, 
    	TCI_Ineligible__c = false, 
    	Courtesy_Call_Complete__c = false, 
    	Courtesy_Email_Sent__c = false);
    Insert contact_Obj; 
    
    Lead lead_Obj = new Lead(
    	LastName = 'LastName874', 
    	Company = 'Company945', 
    	Status = 'Open - Not Contacted', 
    	IsConverted = false, 
    	IsUnreadByOwner = false, 
    	avfree__Address_Do_Not_Verify__c = false, 
    	avfree__Address_Verified__c = false, 
    	Assign_Lead__c = false);
    Insert lead_Obj; 
    
    Opportunity opportunity_Obj = new Opportunity(
    	IsPrivate = false, 
    	Name = 'Name701', 
    	StageName = 'Prospecting', 
    	CloseDate = Date.today());
    Insert opportunity_Obj; 
    test.stopTest();
  }

  static testMethod void test_LeadAssign_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id,Name,avfree__Billing_Do_Not_Verify__c,
    					avfree__Billing_Verified__c,avfree__Shipping_Do_Not_Verify__c,
    					avfree__Shipping_Verified__c,bz_elink__Master_Account__c,
    					bz_elink__Send_to_Lexis_Nexis_Automatically__c,Team_Login__c 
    					from Account];
    System.assertEquals(true,account_Obj.size()>0);
    
    List<Contact> contact_Obj  =  [SELECT Id,LastName,avfree__Mailing_Do_Not_Verify__c,avfree__Mailing_Verified__c,avfree__Other_Do_Not_Verify__c,avfree__Other_Verified__c,TCI_Ineligible__c,Courtesy_Call_Complete__c,Courtesy_Email_Sent__c from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    
    List<Lead> lead_Obj  =  [SELECT Id,LastName,Company,Status,IsConverted,IsUnreadByOwner,avfree__Address_Do_Not_Verify__c,avfree__Address_Verified__c,Assign_Lead__c from Lead];
    System.assertEquals(true,lead_Obj.size()>0);
    
    List<Opportunity> opportunity_Obj  =  [SELECT Id,IsPrivate,Name,StageName,CloseDate from Opportunity];
    System.assertEquals(true,opportunity_Obj.size()>0);
    
    AutoConvertLeads obj01 = new AutoConvertLeads();
    AutoConvertLeads.LeadAssign(new List<Id>());
  }

}