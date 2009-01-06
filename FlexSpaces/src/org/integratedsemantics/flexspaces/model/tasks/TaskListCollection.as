package org.integratedsemantics.flexspaces.model.tasks
{
	import mx.collections.ArrayCollection;
	
    
    /**
     * Model with collection of TaskItems 
     * Used in Tasks list view
     * 
     */
    [Bindable]
    public class TaskListCollection extends ArrayCollection
    {       
        public var taskItemCollection:ArrayCollection;
         
        /**
         * Constructor 
         * 
         */
        public function TaskListCollection()
        {
            super();
        }
        
        /**
         * Inits with new task list data
         * 
         * @param data   task list data
         */
        public function initData(data:Object):void
        {
            var result:TaskListCollection = data as TaskListCollection;
            
			this.taskItemCollection = result.taskItemCollection;                
            result.taskItemCollection = null;
            
            this.source = taskItemCollection.source;
            this.refresh();
        }
        
    }
}
