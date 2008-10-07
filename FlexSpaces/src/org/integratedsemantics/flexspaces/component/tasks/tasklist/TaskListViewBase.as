package org.integratedsemantics.flexspaces.component.tasks.tasklist
{
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.DataGrid;
    import mx.controls.Label;

    import org.integratedsemantics.flexspaces.model.tasks.TaskListCollection;
    
        
    /**
     * Base class for task listviews  
     * 
     */
    public class TaskListViewBase extends VBox
    {        
        [Bindable] public var taskList:TaskListCollection;
        
        public var refeshTasks:Button;
        public var taskGrid:DataGrid;
        
        /**
         * Constructor 
         */
        public function TaskListViewBase()
        {
            super();
        }        
    }
}