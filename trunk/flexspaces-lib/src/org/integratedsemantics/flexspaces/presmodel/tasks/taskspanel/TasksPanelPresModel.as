package org.integratedsemantics.flexspaces.presmodel.tasks.taskspanel
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.presmodel.tasks.attachments.TaskAttachmentsPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tasks.taskcontrol.TaskButtonsPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tasks.tasklist.TaskListPresModel;

    
    /**
     * Presentation model for panel with task list, task approval buttons, list of task attachments 
     *
     */
    [Bindable] 
    public class TasksPanelPresModel extends PresModel
    {
        public var taskAttachmentsPresModel:TaskAttachmentsPresModel;

        public var taskListPresModel:TaskListPresModel;
        public var taskButtonsPresModel:TaskButtonsPresModel;  

        
        /**
         * Constructor
         *  
         */
        public function TasksPanelPresModel()
        {
            super();
            
            taskListPresModel = new TaskListPresModel();
            taskButtonsPresModel = new TaskButtonsPresModel();
            taskAttachmentsPresModel = new TaskAttachmentsPresModel();                 
        }        
        
        /**
         * Refresh by redrawing task list with new server data 
         * 
         */
        public function refreshTaskList():void
        {        
            if (taskListPresModel != null)
            {
                taskListPresModel.redraw();
            }
        }
        
    }
}