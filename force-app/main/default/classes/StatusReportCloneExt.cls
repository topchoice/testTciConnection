/**************************************************************************************************
 * Name: StatusReportCloneExt
 * Object: Status Report (Status_Report__c)
 * Purpose: Copy the open report item under the status report when cloning the report, then generate
 *			the new status report.
 * Author: Allen Zhang
 * Create Date: 2012-07-06
 * Modify History: 
 * Allen   2012-07-12    Adds field level permission check before DML
***************************************************************************************************/
public with sharing class StatusReportCloneExt {

    public Status_Report__c statusReport { get; set; }

    public StatusReportCloneExt(ApexPages.StandardController controller) {
        statusReport = [select Id, Name, Iteration__c,
                        	(select Id, Status__c, Status_Report__c
                             from Report_Items__r)
                        from Status_Report__c 
                        where Id=: controller.getId()];
    }

    public PageReference createStatusReport () {

		// Checks if the user has create access on the each fields
		String[] statusReportCreatFields = new String[]{'Report_Date__c', 'Iteration__c'};

		// Obtains the field name/token map for the object
		Map<String, Schema.Sobjectfield> statusReportFieldMap = Schema.Sobjecttype.Status_Report__c.fields.getMap();

		for (String fieldToCheck : statusReportCreatFields) {
			if(!statusReportFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access' +
									 statusReportFieldMap.get(fieldToCheck).getDescribe().getLabel()));
				return null;
			}
		}

		// Checks if the user has create access on the each fields
		String[] reportItemCreatFields = new String[]{'Status__c', 'Status_Report__c'};

		// Obtains the field name/token map for the object
		Map<String, Schema.Sobjectfield> reportItemFieldMap = Schema.Sobjecttype.Report_Item__c.fields.getMap();

		for (String fieldToCheck : reportItemCreatFields) {
			if(!reportItemFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access' +
									 reportItemFieldMap.get(fieldToCheck).getDescribe().getLabel()));
				return null;
			}
		}

		Status_Report__c sr = new Status_Report__c(Iteration__c = statusReport.Iteration__c,
		                                           Report_Date__c = system.today());

		insert sr;

		List<Report_Item__c> reportItems = new List<Report_Item__c> ();

		for (Report_Item__c ri : statusReport.Report_Items__r) {

			// Since all the report items in the list, need loop in the filter only the open report items.
			if (ri.Status__c == 'Open') {
				ri.Status_Report__c = sr.Id;
				reportItems.add(ri.clone());
			}
		}

		insert reportItems;

        // Return status report detail page
        PageReference pageRef = new PageReference('/' + sr.Id);

        return pageRef.setRedirect(true);
    }
}