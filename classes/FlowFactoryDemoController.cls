public with sharing class FlowFactoryDemoController 
{
	public Flow__c theFlow {get; set;}
	public Map<Id, Flow__c> flowMap {get; private set;}
	public Map<Id, Flow_Step__c> stepMap {get; private set;}
	public Map<Id, Flow_Step_Branch__c> branchMap {get; set;}

	public List<SelectOption> flowList {get; private set;}
	public String selectedFlow {get; set;}
	public List<SelectOption> pathList {get; private set;}
	public String selectedPath {get; set;}
	public Boolean hasFlows {get; private set;}
	public Boolean hasData {get{return [SELECT count() FROM Flow__c] > 0;} private set;} 

	// Flow step & branch list
	public List<StepWrapper> stepTree {get; private set;}
	public class StepWrapper
	{
		public Flow_Step__c step {get; private set;}
		public List<Flow_Step_Branch__c> branchList {get; private set;}
		public StepWrapper(Flow_Step__c fs, List<Flow_Step_Branch__c> fsb)
		{
			this.step = fs;
			this.branchList = fsb;
		}
	}

	// Executed flow steps
	public List<ExecutedFlowStep> executedFlowSteps {get; private set;}
	public class ExecutedFlowStep
	{
		public Integer stepNumber {get; private set;}
		public String step {get; private set;}
		public ExecutedFlowStep(Integer stepNumber, String step)
		{
			this.stepNumber = stepNumber;
			this.step = step;
		}
	}

	public FlowFactoryDemoController()
	{
		loadAll();
	}
	
	private void loadAll()
	{
		initVars();
		loadMaps();
		loadFlowList();
	}
	
	public PageReference loadSampleData()
	{
		FlowData.createFlowData();
		loadAll();
		return null;
	}
	
	private void initVars()
	{
		this.executedFlowSteps = new List<ExecutedFlowStep>();
		this.pathList = new List<SelectOption>();
		this.pathList.add(new SelectOption('1', 'Path 1'));
		this.pathList.add(new SelectOption('2', 'Path 2'));
		this.pathList.add(new SelectOption('3', 'Path 3'));
		this.selectedPath = '1';
	}
	
	private void loadMaps()
	{
		this.flowMap = new Map<Id, Flow__c>([SELECT Id, Name FROM Flow__c LIMIT 1000]);
		this.stepMap = new Map<Id, Flow_Step__c>([SELECT Id, Name FROM Flow_Step__c LIMIT 1000]);
		this.branchMap = new Map<Id, Flow_Step_Branch__c>([SELECT Id, Flow_Step__c, Name, Next_Step__c, Next_Step__r.Name FROM Flow_Step_Branch__c LIMIT 1000]);
	}
	
	public PageReference loadFlowList()
	{
		this.flowList = new List<SelectOption>();
		for(Flow__c f : [SELECT Id, Name FROM Flow__c ORDER BY CreatedDate LIMIT 1000])
			this.flowList.add(new SelectOption(f.Id, f.Name));
		
		if(this.flowList.size() > 0)
		{
			this.selectedFlow = flowList[0].getValue();
			populateStepTree();
		}
		
		return null;
	}

	public PageReference populateStepTree()
	{
		this.executedFlowSteps.clear();
		this.stepTree = new List<StepWrapper>();
		for(Flow_Step__c fs : [SELECT Id, Name FROM Flow_Step__c WHERE Flow__c = :this.selectedFlow ORDER BY CreatedDate LIMIT 1000])
		{
			List<Flow_Step_Branch__c> branchList = new List<Flow_Step_Branch__c>();
			
			for(Flow_Step_Branch__c fsb : this.branchMap.values())
			{
				if(fsb.Flow_Step__c == fs.Id)
				{
					branchList.add(fsb);
				}
			}
			
			branchList.sort();
			
			this.stepTree.add(new StepWrapper(fs, branchList));
		}
		return null;
	}

	public PageReference executeFlow()
	{
		this.executedFlowSteps.clear();
        Type t = Type.forName(this.flowMap.get(this.selectedFlow).Name);
        if(t != null)
        {
	        FlowFactory.FlowParent f = (FlowFactory.FlowParent) t.newInstance();
	        FlowFactory.FlowState fs = f.processWork(Integer.valueOf(this.selectedPath));
	        populateResults(fs.steps);
        }
        
        return null;
	}
	
	private void populateResults(List<FlowFactory.Step> steps)
	{
		this.executedFlowSteps.clear();
		for(Integer i=0; i<steps.size(); i++)
			this.executedFlowSteps.add(new ExecutedFlowStep(i+1, steps[i].stepName));
	}
}