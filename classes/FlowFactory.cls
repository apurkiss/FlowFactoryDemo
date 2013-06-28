public with sharing class FlowFactory 
{
	// State Parent
	public virtual class FlowState
	{
		public List<Step> steps {get; set;}
		public FlowState()
		{
			this.steps = new List<Step>();
		}
	}

	// Flow Parent
	public virtual class FlowParent
	{
		protected void processSteps(Step step, FlowState state)
		{
			Boolean keepGoing = true;
			while(keepGoing)
			{
				step = step.processStep(state);
				if(step == null) 
					keepGoing = false;
			}
		}
		
		// Main entry for each type of flow. Only processWork(Integer p) is used in this demo.
		public virtual FlowState processWork(){return null;}
		public virtual FlowState processWork(Integer p){return null;}
		public virtual FlowState processWork(Integer p, Contact c){return null;}
	}
	
	// Step Parent
	public virtual class Step
	{
		protected Step nextStep {get; set;}
		public String stepName {get; set;}

		// Create next step 
		protected Step createInstance(String className)
		{
	        Type t = Type.forName(className);
	        this.nextStep = (Step) t.newInstance();
	        this.nextStep.stepName = className;
	        return this.nextStep;
		}
		
		// Create next step from SObject
		protected Step createDynamicInstance(String className, Integer branchNumber)
		{
			Step retVal;
			List<String> classNames = className.split('\\.');
			String branchName = 'branch_' + branchNumber;
			
			List<Flow_Step_Branch__c> fsb = [
				SELECT Next_Step__r.Name 
				FROM Flow_Step_Branch__c 
				WHERE Flow_Step__r.Flow__r.Name = :classNames[0] 
				AND Flow_Step__r.Name = :classNames[1] 
				AND Name = :branchName 
				LIMIT 1];
			
			if(fsb.size() == 1 && fsb[0].Next_Step__r.Name != null)
			{
				retVal = createInstance(classNames[0] + '.' + fsb[0].Next_Step__r.Name);
			}
			
			return retVal;
		}

		// Step children override with unique processing
		public virtual Step processStep(FlowState fs){return null;}
	}
}