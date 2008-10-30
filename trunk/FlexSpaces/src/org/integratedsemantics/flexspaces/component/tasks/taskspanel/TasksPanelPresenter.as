package org.integratedsemantics.flexspaces.component.tasks.taskspanel
{
    import flash.events.Event;
    
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.NodeListViewPresenter;
    import org.integratedsemantics.flexspaces.component.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.component.tasks.attachments.TaskAttachmentsPresenter;
    import org.integratedsemantics.flexspaces.component.tasks.event.ClickTaskEvent;
    import org.integratedsemantics.flexspaces.component.tasks.event.RefreshTaskListEvent;
    import org.integratedsemantics.flexspaces.component.tasks.taskcontrol.TaskButtonsPresenter;
    import org.integratedsemantics.flexspaces.component.tasks.taskcontrol.TaskButtonsViewBase;
    import org.integratedsemantics.flexspaces.component.tasks.tasklist.TaskListPresenter;
    import org.integratedsemantics.flexspaces.component.tasks.tasklist.TaskListViewBase;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;

    
    /**
     * Presenter for panel with task list, task approval buttons, list of task attachments 
     *
     * Presenter/Controller for TasksPanelViewBase views
     *  
     */
    public class TasksPanelPresenter extends Presenter
    {
        public var taskAttachmentsPresenter:TaskAttachmentsPresenter;

        protected var taskListView:TaskListViewBase;        
        protected var taskButtonsView:TaskButtonsViewBase;       
        protected var taskAttachmentsView:FolderViewBase;

        protected var taskListPresenter:TaskListPresenter;
        protected var taskButtonsPresenter:TaskButtonsPresenter;  

        
        /**
         * Constructor
         *  
         * @param tasksPanelView view to control
         * 
         */
        public function TasksPanelPresenter(tasksPanelView:TasksPanelViewBase)
        {
            super(tasksPanelView);
            
            if (tasksPanelView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(tasksPanelView, onCreationComplete);            
            }
        }        
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get tasksPanelView():TasksPanelViewBase
        {
            return this.view as TasksPanelViewBase;            
        }       

        /**
         * Handle view creation complete initialization
         *  
         * @param event creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            this.taskListView = tasksPanelView.taskListView;   
            this.taskButtonsView = tasksPanelView.taskButtonsView;
            this.taskAttachmentsView = tasksPanelView.taskAttachmentsView;

            taskListPresenter = new TaskListPresenter(taskListView);
            taskButtonsPresenter = new TaskButtonsPresenter(taskButtonsView);
            taskAttachmentsPresenter = new TaskAttachmentsPresenter(taskAttachmentsView);     
                               
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
                this.taskAttachmentsPresenter.setTask(selectedItem);
                this.taskButtonsPresenter.setTask(selectedItem);
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
         * Handle clearing the selection of the folder view 
         * 
         */
        public function clearSelection():void
        {
            this.taskAttachmentsPresenter.clearSelection();
        }

        /**
         * Handle clearing folder view selection if its not 
         * the current folder view
         *  
         * @param selectedFolderList selected/current folder view
         * 
         */
        public function clearOtherSelections(selectedFolderList:Presenter):void
        {
             taskAttachmentsPresenter.clearOtherSelections(selectedFolderList);
        }       

        /**
         * Refresh by redrawing task list with new server data 
         * 
         */
        public function refreshTaskList(event:Event=null):void
        {        
            if (this.taskListPresenter != null)
            {
                this.taskListPresenter.redraw();
            }
        }
        
    }
}