package org.integratedsemantics.flexspaces.presmodel.tasks.taskcontrol
{
    import mx.controls.Alert;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.task.EndTaskEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.view.tasks.event.RefreshTaskListEvent;

    
    /**
     * Presentation model for task control buttons (adhoc done, approve, reject, etc.) 
     * 
     */
    [Bindable] 
    public class TaskButtonsPresModel extends PresModel
    {
        public var taskItem:Object;
        public var transitionLabel:String;
        
        protected var model:AppModelLocator = AppModelLocator.getInstance();                            

        
        /**
         * Constructor
         * 
         */
        public function TaskButtonsPresModel()
        {
            super();
        }
        
        /**
         * Adhoc done
         * 
         * @param responder responder for result or fault callback
         * 
         */
        public function adhocDone(responder:Responder):void
        {            
            var transitionId:String = "";
            if (model.ecmServerConfig.serverVersionNum() >= 4)
            {    
                transitionId = "Next";
            }

            var endTaskEvent:EndTaskEvent = new EndTaskEvent(EndTaskEvent.END_TASK, responder, taskItem.taskId, transitionId);
                                   
            endTaskEvent.dispatch();

			// todo i18n
            this.transitionLabel = "Adhoc Done";
        }
        
        /**
         * approve task
         * 
         * @param responder responder for result or fault callback
         * 
         */
        public function approveTask(responder:Responder):void
        {
            var transitionId:String = "approve";
            if (model.ecmServerConfig.serverVersionNum() >= 4)
            {    
                transitionId = "Approve";
            }
            
            var endTaskEvent:EndTaskEvent = new EndTaskEvent(EndTaskEvent.END_TASK, responder, taskItem.taskId, transitionId);
            endTaskEvent.dispatch();

			// todo i18n
            this.transitionLabel = "Approve";
        }

        /**
         * Reject task
         * 
         * @param responder responder for result or fault callback
         * 
         */        
        public function rejectTask(responder:Responder):void
        {
            var transitionId:String = "reject";
            if (model.ecmServerConfig.serverVersionNum() >= 4)
            {    
                transitionId = "Reject";
            }
            
            var endTaskEvent:EndTaskEvent = new EndTaskEvent(EndTaskEvent.END_TASK, responder, taskItem.taskId, transitionId);
            endTaskEvent.dispatch();

			// todo i18n
            this.transitionLabel = "Reject";
        } 

    }
}