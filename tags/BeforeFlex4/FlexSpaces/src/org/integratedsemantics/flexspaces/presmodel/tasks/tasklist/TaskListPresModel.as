package org.integratedsemantics.flexspaces.presmodel.tasks.tasklist
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.task.TaskListEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.tasks.TaskListCollection;
    

    /**
     * Presentation model of user task list view 
     * 
     */
   [Bindable] 
    public class TaskListPresModel extends PresModel
    {
        public var taskList:TaskListCollection;


        /**
         * Constructor
         *  
         */
        public function TaskListPresModel()
        {
            super();
            
            this.taskList = new TaskListCollection();                        
        }
        
        /**
         * Get task list for current user
         * 
         */
        public function getTaskList():void
        {
            var responder:Responder = new Responder(onResultTaskList, onFaultTaskList);
            var taskListEvent:TaskListEvent = new TaskListEvent(TaskListEvent.TASK_LIST, responder);
            taskListEvent.dispatch();                        
        }
        
        /**
         * Handle request for redraw by requesting current task list data from server 
         * 
         */
        public function redraw():void
        {
            getTaskList();            
        }
                
        /**
         * Handler called for successful call to server for get task list data
         *  
         * @param data task list data result
         * 
         */
        protected function onResultTaskList(data:Object):void
        {
            taskList.initData(data);            
        }

        /**
         * Handler call for fault return in response to server call for get task list dat
         *  
         * @param info fault info
         * 
         */
        protected function onFaultTaskList(info:Object):void
        {
            trace("onFaultTaskList" + info);            
        }
        
    }
}