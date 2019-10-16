/**************************************************************************************************
 * Name: TestSetExt
 * Object: Test Set (Test_Set__c)
 * Purpose: Query the test case under the same iteration, add to current test set.
 * Author: Allen Zhang
 * Create Date: 2012-05-21
 * Modify History: 
 * Allen   2012-05-21    Changed the Class and page name according to the new naming convension.
 * Allen   2012-07-09    Change the button from test plan to test set
 * Allen   2012-07-10    Add "Clone with All Tests" and "Clone with Failed Tests" buttons
 * Allen   2012-07-12    Adds field level permission check before DML
***************************************************************************************************/
public with sharing class TestSetExt {

    public Test_Set__c testSet { get; set; }
    public List<Test__c> tests { get; set; }
    public List<cTestCase> cTestCases { get; set; }

    // Contructor method for the extension
    public TestSetExt(ApexPages.StandardController controller) {
        testSet = [select Id, Test_Plan__c, Test_Plan__r.Iteration__c, Name, Test_By__c,
                       (select Id, Name, Test_Case__c, Summary__c, Selected__c, Test_Steps__c, Result__c
                        from Test__r)
                   from Test_Set__c
                   where Id=: controller.getId()];
		tests = testSet.Test__r;
    }

    // Query all the test case under this iteration
    public List<cTestCase> getTestCases() {
        cTestCases = new List<cTestCase> ();

        // Gets the test case under this iteration and wrapper "select" button
        for (Test_Case__c tc : [select Id, Name, Summary__c
                                from Test_Case__c
                                where Requirement__r.Iteration__c = :testSet.Test_Plan__r.Iteration__c]) {

            // Puts queried test case in the wrapper test case list
            cTestCases.add(new cTestCase(tc));
        }

        // Returns the warpperred test case to the visualforce page
        return cTestCases;
    }

    // Inserts selected test case as test under this test plan
    public PageReference generateTests () {

		// Checks if the user has create access on the each fields
		String[] testCreatFields = new String[]{'Test_Case__c', 'Test_Set__c'};

		// Obtains the field name/token map for the object
		Map<String, Schema.Sobjectfield> testFieldMap = Schema.Sobjecttype.Test__c.fields.getMap();

		for (String fieldToCheck : testCreatFields) {
			if(!testFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access' +
									 testFieldMap.get(fieldToCheck).getDescribe().getLabel()));
				return null;
			}
		}

        List<Test__c> newTests = new List<Test__c>();

        for (cTestCase ctc : cTestCases) {

            // For the test cases selected, put them in test list
            if (ctc.selected) {
                newTests.add(new Test__c(Test_Case__c = ctc.tc.Id, Test_Set__c = testSet.Id));
            }
        }

        // if have test case selected
        if (newTests.size() > 0) {
            insert newTests;
        } else {
			ApexPages.Message noSelectMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Tests');
            return null;
        }

        // Returns test plan detail page
        PageReference  pageRef = new PageReference('/' + testSet.Id);
        return pageRef;
    }

    // Clone currently test set with all the tests
    public PageReference cloneTests () {

		// Checks if the user has create access on the each fields
		String[] testSetCreatFields = new String[]{'Test_Plan__c', 'Test_By__c'};

		// Obtains the field name/token map for the object
		Map<String, Schema.Sobjectfield> testSetFieldMap = Schema.Sobjecttype.Test_Set__c.fields.getMap();

		for (String fieldToCheck : testSetCreatFields) {
			if(!testSetFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access' +
									 testSetFieldMap.get(fieldToCheck).getDescribe().getLabel()));
				return null;
			}
		}

		// Checks if the user has create access on the each fields
		String[] testCreatFields = new String[]{'Selected__c', 'Result__c', 'Test_Set__c'};

		// Obtains the field name/token map for the object
		Map<String, Schema.Sobjectfield> testFieldMap = Schema.Sobjecttype.Test__c.fields.getMap();

		for (String fieldToCheck : testCreatFields) {
			if(!testFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access' +
									 testFieldMap.get(fieldToCheck).getDescribe().getLabel()));
				return null;
			}
		}

        List<Test__c> newTests = new List<Test__c>();

        Test_Set__c newTestSet = new Test_Set__c (Test_Plan__c = testSet.Test_Plan__c, Test_By__c = testSet.Test_By__c);

        insert newTestSet;

        for (Test__c ct : tests) {

            // For the test selected puts them in test list
            if (ct.Selected__c) {
                ct.Test_Set__c = newTestSet.Id;
                ct.Result__c = '';
                ct.Selected__c = false;
                newTests.add(ct.clone());
            }
        }

        // if have test selected
        if (newTests.size() > 0) {
            insert newTests;

			// Returns new test set detail page
            PageReference pageRef = new PageReference('/' + newTestSet.Id);
            return pageRef;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Tests'));
            return null;
        }
    }

    // Wrapper class for the test case to add "selected" vairable.
    public class cTestCase {

        public Boolean selected { get; set; }
        public Test_Case__c tc { get; set; }

        // Contructor
        public cTestCase (Test_Case__c testCase) {
            tc = testCase;
            selected = false;
        }
    }
}