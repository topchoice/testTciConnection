@IsTest
public class TestCreateNewConsultant {

    static testmethod void insertConsultant() {
    
        Consultant__c nc = new Consultant__c();
        
        nc.First_Name__c = 'Jane';
        nc.Last_Name__c = 'Doe';
        nc.Name = 'Jane Doe';
        
        nc.Active__c = True;
        
        nc.cell__c = '6025557777';
        nc.work__c = '8004447777';
        nc.TCI_Email__c = 'testing@tciagency.com';
        nc.Hire_Date__c = system.Today();
        
        // Enter Company Assignment Details
        nc.Apps_Username__c = 'testing';
        nc.Phone_Assigend__c = 'No';
        nc.Router_Assigned__c = 'No';
        nc.Discount_Applied__c = 'No';
        nc.Phone_Type__c = 'iPhone 7';
        nc.Phone_Color__c = 'Black';
        
        insert nc;
    }
}