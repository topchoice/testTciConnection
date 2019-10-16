public class AssignmentGroupWithdrawalTriggerHandler {

  private boolean triggerIsExecuting = false;
  private integer batchSize = 0;
  public static boolean firstRun = true;
  
  public AssignmentGroupWithdrawalTriggerHandler( boolean isExecuting, integer size ) {
    triggerIsExecuting = isExecuting;
    batchSize = size;
  }
  
  public void onBeforeInsert( list<Assignment_Group_Withdrawal__c> newWithdrawals ) {
    AssignmentGroupWithdrawalHelper.checkForExistingWithdrawals( null, newWithdrawals, null );
  }
  
  public void onBeforeUpdate( list<Assignment_Group_Withdrawal__c> oldWithdrawals
                            , list<Assignment_Group_Withdrawal__c> updatedWithdrawals
                            , map<Id, Assignment_Group_Withdrawal__c> updatedWithdrawalsMap ) {  
    if( firstRun ) {
      AssignmentGroupWithdrawalHelper.checkForExistingWithdrawals( oldWithdrawals, updatedWithdrawals, updatedWithdrawalsMap );
    }
  }

  public void onAfterInsert( list<Assignment_Group_Withdrawal__c> newWithdrawals ) {
    // START : Changed for T-289269 : Basant Verma : 27th June, 2014
    if( firstRun ) {
        AssignmentGroupWithdrawalHelper.autoSubmitForApproval( newWithdrawals );
    }
    // END : Changed for T-289269 : Basant Verma : 27th June, 2014
    firstRun = false;
  }
/*
  public void onAfterUpdate( list<Assignment_Group_Withdrawal__c> oldWithdrawals
                            , list<Assignment_Group_Withdrawal__c> updatedWithdrawals
                            , map<Id, Assignment_Group_Withdrawal__c> updatedWithdrawalsMap ) {
    firstRun = false;  
  }
 */ 
}