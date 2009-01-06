package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.TaskDelegate;
    import org.integratedsemantics.flexspaces.control.event.task.*;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;

	
	/**
	 * Task Command provides task list, task attachments, start worflow, 
	 * and task ending (adhoc done, approve, reject, etc.)
	 */
	public class TaskCommand extends Command
	{
        /**
         * Constructor
         */
        public function TaskCommand()
        {
            super();
        }

        /**
         * Execute command for the given event
         *  
         * @param event task event
         * 
         */
        override public function execute(event:CairngormEvent):void
        {
            // always call the super.execute() method which allows the callBack information to be cached.
            super.execute(event);
 
            switch(event.type)
            {
                case TaskListEvent.TASK_LIST:
                    getTaskList(event as TaskListEvent);  
                    break;
                case TaskAttachmentsEvent.TASK_ATTACHMENTS:
                    getTaskAttachments(event as TaskAttachmentsEvent);  
                    break;
                case StartWorkflowEvent.START_WORKFLOW:
                    startWorkflow(event as StartWorkflowEvent);  
                    break;
                case EndTaskEvent.END_TASK:
                    endTask(event as EndTaskEvent);  
                    break;
            }
        }       

		/**
		 * Gets task list data 
		 * 
		 * @param event task list event
		 */
		public function getTaskList(event:TaskListEvent):void
		{
            var handlers:Callbacks = new Callbacks(onGetTaskListSuccess, onFault);
            var delegate:TaskDelegate = new TaskDelegate(handlers);
            delegate.getTaskList();                  
		}
		
		/**
		 * onGetTaskListSuccess event handler
		 * 
		 * @param event  success event 
		 * 
		 */
		protected function onGetTaskListSuccess(event:*):void
		{
            this.result(event.result);
		}
		
        /**
         * Gets task attachments data
         *  
         * @param event task attachments event
         */
        public function getTaskAttachments(event:TaskAttachmentsEvent):void
        {
            var handlers:Callbacks = new Callbacks(onGetTaskAttachmentsSuccess, onFault);
            var delegate:TaskDelegate = new TaskDelegate(handlers);
            delegate.getTaskAttachments(event.taskId);                  
        }
        
        /**
         * onGetTaskAttachmentsSuccess event handler
         * 
         * @param event  success event 
         */
        protected function onGetTaskAttachmentsSuccess(event:*):void
        {
            this.result(event.result);            
        }		
		
        /**
         * End task (adhoc done, approve, reject), other transitions
         *  
         * @param event end task event
         * 
         */
        public function endTask(event:EndTaskEvent):void
        {
            var handlers:Callbacks = new Callbacks(onEndTaskSuccess, onFault);
            var delegate:TaskDelegate = new TaskDelegate(handlers);
            delegate.endTask(event.taskId, event.transitionId);                  
        }
        
        /**
         * onEndTaskSuccess event handler
         * 
         * @param event success event
         */
        protected function onEndTaskSuccess(event:*):void
        {
            this.result(event.result);
        }       
                
        /**
         * Start Workflow (adhoc or other kinds)
         * 
         * @param event start workflow event
         * 
         */
        public function startWorkflow(event:StartWorkflowEvent):void
        {
            var handlers:Callbacks = new Callbacks(onStartWorkflowSuccess, onFault);
            var delegate:TaskDelegate = new TaskDelegate(handlers);

            var model : AppModelLocator = AppModelLocator.getInstance();                            
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                delegate.startLiveCycleWorkflow(event.repoNode, event.assignTo, event.assignTo, event.desc);
            }
            else
            {
                delegate.startWorkflow(event.repoNode, event.workflowType, event.assignTo, event.desc, event.dueDate);
            }
        }
        
        /**
         * onStartWorkflowSuccess event handler
         * 
         * @param event success event 
         */
        protected function onStartWorkflowSuccess(event:*):void
        {
            this.result(event.result);            
        }       

	}
	
}