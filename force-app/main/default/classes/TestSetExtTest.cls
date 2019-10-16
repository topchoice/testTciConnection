/**************************************************************************************************
 * Name: TestSetExtTest
 * Covered Class: TestSetExt
 * Covered Trigger: N / A
 * Author: Allen Zhang
 * Create Date: 2012-07-09
 * Modify History: 
 * 
***************************************************************************************************/
@isTest
private class TestSetExtTest {

    static Test_Set__c ts;

    static {
        Release__c re = new Release__c(Name = 'Olive', Release_Date__c = system.today());
        insert re;

        Iteration__c it = new Iteration__c(Release__c = re.Id,
                                           Start_Date__c = system.today(),
                                           End_Date__c = system.today() + 10);
        insert it;

        Requirement__c req = new Requirement__c(Subject__c = 'Subject',
                                                Description__c = 'Description',
                                                Iteration__c = it.Id);

        insert req;

        Test_Plan__c tp = new Test_Plan__c(Iteration__c = it.Id,
                                           Name = 'Test Plan',
                                           Start_Date__c = system.today(),
                                           End_Date__c=  system.today() + 14);
        insert tp;

        Test_Case__c tc1 = new Test_Case__c(Case_Type__c = 'Positive',
                                            Requirement__c = req.Id,
                                            Summary__c = 'Summary 1', 
                                            Test_Steps__c = 'Test Steps 1', 
                                            Expected_Result__c = 'Expected Result 1');
        Test_Case__c tc2 = new Test_Case__c(Case_Type__c = 'Positive',
                                            Requirement__c = req.Id,
                                            Summary__c = 'Summary 2', 
                                            Test_Steps__c = 'Test Steps 2', 
                                            Expected_Result__c = 'Expected Result 2');
        Test_Case__c tc3 = new Test_Case__c(Case_Type__c = 'Positive',
                                            Requirement__c = req.Id,
                                            Summary__c = 'Summary 3', 
                                            Test_Steps__c = 'Test Steps 3', 
                                            Expected_Result__c = 'Expected Result 3');

        List<Test_Case__c> testCases = new List<Test_Case__c>();
        testCases.add(tc1);
        testCases.add(tc2);
        testCases.add(tc3);
        insert testCases;

        ts = new Test_Set__c(Test_Plan__c = tp.Id);
        insert ts;

        Test__c te1 = new Test__c (Test_Set__c = ts.Id, Test_Case__c = tc1.Id, Selected__c = true);
        Test__c te2 = new Test__c (Test_Set__c = ts.Id, Test_Case__c = tc2.Id, Selected__c = true);
        Test__c te3 = new Test__c (Test_Set__c = ts.Id, Test_Case__c = tc3.Id, Selected__c = true);

        List<Test__c> tests = new List<Test__c>();
        tests.add(te1);
        tests.add(te2);
        tests.add(te3);

        insert tests;
    }

    static testMethod void selectTestCases() {

        // Initilizes currently standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(ts);
        TestSetExt ext = new TestSetExt(con);

        // Initilizes SelectTestCases page
        PageReference pageRef = Page.TestCasesSelect;

        // Sets SelectTestCases page as current page
        Test.setCurrentPage(pageRef);
        List<TestSetExt.cTestCase> cTc = ext.getTestCases();

        // Loops the wrapperred test case and set the selected true, this make sure the processSelected aciton
        // could process the code
        for(TestSetExt.cTestCase c : cTc) {
            c.selected = true;
        }

        // Generates the test according to the selected test cases, then inserts the test.
        ext.generateTests();
    }

    static testMethod void noSelectTestCases() {

        // Initilizes currently standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(ts);
        TestSetExt ext = new TestSetExt(con);

        // Initilizes SelectTestCases page
        PageReference pageRef = Page.TestCasesSelect;

        // Sets SelectTestCases page as current page
        Test.setCurrentPage(pageRef);
        List<TestSetExt.cTestCase> cTc = ext.getTestCases();

        // Generates the test according to the selected test cases, then inserts the test.
        ext.generateTests();
    }

    static testMethod void cloneTests() {

        // Initilizes currently standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(ts);
        TestSetExt ext = new TestSetExt(con);

        PageReference pageRef = Page.TestSetCloneAllCases;

        // Sets SelectTestCases page as current page
        Test.setCurrentPageReference(pageRef);

        // Initilizes SelectTestCases page
        ext.cloneTests();
    }

    static testMethod void noSelectcloneTests() {

        // Initilizes currently standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(ts);
        TestSetExt ext = new TestSetExt(con);
        PageReference pageRef = Page.TestSetCloneAllCases;

        // Sets SelectTestCases page as current page
        Test.setCurrentPageReference(pageRef);

        // Loops the wrapperred test case and set the selected true, this make sure the processSelected aciton
        // could process the code
        for(Test__c c : ext.tests) {
            c.Selected__c = false;
        }

        // Initilizes SelectTestCases page
        ext.cloneTests();
        // Ensures the report items has been genereate under the new status report
        system.assertEquals(3, [select count() from Test__c where Test_Set__c = :ts.Id]);
    }
}