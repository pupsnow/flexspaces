package org.integratedsemantics.flexspaces.presmodel.tasks.startworkflow
{
    import mx.collections.ArrayCollection;
    import mx.formatters.DateFormatter;
    import mx.resources.ResourceManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.task.StartWorkflowEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     *  Start Workflow dialog presentation model for starting workflow on documents
     *  
     */
    [Bindable] 
    public class StartWorkflowPresModel extends PresModel
    {
        public var repoNode:IRepoNode;        
                     
        public var workflowTypes:ArrayCollection = new ArrayCollection(); 


        // type of workflow ("review" or "addhoc")
        public var workflowTypeSelection:Object = null;
        
        // user to assign to
        public var assignToText:String = "admin";
        
    	// optional due date
	    public var dueDate:String = "";

		// description text
        public var descText:String = "";
        
        public var dueOnVisible:Boolean = true;
        
	    protected var model:AppModelLocator = AppModelLocator.getInstance();                            


        /**
         * Constructor
         *  
         * @param nodeId node id of doc to start worklow on
         * 
         */
        public function StartWorkflowPresModel(repoNode:IRepoNode)
        {
            super();
            
            this.repoNode = repoNode;
            
			var reviewAndApproveType:Object = new Object();
			reviewAndApproveType.label = ResourceManager.getInstance().getString('StartWorkflowView', 'reviewAndApprove_label');
			reviewAndApproveType.workflowType = "review";
			reviewAndApproveType.id = "reviewAndApprove";			            
			workflowTypes.addItem(reviewAndApproveType);
            
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                assignToText = "administrator/DefaultDom";
                dueOnVisible = false;
            }
            else
            {
				var adhocType:Object = new Object();
				adhocType.label = ResourceManager.getInstance().getString('StartWorkflowView', 'adhocTask_label');
				adhocType.workflowType = "adhoc";
				adhocType.id = "adhocTask";			            
				workflowTypes.addItem(adhocType);
            }            
        }
                        
        /**
         * Start a workflow 
         * 
         * @param responder responder for calling back with result or fault
         * 
         */
        public function startWorkflow(responder:Responder):void 
        {
            var workflowType:String = workflowTypeSelection.workflowType;
            
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                 dueDate = "";
            }
            
            var dateFormatted:String = null;
            if (dueDate != "")
            {
                var dateFormatter:DateFormatter = new DateFormatter();
                dateFormatter.formatString = "DD MMMM YYYY";
                dateFormatted = dateFormatter.format(dueDate);
            }
            
            var startWorkflowEvent:StartWorkflowEvent = new StartWorkflowEvent(StartWorkflowEvent.START_WORKFLOW, responder, 
                                                                repoNode, workflowType, assignToText, descText, dateFormatted);
            startWorkflowEvent.dispatch();            
        }
        
    }
}