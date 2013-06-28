public with sharing class Flow1 extends FlowFactory.FlowParent
{
	// Main Entry
	public override FlowFactory.FlowState processWork()
	{
		return processWork(1); // Default path
	}
	public override FlowFactory.FlowState processWork(Integer p)
	{
		Flow1State state = new Flow1State(p);
		FlowFactory.Step step = new FirstStep();
		step.stepName = FirstStep.class.toString();
		processSteps(step, state);

		return state;
	}

	// State
	public class Flow1State extends FlowFactory.FlowState
	{
		public Integer path {get; private set;}
		public Flow1State(Integer p)
		{
			// Pass in additional initial state vars to retain throughout the flow (SObjects to process, etc.)
			
			// Just for demo purposes to simulate dynamic branching at runtime
			this.path = p; 
		}
	}
	
	//-----------
	// Flow Steps
	//-----------
	
	public class FirstStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow1State state = (Flow1State) fs;
			state.steps.add(this);		
			this.nextStep = createDynamicInstance(FirstStep.class.toString(), 1); // 1 branch
			
			/*
			// This may also look like the following:
			if(condition())
				this.nextStep = createDynamicInstance(FirstStep.class.toString(), 1);
			else if(someOtherCondition())
				this.nextStep = createDynamicInstance(FirstStep.class.toString(), 2);
			else
				this.nextStep = createDynamicInstance(FirstStep.class.toString(), 3);
			*/
			
			return this.nextStep;
		}
	}
	
	public class ProcessApples extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow1State state = (Flow1State) fs;
			state.steps.add(this);
			processThoseApples();
			this.nextStep = createDynamicInstance(ProcessApples.class.toString(), state.path); // 3 branches
			return this.nextStep;
		}
		private void processThoseApples(){} // Step-specific logic
	}

	public class ProcessOranges extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow1State state = (Flow1State) fs;
			state.steps.add(this);
			processThoseOranges();
			this.nextStep = createDynamicInstance(ProcessOranges.class.toString(), 1); // 1 branch
			return this.nextStep;
		}
		private void processThoseOranges(){} // Step-specific logic
	}

	public class AnotherStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow1State state = (Flow1State) fs;
			state.steps.add(this);
			this.nextStep = createDynamicInstance(AnotherStep.class.toString(), 1); // 1 branch
			return this.nextStep;
		}
	}

	public class FinalStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow1State state = (Flow1State) fs;
			state.steps.add(this);
			
			// DML and emails are now possible since no additional callouts will occur.
			
			// Possible final steps include:
			// - Recording details of each of the steps 
			// - Modifying org data based on the results
			// - Logging any errors that occured
			// - Sending notifications of success/failure 
			 
			return null;
		}
	}
}