package org.integratedsemantics.flexspaces.component.tasks.taskspanel
{
    import mx.containers.VDividedBox;
    
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.tasks.taskcontrol.TaskButtonsViewBase;
    import org.integratedsemantics.flexspaces.component.tasks.tasklist.TaskListViewBase;

    /**
     * Base task panel view class 
     * 
     */
    public class TasksPanelViewBase extends VDividedBox
    {
        public var taskListView:TaskListViewBase;
        
        public var taskButtonsView:TaskButtonsViewBase;
        
        public var taskAttachmentsView:FolderViewBase;
        
        
        /**
         * Constructor 
         * 
         */
        public function TasksPanelViewBase()
        {
            super();
        }
        
    }
}