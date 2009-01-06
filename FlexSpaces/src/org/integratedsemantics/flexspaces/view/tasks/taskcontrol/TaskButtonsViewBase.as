package org.integratedsemantics.flexspaces.view.tasks.taskcontrol
{
    import mx.containers.HBox;
    import mx.controls.Button;
    import mx.controls.Label;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.presmodel.tasks.taskcontrol.TaskButtonsPresModel;
    import org.integratedsemantics.flexspaces.util.ObserveUtil;
    import org.integratedsemantics.flexspaces.view.tasks.event.RefreshTaskListEvent;
    
        
    /**
     * Base class for task control button bar views  
     * 
     */
    public class TaskButtonsViewBase extends HBox
    {
        public var adhocDone:Button;
        public var approveTask:Button;
        public var rejectTask:Button;
        public var taskDescription:Label;
        public var listTitle:Label;

        [Bindable]
        public var taskButtonsPresModel:TaskButtonsPresModel;

        
        /**
         * Constructor 
         */
        public function TaskButtonsViewBase()
        {
            super();
        }    
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {           
            ObserveUtil.observeButtonClick(adhocDone, onAdhocDone);                        
            ObserveUtil.observeButtonClick(approveTask, onApproveTask);                        
            ObserveUtil.observeButtonClick(rejectTask, onRejectTask);            
            
            // initially disable buttons until have selected a task item
            adhocDone.enabled = false;
            approveTask.enabled = false;
            rejectTask.enabled = false;                 
        }
        
        /**
         * Set the task item to display control buttons for
         *  
         * @param taskItem task item
         * 
         */
        public function setTask(taskItem:Object):void
        {
            taskButtonsPresModel.taskItem = taskItem;
            
            taskDescription.text = taskItem.description;
            var type:String = taskButtonsPresModel.taskItem.type;
            if ((type != null) && (type == "Adhoc Task"))
            {
                adhocDone.enabled = true;
                approveTask.enabled = false;
                rejectTask.enabled = false;                
            }
            else if ((type != null) && (type == "Review"))
            {
                adhocDone.enabled = false;
                approveTask.enabled = true;
                rejectTask.enabled = true;                                
            }        
            else 
            {
                adhocDone.enabled = false;
                approveTask.enabled = false;
                rejectTask.enabled = false;                                
            }        
        }
        
        /**
         * Handle click on addhoc done button
         * 
         * @param event mouse click event
         * 
         */
        protected function onAdhocDone(event:Event):void
        {            
            var responder:Responder = new Responder(onResultEndTask, onFaultEndTask);
            taskButtonsPresModel.adhocDone(responder);
            
            adhocDone.enabled = false;
        }
        
        /**
         * Handle click on approve button
         * 
         * @param event mouse click event
         * 
         */
        protected function onApproveTask(event:Event):void
        {
            var responder:Responder = new Responder(onResultEndTask, onFaultEndTask);
            taskButtonsPresModel.approveTask(responder);
            
            approveTask.enabled = false;
            rejectTask.enabled = false;                                
        }

        /**
         * Handle click on reject button
         * 
         * @param event mouse click event
         * 
         */        
        protected function onRejectTask(event:Event):void
        {
            var responder:Responder = new Responder(onResultEndTask, onFaultEndTask);
            taskButtonsPresModel.rejectTask(responder);
            
            approveTask.enabled = false;
            rejectTask.enabled = false;                                
        } 

        /**
         * Handler called when end task successfully completed
         * 
         * @param info   end task result info
         */
        protected function onResultEndTask(info:Object):void
        {
            mx.controls.Alert.show(taskButtonsPresModel.transitionLabel + " Completed.");
            
            // request refresh of task list
            var event:RefreshTaskListEvent = new RefreshTaskListEvent(RefreshTaskListEvent.REFRESH_TASK_LIST);
            dispatchEvent(event);
        }

        /**
         * Handler called when fault returned from end task operation 
         * 
         * @param  info end task fault info
         * 
         */
        protected function onFaultEndTask(info:Object):void
        {
            trace("onFaultEndTask" + info);            
        }
            
    }
}