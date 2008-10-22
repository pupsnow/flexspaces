package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Provides start workflow, end task, list tasks, list task attachments via web scripts 
     * 
     */
    public class TaskDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function TaskDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets task list data for the current user
         * 
         */
        public function getTaskList():void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/taskList";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetTaskListSuccess);
                
                var params:Object = new Object();
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onGetTaskListSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetTaskListSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }
        
        /**
         * Gets task attachments data for given task
         * 
         * @param taskId task id to list attachments
         */
        public function getTaskAttachments(taskId:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/taskAttachments";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetTaskAttachmentsSuccess);
                
                var params:Object = new Object();
                params.taskid = taskId;
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onGetTaskAttachmentsSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetTaskAttachmentsSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }       
        
        /**
         * End task ( adhoc done, approve, reject, other transitions 
         * 
         * @param taskId task id
         * @param transition id such as "approve", "reject", etc. (addhoc done empty string)
         */
        public function endTask(taskId:String, transitionId:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/endTask";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onEndTaskSuccess);
                
                var params:Object = new Object();
                params.taskid = taskId;
                
                if (transitionId != null)
                {                
                   params.transid = transitionId;
                }
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onEndTaskSuccess event handler
         * 
         * @param event success event
         */
        protected function onEndTaskSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }       
                
        /**
         * Start Workflow (adhoc or other kinds)
         * 
         * @param repoNode doc node to start worklow on
         * @param workflowType ("review" or "adhoc")
         * @param assignTo user to assign to
         * @param desc description
         * @param dueDate due date
         * 
         */
        public function startWorkflow(repoNode:IRepoNode, workflowType:String, assignTo:String, desc:String, dueDate:String=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/startWorkflow";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onStartWorkflowSuccess);
                
                var params:Object = new Object();
                params.nodeid = repoNode.getId();
                params.type = workflowType;
                params.assignto = assignTo;
                params.desc = desc;                
                
                if (dueDate != null)
                {                
                   params.duedate = dueDate;
                }
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        
        /**
         * Start LiveCycle Workflow (review and approval process)
         * 
         * @param repoNode doc node to start worklow on
         * @param assigner user assigning the task
         * @param reviewer user to do the review
         * @param desc description
         * 
         */
        public function startLiveCycleWorkflow(repoNode:IRepoNode, assigner:String, reviewer:String, desc:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/livecycle/startWorkflow";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onStartWorkflowSuccess);
                
                var params:Object = new Object();
                params.nodeid = repoNode.getId();
                params.assigner = assigner;
                params.reviewer = reviewer;
                params.desc = desc;                
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        
        /**
         * onStartWorkflowSuccess event handler
         * 
         * @param event success event
         */
        protected function onStartWorkflowSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }       
        
    }
}