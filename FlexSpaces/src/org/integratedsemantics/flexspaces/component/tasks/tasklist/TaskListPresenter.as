package org.integratedsemantics.flexspaces.component.tasks.tasklist
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.tasks.event.ClickTaskEvent;
    import org.integratedsemantics.flexspaces.control.event.task.TaskListEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.tasks.TaskListCollection;
    

    /**
     * Presenter of user task list view 
     * 
     * Supervising Presenter/Controller of data bound TaskListViewBase views
     * 
     */
    public class TaskListPresenter extends Presenter
    {
        // bindable data for folder view               
        [Bindable] protected var taskList:TaskListCollection;
        
        
        /**
         * Constructor
         *  
         * @param taskListView view to control
         * 
         */
        public function TaskListPresenter(taskListView:TaskListViewBase)
        {
            super(taskListView);
            
            this.taskList = new TaskListCollection(); 
                       
            if (taskListView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(taskListView, onCreationComplete);            
            }
        }
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get taskListView():TaskListViewBase
        {
            return this.view as TaskListViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            taskListView.taskList = this.taskList; 
            
            taskListView.refeshTasks.addEventListener(MouseEvent.CLICK, onRefreshTasks);           
            taskListView.taskGrid.addEventListener(ListEvent.ITEM_CLICK, onTaskItemClick);
            
            var responder:Responder = new Responder(onResultTaskList, onFaultTaskList);
            var taskListEvent:TaskListEvent = new TaskListEvent(TaskListEvent.TASK_LIST, responder);
            taskListEvent.dispatch();                        
        }
        
        /**
         * Handle request for redraw by requesting current task list data from server 
         * 
         */
        public function redraw():void
        {
            var responder:Responder = new Responder(onResultTaskList, onFaultTaskList);
            var taskListEvent:TaskListEvent = new TaskListEvent(TaskListEvent.TASK_LIST, responder);
            taskListEvent.dispatch();            
        }
                
        /**
         * Gets the currently selected task item (or if multiple selection the last selected one)
         *  
         * @return currently selected task item 
         * 
         */
        public function getSelectedItem():Object
        {
            return taskListView.taskGrid.selectedItem;
        }
                   
        /**
         * Gets the currently selected multiple task items
         *  
         * @return currently selected task items
         * 
         */
        public function getSelectedItems():Array
        {
            return taskListView.taskGrid.selectedItems;
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
            var dispatched:Boolean = taskListView.dispatchEvent(clickTaskEvent);                                    
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
        
        /**
         * Handler called for successful call to server for get task list data
         *  
         * @param data task list data result
         * 
         */
        protected function onResultTaskList(data:Object):void
        {
            taskList.initData(data);
            
            taskListView.taskList = this.taskList; 
        }

        /**
         * Handler call for fault return in response to server call for get task list dat
         *  
         * @param info fault info
         * 
         */
        protected function onFaultTaskList(info:Object):void
        {
            trace("onFaultTaskList" + info);            
        }
        
    }
}