package org.integratedsemantics.flexspaces.control.event.task
{
    import mx.rpc.IResponder;
    import com.universalmind.cairngorm.events.UMEvent;

    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


	/**
	 * Event to request starting a workflow on a document
	 */
	public class StartWorkflowEvent extends UMEvent
	{
		/** Event name */
		public static const START_WORKFLOW:String = "startWorkflow";

        public var repoNode:IRepoNode;

        public var workflowType:String;
        public var assignTo:String;
        public var desc:String;
        public var dueDate:String;        

		/**
		 * Constructor 
		 *  
		 * @param eventType event name
		 * @param handlers responder with result and fault handlers
         * @param repoNode repository node doc to start a worklow on
		 * @param workflowType type of workflow ("review" or "adhoc")
		 * @param assignTo user to assign to
		 * @param desc description text
		 * @param dueDate optional due date
		 * 
		 */
		public function StartWorkflowEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, workflowType:String, assignTo:String, 
		                                   desc:String, dueDate:String=null)
		{
            super(eventType, handlers);
            
            this.repoNode = repoNode;

            this.workflowType = workflowType;
            this.assignTo = assignTo;
            this.desc = desc;
            this.dueDate = dueDate;            
		}
				
	}
}