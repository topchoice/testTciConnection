public with sharing class AssignmentGroupWithdrawalHelper {
	public static void checkForExistingWithdrawals( list<Assignment_Group_Withdrawal__c> oldWithdrawals
                                                                    , list<Assignment_Group_Withdrawal__c> updatedWithdrawals
                                                              , map<Id, Assignment_Group_Withdrawal__c> updatedWithdrawalsMap ) {  

    set<Id> agSet = new set<Id>();
    map<String,list<Assignment_Group_Withdrawal__c>> mapMemberUserKey_listOfWithdrawals = new map<String,list<Assignment_Group_Withdrawal__c>>();
    for( Assignment_Group_Withdrawal__c agw : updatedWithdrawals ) {
      agSet.add( agw.Group_Membership_Record__c );
      list<Assignment_Group_Withdrawal__c> agwList = new list<Assignment_Group_Withdrawal__c>();
      String key =  String.valueOf( agw.Group_Membership_Record__c ).left( 15 ) + agw.UserId__c;
      if( mapMemberUserKey_listOfWithdrawals.containsKey( key ) ) {
        agwList = mapMemberUserKey_listOfWithdrawals.get( key );
      } 
      agwList.add( agw );
      mapMemberUserKey_listOfWithdrawals.put( key, agwList );
    }

    for( Assignment_Groups__c member : [ SELECT Id, User__r.Id
                                          , ( SELECT Id, From__c, To__c 
                                              FROM Queue_Withdrawals__r ) 
                                                                             FROM Assignment_Groups__c WHERE Id IN :agSet ] ) {
        
        // Find if there's a Member match in this batch of AGWs
        String key =  String.valueOf( member.Id ).left( 15 ) + String.valueOf( member.User__r.Id ).left( 15 );
        if( mapMemberUserKey_listOfWithdrawals.containsKey( key ) ) {
            // Found. Compare the Member's AGWs with those in the incoming batch
            for( Assignment_Group_Withdrawal__c newAgw : mapMemberUserKey_listOfWithdrawals.get( key ) ) {
          for( Assignment_Group_Withdrawal__c agw : member.Queue_Withdrawals__r ) {
                    if( newAgw.Id != agw.Id && ( 
                 ( newAgw.From__c <= agw.To__c.addHours(1) && newAgw.To__c.addHours(1) >= agw.From__c )
                    || ( newAgw.From__c.addHours(-1) >= agw.From__c && newAgw.To__c.addHours(1) <= agw.To__c  )
                    || ( newAgw.From__c <= agw.From__c && newAgw.To__c >= agw.To__c ) 
              ) ) { 
                      newAgw.addError( 'The range between "From" and "To" cannot overlap with, or be within an hour of,' 
                                                    + ' an existing Assignment Group Withdrawal record. '
                                                    + ' Please refer to the list of existing records and modify the date & time values accordingly.' );
                    }
                }
            }
        }

    }

  }

  public static void autoSubmitForApproval( list<Assignment_Group_Withdrawal__c> newWithdrawals ) {
    // START : Changed for T-289269 : Basant Verma : 27th June, 2014
    List<Assignment_Group_Withdrawal__c> recordsToUpdate = new List<Assignment_Group_Withdrawal__c>();
    for( Assignment_Group_Withdrawal__c withdrawal : [Select Id, Name, Approval_Status__c, Group_Membership_Record__c, 
        Group_Membership_Record__r.User__c, Group_Membership_Record__r.User__r.ManagerId 
        From Assignment_Group_Withdrawal__c Where Id IN :newWithdrawals] ) {
              Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
              req.setComments( 'Submitted for approval.' );
              req.setObjectId( withdrawal.Id );
              // submit the approval request for processing
              Approval.ProcessResult result = Approval.process( req ) ;
              // display if the reqeust was successful
              System.debug( 'Submitted for approval successfully: ' + result.isSuccess() );
    }     
  }
}