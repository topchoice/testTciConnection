@isTest
private class CaseUpdateBatch_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Account account_Obj = new Account(Name = 'Name643', Active__c = 'No', avfree__Billing_Do_Not_Verify__c = false, avfree__Billing_Verified__c = false, avfree__Shipping_Do_Not_Verify__c = false, avfree__Shipping_Verified__c = false, bz_elink__Master_Account__c = false, bz_elink__Send_to_Lexis_Nexis_Automatically__c = false, Team_Login__c = false, TestUpdate__c = 'TestU856');
    Insert account_Obj; 
    Case case_Obj = new Case(IsEscalated = false, Policy_Number__c = 'Polic363', TestUpdate__c = 'TestU287');
    Insert case_Obj; 
    test.stopTest();
  }
    static testMethod void testBatch(){
    CaseUpdateBatch obj01 = new CaseUpdateBatch();
    Database.executeBatch(obj01, 200);
}
}