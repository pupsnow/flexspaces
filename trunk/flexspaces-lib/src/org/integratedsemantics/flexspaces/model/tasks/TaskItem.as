package org.integratedsemantics.flexspaces.model.tasks
{
    /**
     * Task Item model used in task list model 
     * Used in task list view
     */
    [Bindable]
    public class TaskItem extends Object
    {
        public var description:String;
        public var type:String;
        public var taskId:String;

        public var startDate:String;
        public var dueDate:String;
        public var dueToday:Boolean;
        public var overdue:Boolean;        
        
        public var priority:String;
        public var status:String;
        public var percentComplete:String;

        /**
         * Constructor 
         * 
         */
        public function TaskItem()
        {
            super();
        }
        
    }
}