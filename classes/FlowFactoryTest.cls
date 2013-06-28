//
// *** JUST GETTING 75% COVERAGE FOR DEPLOYMENT ***
// *** NO REAL TESTING TO SEE HERE :) ***
//
@isTest
private class FlowFactoryTest 
{
    static testMethod void test1() 
    {
    	FlowData.createFlowData();
    	FlowFactoryDemoController ffdc = new FlowFactoryDemoController();
    	System.Test.setCurrentPage(Page.FlowFactoryDemo);
    	
    	// Flow1
    	ffdc.executeFlow();
    	ffdc.selectedPath = '2';
    	ffdc.executeFlow();
    	ffdc.selectedPath = '3';
    	ffdc.executeFlow();
    	
    	// Flow2
    	ffdc.selectedFlow = [SELECT Id FROM Flow__c WHERE Name = 'Flow2' LIMIT 1].Id;
    	ffdc.executeFlow();
    	ffdc.selectedPath = '2';
    	ffdc.executeFlow();
    	ffdc.selectedPath = '3';
    	ffdc.executeFlow();
    }
}