global class CustomSettingSync implements Database.Batchable<sObject>,Database.Stateful{
     global Database.QueryLocator start(Database.BatchableContext BC){
         String qry;
         return Database.getQueryLocator(qry);
     }
     global void execute(Database.BatchableContext BC, List<sObject> accList){
         
     }
     global void finish(Database.BatchableContext BC){
     }
}