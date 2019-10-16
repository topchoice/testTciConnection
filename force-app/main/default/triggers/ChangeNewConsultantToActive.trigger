trigger ChangeNewConsultantToActive on Consultant__c (before insert) {

    for (Consultant__c NewCons : Trigger.new) {
        NewCons.Active__c = True;
    }

}