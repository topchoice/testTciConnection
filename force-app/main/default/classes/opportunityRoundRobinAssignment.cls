public class opportunityRoundRobinAssignment{
    public static Boolean runOnce = false;
    public static Boolean runMerge = false;
    
    @InvocableMethod
    public static void assignOpportunitiesRoundRobin(List<Id> oppIdsSet){
    
        /* get list of all the opportunities*/
        List<Opportunity> groupOppsList = [Select Id, OwnerId FROM Opportunity Where Id IN:oppIdsSet];
        Integer index;
        Integer assignmentNumber;
        Integer agentSize;
        List<Assignment_Groups__c> assignmentGroupList = new List<Assignment_Groups__c>();
        List<User> agentList = new List<User>();
        List<Assignment_Group_Name__c> assignmentGroupName = new List<Assignment_Group_Name__c>();
        Set<Id> queueIdsSet = new Set<Id>();
        System.debug('#### groupOppsList = '+groupOppsList);
        
        // Fetch Ids of the group.
        For(opportunity opp : groupOppsList){
            If(String.valueOf(opp.ownerId).startsWith('006')){
                queueIdsSet.add(opp.ownerId);
            }
        }

        // Search Ids of the users in Assignment Group
        for ( Assignment_Groups__c assignmentGroupUsers : [SELECT Id, Name, Group_Name__c, User__c, Active__c FROM Assignment_Groups__c WHERE Active__c = 'True']){
        }

        // search for the users from Group Memeberships that are active
        assignmentGroupList = [SELECT Id, Name, Group_Name__c, Active__c, User__c FROM Assignment_Groups__c WHERE Active__c = 'True'];
        
        // Assignment Group 1
        for ( Opportunity opp : groupOppsList){
            if(opp.StageName == 'Prospecting'){
                agentSize = agentList.size();
                index = Math.MOD(assignmentNumber ,agentSize) +1;
                opp.OwnerId = assignmentGroupList[index].id;
            }
        }
        
        
        If(groupOppsList!=null && groupOppsList.size()>0){
            System.debug('#### Updating tickets = '+groupOppsList);
            
            update groupOppsList;
        }
    }
}