@isTest
private class Consultants_AccountTriggerHelper_Test {
	@testSetup
  static void setupTestData(){
    
    test.startTest();
    Account acct = new Account(Name = 'Name206', avfree__Billing_Do_Not_Verify__c = false, avfree__Billing_Verified__c = false, avfree__Shipping_Do_Not_Verify__c = false, avfree__Shipping_Verified__c = false, bz_elink__Master_Account__c = false, bz_elink__Send_to_Lexis_Nexis_Automatically__c = false, Active__c = 'Yes', Team_Login__c = false, TestUpdate__c = 'TestU620');
    Insert acct; 

    Consultant__c theConsultant = new Consultant__c(First_Name__c = 'First197', Work__c = '8006131111', Cell__c = '4802221111', TCI_Email__c = 'Email25@test.com', Last_Name__c = 'Last_749');
    Insert theConsultant; 
    test.stopTest();

  }

  static testMethod void test_linkTheConsultantAndAccount_UseCase1(){
    List<Account> acct  =  [SELECT Id,Name,avfree__Billing_Do_Not_Verify__c,avfree__Billing_Verified__c,avfree__Shipping_Do_Not_Verify__c,avfree__Shipping_Verified__c,bz_elink__Master_Account__c,bz_elink__Send_to_Lexis_Nexis_Automatically__c, Active__c,Team_Login__c,TestUpdate__c,vLookUp_Code__c from Account];
    System.assertEquals(true,acct.size()>0);
    List<Consultant__c> theConsultant  =  [SELECT Id,Name,First_Name__c,Work__c,Cell__c,TCI_Email__c,Last_Name__c from Consultant__c];
    System.assertEquals(true,theConsultant.size()>0);
    Consultants_AccountTriggerHelper cat = new Consultants_AccountTriggerHelper();
    Consultants_AccountTriggerHelper.linkTheConsultantAndAccount(theConsultant);
  }
}