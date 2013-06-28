public with sharing class Flow2 extends FlowFactory.FlowParent
{
	public override FlowFactory.FlowState processWork()
	{
		return processWork(1);
	}
	public override FlowFactory.FlowState processWork(Integer p)
	{
		return processWork(p, null);
	}
	public override FlowFactory.FlowState processWork(Integer p, Contact c)
	{
		Flow2State state = new Flow2State(p, c);
		FlowFactory.Step step = new FirstStep();
		step.stepName = FirstStep.class.toString();
		processSteps(step, state);

		return state;
	}

	public class Flow2State extends FlowFactory.FlowState
	{
		public Integer path {get; private set;}
		public Contact contact {get; private set;}
		public Flow2State(Integer p, Contact c)
		{
			this.path = p;
			this.contact = c; // To demonstrate override with unique initial flow data 
		}
	}
	
	public class FirstStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow2State state = (Flow2State) fs;
			state.steps.add(this);		
			this.nextStep = createDynamicInstance(FirstStep.class.toString(), 1);
			return this.nextStep;
		}
	}
	
	public class Step2 extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow2State state = (Flow2State) fs;
			state.steps.add(this);
			this.nextStep = createDynamicInstance(Step2.class.toString(), state.path == 1 ? 1 : 2);
			return this.nextStep;
		}
	}

	public class Step3 extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow2State state = (Flow2State) fs;
			state.steps.add(this);
			this.nextStep = createDynamicInstance(Step3.class.toString(), state.path);
			return this.nextStep;
		}
	}

	public class Step4 extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow2State state = (Flow2State) fs;
			state.steps.add(this);
			this.nextStep = createDynamicInstance(Step4.class.toString(), 1);
			return this.nextStep;
		}
	}

	public class Step5 extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow2State state = (Flow2State) fs;
			state.steps.add(this);
			this.nextStep = createDynamicInstance(Step5.class.toString(), 1);
			return this.nextStep;
		}
	}

	public class FinalStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			Flow2State state = (Flow2State) fs;
			state.steps.add(this);
			return null;
		}
	}
}