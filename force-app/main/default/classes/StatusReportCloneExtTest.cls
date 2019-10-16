/**************************************************************************************************
 * Name: StatusReportCloneExtTest
 * Covered Class: StatusReportCloneExt
 * Covered Trigger: N / A
 * Author: Allen Zhang
 * Create Date: 2012-07-06
 * Modify History:
 *
***************************************************************************************************/
@isTest
private class StatusReportCloneExtTest {

    static testMethod void StatusReportCloneExtTest() {
        Release__c re = new Release__c(Name = 'Alpaca', Release_Date__c = system.today());
        insert re;

        Iteration__c it = new Iteration__c(Release__c = re.Id,
                                           Start_Date__c = system.today(),
                                           End_Date__c = system.today() + 10);
        insert it;

        Status_Report__c sr = new Status_Report__c(Iteration__c = it.Id,
                                                   Report_Date__c = system.today());
        insert sr;

        Report_Item__c ri1 = new Report_Item__c(Status_Report__c = sr.Id,
                                                Category__c = 'Development',
                                                Status__c = 'Open',
                                                Action__c = 'Action',
                                                Comments__c = 'Comments');

        Report_Item__c ri2 = new Report_Item__c(Status_Report__c = sr.Id,
                                                Category__c = 'Development',
                                                Status__c = 'Open',
                                                Action__c = 'Action',
                                                Comments__c = 'Comments');

        List<Report_Item__c> reportItems = new List<Report_Item__c>();
        reportItems.add(ri1);
        reportItems.add(ri2);
        insert reportItems;

        // Initalizes controller
        ApexPages.StandardController con = new ApexPages.StandardController(sr);
        StatusReportCloneExt ext = new StatusReportCloneExt (con);

        // Sets GenerateRequirement as current page
        PageReference pageRef = Page.StatusReportClone;
        Test.setCurrentPageReference(pageRef);

        ext.createStatusReport();

        // Ensures the report items has been genereate under the new status report
        system.assertEquals(2, [select count() from Report_Item__c where Status_Report__c =: sr.Id]);
    }
}