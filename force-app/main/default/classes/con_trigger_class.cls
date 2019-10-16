public class con_trigger_class{
    public static void con_location_check(List<Contact> cons){
    
        List<Location__c> loc=new List<Location__c>();
        for(Contact c1 : [select Id, avfree__Mailing_Address_Status__c from Contact where
                                                createdbyID = :UserInfo.getUserID()
                                                AND createdDate = TODAY]){
           
            }   
          
        for(Contact c2 : cons)  {
            if(c2.MailingStreet != Null && c2.MailingCity != Null && c2.MailingState != Null && c2.MailingPostalCode != Null
                                                                                && c2.avfree__Mailing_Verified__c == true)
                                                                                
            {
            
            Location__c l = new Location__c();
            l.Insured__c = c2.Id;
            l.Address__c = c2.MailingStreet;
            l.City__c = c2.MailingCity;
            l.State__c = c2.MailingState;
            l.Zip__c = c2.MailingPostalCode;
            l.Performing_a_Home_Quote__c = 'No';
            
            loc.add(l);
        
        }
        
            insert loc;
         
    }

}
}