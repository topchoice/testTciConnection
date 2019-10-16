trigger AssignmentGroupWithdrawalTrigger on Assignment_Group_Withdrawal__c ( before insert, before update, before delete
                                                                            , after insert, after update, after delete, after undelete ) {
  if(Test.isRunningTest() ){
    AssignmentGroupWithdrawalTriggerHandler handler = new AssignmentGroupWithdrawalTriggerHandler( trigger.isExecuting, trigger.size );
    
    if( trigger.isInsert && trigger.isBefore ) {
      handler.onBeforeInsert( trigger.new );
      
    } else if( trigger.isUpdate && trigger.isBefore ) {
      handler.OnBeforeUpdate( trigger.old, trigger.new, trigger.newMap );
    
    } else if( trigger.isInsert && trigger.isAfter ) {
      handler.OnAfterInsert( trigger.new );
    
    }
  }
}