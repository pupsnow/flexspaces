package org.integratedsemantics.flexspaces.component.tasks.taskcontrol
{
    import mx.containers.HBox;
    import mx.controls.Button;
    import mx.controls.Label;
    
        
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
        
        /**
         * Constructor 
         */
        public function TaskButtonsViewBase()
        {
            super();
        }        
    }
}