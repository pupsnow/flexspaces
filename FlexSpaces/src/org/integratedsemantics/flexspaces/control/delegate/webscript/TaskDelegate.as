package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.tasks.AttachmentsCollection;
    import org.integratedsemantics.flexspaces.model.tasks.TaskItem;
    import org.integratedsemantics.flexspaces.model.tasks.TaskListCollection;


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
            var result:XML = event.result as XML;
            
            var taskListCollection:TaskListCollection = new TaskListCollection();
            
            var itemXMLCollection:XMLListCollection = new XMLListCollection(result.taskitem);
            
            taskListCollection.taskItemCollection = new ArrayCollection();
            
            for each (var xmlItem:XML in itemXMLCollection)
            {
                var item:TaskItem = new TaskItem();
                
                item.taskId = xmlItem.taskid;
                item.type = xmlItem.type;
                item.description = xmlItem.description;

                item.startDate = xmlItem.startdate;
                item.dueDate = xmlItem.duedate;
                item.dueToday = xmlItem.duetoday == "true";
                item.overdue = xmlItem.overdue == "true";

                item.priority = xmlItem.priority;
                item.status = xmlItem.status;
                item.percentComplete = xmlItem.percentcomplete;

                taskListCollection.taskItemCollection.addItem(item);
            }
        	
            notifyCaller(taskListCollection, event);
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
            var result:XML = event.result as XML;
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            var attachmentsCollection:AttachmentsCollection = new AttachmentsCollection();
            
            var nodeXMLCollection:XMLListCollection = new XMLListCollection(result.node);
            
            attachmentsCollection.nodeCollection = new ArrayCollection();
            
            for each (var xmlNode:XML in nodeXMLCollection)
            {
                var node:Node = new Node();
                
                node.name = xmlNode.name;
                
                node.nodeRef = xmlNode.noderef;

                node.storeProtocol = xmlNode.storeProtocol;
                node.storeId = xmlNode.storeId;
                node.id = xmlNode.id;                
                
                node.parentPath = xmlNode.parentPath;
                node.path = xmlNode.path;
                
                // strip off initial slash. add src path, so local icons will be found
                node.icon16 = xmlNode.icon16;
                node.icon16 = model.appConfig.srcPath + node.icon16.substr(1);
                node.icon32 = xmlNode.icon32;
                node.icon32 = model.appConfig.srcPath + node.icon32.substr(1);
                node.icon64 = xmlNode.icon64;
                node.icon64 = model.appConfig.srcPath + node.icon64.substr(1);
                
                node.isFolder = xmlNode.isFolder == "true";
                node.type = xmlNode.type;

                node.desc = xmlNode.desc;
                
                node.size = xmlNode.size;

                node.created = xmlNode.created;
                node.modified = xmlNode.modified;

                node.viewurl = xmlNode.viewurl;
                
                node.isLocked = (xmlNode.islocked == "true");
                node.isWorkingCopy = (xmlNode.isWorkingCopy == "true");

                node.readPermission = (xmlNode.readPermission == "true");
                node.writePermission = (xmlNode.writePermission == "true");
                node.deletePermission = (xmlNode.deletePermission == "true");
                node.createChildrenPermission = (xmlNode.createChildrenPermission == "true");
                
                if (node.isFolder == true)
                {
                    node.thumbnailUrl = node.icon64;
                }
                else
                {
                    node.thumbnailUrl = attachmentsCollection.getThumbnailUrl(node);    
                }

                attachmentsCollection.nodeCollection.addItem(node);
            }
        	        	
            notifyCaller(attachmentsCollection, event);
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