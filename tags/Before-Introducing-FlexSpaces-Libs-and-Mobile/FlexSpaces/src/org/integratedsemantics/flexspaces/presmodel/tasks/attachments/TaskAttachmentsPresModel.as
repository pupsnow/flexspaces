package org.integratedsemantics.flexspaces.presmodel.tasks.attachments
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.task.TaskAttachmentsEvent;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.tasks.AttachmentsCollection;
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;


    /**
     * Presentation model of list of attached task documents with folder like view display (icons/details modes)
     * 
     */
    [Bindable] 
    public class TaskAttachmentsPresModel extends NodeListViewPresModel
    {
        public var taskItem:Object;
        
        /**
         * Constructor
         *  
         */
        public function TaskAttachmentsPresModel()
        {
        }
        
        
        /**
         * Initialize model 
         * 
         */
        override public function initModel():void
        {
            this.nodeCollection = new AttachmentsCollection();       
        }

        /**
         * Set the task item to display attachments for
         *  
         * @param taskItem task item
         * 
         */
        public function setTask(taskItem:Object):void
        {
            this.taskItem = taskItem;
            
            var responder:Responder = new Responder(onResultTaskAttachments, onFaultTaskAttachments);
            var taskAttachmentsEvent:TaskAttachmentsEvent = new TaskAttachmentsEvent(TaskAttachmentsEvent.TASK_ATTACHMENTS, responder, taskItem.taskId);
            taskAttachmentsEvent.dispatch();
        }
        
        /**
         * Handler called when get task attachments successfully completed
         * 
         * @param info   task attchments data
         */
        private function onResultTaskAttachments(data:Object):void
        {
            var attachments:AttachmentsCollection = this.nodeCollection as AttachmentsCollection;
            attachments.initData(data);    
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = showThumbnails;
            }                                                 
        }

        /**
         * Handler called when get task attachments returns fault
         *  
         * @param fault info
         * 
         */
        protected function onFaultTaskAttachments(info:Object):void
        {
            trace("onFaultTaskAttachments" + info);            
        }
    }
}