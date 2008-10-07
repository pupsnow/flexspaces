package org.integratedsemantics.flexspaces.model.tasks
{
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;

    
    /**
     * Model with collection of TaskItems 
     * Used in Tasks list view
     * 
     */
    [Bindable]
    public class TaskListCollection extends ArrayCollection
    {       
        protected var taskItemCollection:ArrayCollection;
         
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
            var result:XML = data as XML;
            
            var itemXMLCollection:XMLListCollection = new XMLListCollection(result.taskitem);
            
            this.taskItemCollection = new ArrayCollection();
            
            for each (var xmlItem:XML in itemXMLCollection)
            {
                var item:TaskItem = new TaskItem();
                
                item.taskId = xmlItem.taskid;
                item.type = xmlItem.type;
                item.description = xmlItem.description;

                item.startDate = xmlItem.startdate;
                item.dueDate = xmlItem.duedate;
                item.dueToday = xmlItem.duetoday == "true";
                item.overdue = xmlItem.overdue == "true";

                item.priority = xmlItem.priority;
                item.status = xmlItem.status;
                item.percentComplete = xmlItem.percentcomplete;

                taskItemCollection.addItem(item);
            }
            
            this.source = taskItemCollection.source;
            this.refresh();
        }
        
    }
}
