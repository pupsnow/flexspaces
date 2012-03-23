package org.integratedsemantics.flexspaces.view.tasks.taskspanel
{
    import flash.events.Event;
    
    import mx.containers.VDividedBox;
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.presmodel.tasks.taskspanel.TasksPanelPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.view.tasks.attachments.TaskAttachmentsViewBase;
    import org.integratedsemantics.flexspaces.view.tasks.event.ClickTaskEvent;
    import org.integratedsemantics.flexspaces.view.tasks.event.RefreshTaskListEvent;
    import org.integratedsemantics.flexspaces.view.tasks.taskcontrol.TaskButtonsViewBase;
    import org.integratedsemantics.flexspaces.view.tasks.tasklist.TaskListViewBase;


    /**
     * Base task panel view class 
     * 
     */
    public class TasksPanelViewBase extends VDividedBox
    {
        public var taskListView:TaskListViewBase;
        
        public var taskButtonsView:TaskButtonsViewBase;
        
        public var taskAttachmentsView:TaskAttachmentsViewBase;
        
        [Bindable]
        public var tasksPanelPresModel:TasksPanelPresModel;

        
        /**
         * Constructor 
         * 
         */
        public function TasksPanelViewBase()
        {
            super();
        }
        
        /**
         * Handle view creation complete initialization
         *  
         * @param event creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            taskListView.addEventListener(ClickTaskEvent.CLICK_TASK, onClickTask);     
            
            taskButtonsView.addEventListener(RefreshTaskListEvent.REFRESH_TASK_LIST, refreshTaskList);                                  
        }

        /**
         * Handle click task event by display task attachments and
         * updating task control bar for task
         *  
         * @param event click task event
         * 
         */
        protected function onClickTask(event:ClickTaskEvent):void
        {
            var selectedItem:Object = event.clickedItem;
            if (selectedItem != null)
            {
                tasksPanelPresModel.taskAttachmentsPresModel.setTask(selectedItem);
                taskButtonsView.setTask(selectedItem);
            }
        }

        /**
         * Setup context menu handler for folder view
         *  
         * @param handler context menu event handler
         * 
         */
        public function setContextMenuHandler(handler:Function):void
        {
            taskAttachmentsView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, handler);
        }

        /**
         * Setup up double click doc event handler
         * 
         * @param handler double click doc handler
         * 
         */
        public function setDoubleClickDocHandler(handler:Function):void
        {
            taskAttachmentsView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, handler);
        }

        /**
         * Setup up click node event handler
         * 
         * @param handler click node handler
         * 
         */
        public function setClickNodeHandler(handler:Function):void
        {
            taskAttachmentsView.addEventListener(ClickNodeEvent.CLICK_NODE, handler);            
        }

        /**
         * Refresh by redrawing task list with new server data 
         * 
         */
        public function refreshTaskList(event:Event=null):void
        {      
        	tasksPanelPresModel.refreshTaskList();  
        }
        
        /**
         * Handle clearing the selection of the folder view 
         * 
         */
        public function clearSelection():void
        {
            taskAttachmentsView.clearSelection();
        }

        /**
         * Handle clearing folder view selection if its not 
         * the current folder view
         *  
         * @param selectedFolderList selected/current folder view
         * 
         */
        public function clearOtherSelections(selectedFolderList:PresModel):void
        {
             taskAttachmentsView.clearOtherSelections(selectedFolderList);
        }       
        
        
    }
}