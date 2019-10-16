trigger OpportunityOwnerAssignment on Opportunity(Before Insert) {
RRobin.SObjectOwnerAssignment.assignOwner(Trigger.New);}