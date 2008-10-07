package org.integratedsemantics.flexspaces.component.tasks.taskcontrol
{
    import flash.events.Event;
    
    import mx.controls.Alert;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.tasks.event.RefreshTaskListEvent;
    import org.integratedsemantics.flexspaces.control.event.task.EndTaskEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;

    
    /**
     * Presenter for task control buttons (adhoc done, approve, reject, etc.) 
     * 
     * Supervising/Controller for TaskButtonsViewBase views
     * 
     */
    public class TaskButtonsPresenter extends Presenter
    {
        protected var taskItem:Object;
        protected var transitionLabel:String;
        
        
        /**
         * Constructor
         *  
         * @param taskButtonsView view to control
         * 
         */
        public function TaskButtonsPresenter(taskButtonsView:TaskButtonsViewBase)
        {
            super(taskButtonsView);

            if (taskButtonsView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(taskButtonsView, onCreationComplete);            
            }
        }
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get taskButtonsView():TaskButtonsViewBase
        {
            return this.view as TaskButtonsViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {           
            observeButtonClick(taskButtonsView.adhocDone, onAdhocDone);                        
            observeButtonClick(taskButtonsView.approveTask, onApproveTask);                        
            observeButtonClick(taskButtonsView.rejectTask, onRejectTask);            
            
            // initially disable buttons until have selected a task item
            taskButtonsView.adhocDone.enabled = false;
            taskButtonsView.approveTask.enabled = false;
            taskButtonsView.rejectTask.enabled = false;                 
        }

        /**
         * Set the task item to display control buttons for
         *  
         * @param taskItem task item
         * 
         */
        public function setTask(taskItem:Object):void
        {
            this.taskItem = taskItem;
            
            taskButtonsView.taskDescription.text = taskItem.description;
            var type:String = taskItem.type;
            if ((type != null) && (type == "Adhoc Task"))
            {
                taskButtonsView.adhocDone.enabled = true;
                taskButtonsView.approveTask.enabled = false;
                taskButtonsView.rejectTask.enabled = false;                
            }
            else if ((type != null) && (type == "Review"))
            {
                taskButtonsView.adhocDone.enabled = false;
                taskButtonsView.approveTask.enabled = true;
                taskButtonsView.rejectTask.enabled = true;                                
            }        
            else 
            {
                taskButtonsView.adhocDone.enabled = false;
                taskButtonsView.approveTask.enabled = false;
                taskButtonsView.rejectTask.enabled = false;                                
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
            var endTaskEvent:EndTaskEvent = new EndTaskEvent(EndTaskEvent.END_TASK, responder, taskItem.taskId, "");
            endTaskEvent.dispatch();
            this.transitionLabel = "Adhoc Done";
            taskButtonsView.adhocDone.enabled = false;
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
            var endTaskEvent:EndTaskEvent = new EndTaskEvent(EndTaskEvent.END_TASK, responder, taskItem.taskId, "approve");
            endTaskEvent.dispatch();
            this.transitionLabel = "Approve";
            taskButtonsView.approveTask.enabled = false;
            taskButtonsView.rejectTask.enabled = false;                                
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
            var endTaskEvent:EndTaskEvent = new EndTaskEvent(EndTaskEvent.END_TASK, responder, taskItem.taskId, "reject");
            endTaskEvent.dispatch();
            this.transitionLabel = "Reject";
            taskButtonsView.approveTask.enabled = false;
            taskButtonsView.rejectTask.enabled = false;                                
        } 

        /**
         * Handler called when end task successfully completed
         * 
         * @param info   end task result info
         */
        protected function onResultEndTask(info:Object):void
        {
            mx.controls.Alert.show(this.transitionLabel + " Completed.");
            
            // request refresh of task list
            var event:RefreshTaskListEvent = new RefreshTaskListEvent(RefreshTaskListEvent.REFRESH_TASK_LIST);
            taskButtonsView.dispatchEvent(event);
        }

        /**
         * Handler called when fault returned from end task operation 
         * @param  info end task fault info
         * 
         */
        protected function onFaultEndTask(info:Object):void
        {
            trace("onFaultEndTask" + info);            
        }
        
    }
}