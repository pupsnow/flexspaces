package org.integratedsemantics.flexspaces.view.tasks.tasklist
{
    import flash.events.MouseEvent;
    
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.DataGrid;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.presmodel.tasks.tasklist.TaskListPresModel;
    import org.integratedsemantics.flexspaces.view.tasks.event.ClickTaskEvent;
    
        
    /**
     * Base class for task listviews  
     * 
     */
    public class TaskListViewBase extends VBox
    {                
        public var refeshTasks:Button;
        public var taskGrid:DataGrid;
        
        [Bindable]
        public var taskListPresModel:TaskListPresModel;
        

        /**
         * Constructor 
         */
        public function TaskListViewBase()
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
            refeshTasks.addEventListener(MouseEvent.CLICK, onRefreshTasks);           
            taskGrid.addEventListener(ListEvent.ITEM_CLICK, onTaskItemClick);
            
            taskListPresModel.getTaskList();
        }
        
        /**
         * Handle request for redraw by requesting current task list data from server 
         * 
         */
        public function redraw():void
        {
            taskListPresModel.getTaskList();
        }
                
        /**
         * Gets the currently selected task item (or if multiple selection the last selected one)
         *  
         * @return currently selected task item 
         * 
         */
        public function getSelectedItem():Object
        {
            return taskGrid.selectedItem;
        }
                   
        /**
         * Gets the currently selected multiple task items
         *  
         * @return currently selected task items
         * 
         */
        public function getSelectedItems():Array
        {
            return taskGrid.selectedItems;
        }
        
        /**
         * Handle click on a task item by sending event to let rest of the UI know about the selection
         *  
         * @param event item click event
         * 
         */
        protected function onTaskItemClick(event:Event):void
        {
            var selectedItem:Object = getSelectedItem();
            
            var clickTaskEvent:ClickTaskEvent = new ClickTaskEvent(ClickTaskEvent.CLICK_TASK, selectedItem);
            var dispatched:Boolean = dispatchEvent(clickTaskEvent);                                    
        }
        
        /**
         * Handle click on refresh button by doing a redraw
         * @param event
         * 
         */
        protected function onRefreshTasks(event:Event):void
        {
            this.redraw();
        }
                     
    }
}