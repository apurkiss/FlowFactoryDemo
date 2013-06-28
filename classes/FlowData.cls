public with sharing class FlowData 
{
    public static void createFlowData()
    {
    	List<Flow__c> flows = new List<Flow__c>();
    	flows.add(new Flow__c(Name = 'Flow1'));
    	flows.add(new Flow__c(Name = 'Flow2'));
    	insert flows;
    	
    	List<Flow_Step__c> flowSteps = new List<Flow_Step__c>();
    	// Flow1
    	flowSteps.add(new Flow_Step__c(Name = 'FirstStep', Flow__c = flows[0].Id));			// flowSteps[0]
    	flowSteps.add(new Flow_Step__c(Name = 'ProcessApples', Flow__c = flows[0].Id));		// flowSteps[1]
    	flowSteps.add(new Flow_Step__c(Name = 'ProcessOranges', Flow__c = flows[0].Id));	// flowSteps[2]
    	flowSteps.add(new Flow_Step__c(Name = 'AnotherStep', Flow__c = flows[0].Id));		// flowSteps[3]
    	flowSteps.add(new Flow_Step__c(Name = 'FinalStep', Flow__c = flows[0].Id));			// flowSteps[4]
    	// Flow2
    	flowSteps.add(new Flow_Step__c(Name = 'FirstStep', Flow__c = flows[1].Id));			// flowSteps[5]
    	flowSteps.add(new Flow_Step__c(Name = 'Step2', Flow__c = flows[1].Id));				// flowSteps[6]
    	flowSteps.add(new Flow_Step__c(Name = 'Step3', Flow__c = flows[1].Id));				// flowSteps[7]
    	flowSteps.add(new Flow_Step__c(Name = 'Step4', Flow__c = flows[1].Id));				// flowSteps[8]
    	flowSteps.add(new Flow_Step__c(Name = 'Step5', Flow__c = flows[1].Id));				// flowSteps[9]
    	flowSteps.add(new Flow_Step__c(Name = 'FinalStep', Flow__c = flows[1].Id));			// flowSteps[10]
    	insert flowSteps;
    	
    	List<Flow_Step_Branch__c> flowStepBranches = new List<Flow_Step_Branch__c>();
		// Flow1
    	// Flow1.FirstStep
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[0].Id, Next_Step__c = flowSteps[1].Id));
    	// Flow1.ProcessApples
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[1].Id, Next_Step__c = flowSteps[2].Id));
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_2', Flow_Step__c = flowSteps[1].Id, Next_Step__c = flowSteps[3].Id));
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_3', Flow_Step__c = flowSteps[1].Id, Next_Step__c = flowSteps[4].Id));
    	// Flow1.ProcessOranges
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[2].Id, Next_Step__c = flowSteps[3].Id));
    	// Flow1.AnotherStep
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[3].Id, Next_Step__c = flowSteps[4].Id));
		// Flow2
		// Flow2.FirstStep
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[5].Id, Next_Step__c = flowSteps[6].Id));
		// Flow2.Step2
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[6].Id, Next_Step__c = flowSteps[8].Id));
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_2', Flow_Step__c = flowSteps[6].Id, Next_Step__c = flowSteps[7].Id));
		// Flow2.Step3
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[7].Id, Next_Step__c = flowSteps[8].Id));
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_2', Flow_Step__c = flowSteps[7].Id, Next_Step__c = flowSteps[9].Id));
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_3', Flow_Step__c = flowSteps[7].Id, Next_Step__c = flowSteps[10].Id));
		// Flow2.Step4
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[8].Id, Next_Step__c = flowSteps[9].Id));
		// Flow2.Step5
    	flowStepBranches.add(new Flow_Step_Branch__c(Name = 'branch_1', Flow_Step__c = flowSteps[9].Id, Next_Step__c = flowSteps[10].Id));
    	insert flowStepBranches;
    }
}