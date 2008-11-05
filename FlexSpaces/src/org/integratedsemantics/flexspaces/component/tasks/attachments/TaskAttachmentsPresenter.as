package org.integratedsemantics.flexspaces.component.tasks.attachments
{
    import flash.events.Event;
    
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.NodeListViewPresenter;
    import org.integratedsemantics.flexspaces.component.menu.contextmenu.ConfigurableContextMenu;
    import org.integratedsemantics.flexspaces.control.event.task.TaskAttachmentsEvent;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.tasks.AttachmentsCollection;


    /**
     * Presenter of list of attached task documents with folder like view display (icons/details modes)
     * 
     * Supervising Presenter/Controller of databoud FolderViewBase views
     */
    public class TaskAttachmentsPresenter extends NodeListViewPresenter
    {
        protected var taskItem:Object;
        
        /**
         * Constructor
         *  
         * @param folderView view to control
         * 
         */
        public function TaskAttachmentsPresenter(folderView:FolderViewBase)
        {
            super(folderView);            
        }
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:Event):void
        {
            super.onCreationComplete(event);
            
            folderView.breadCrumb.visible = false;
            folderView.breadCrumb.includeInLayout = false;
        }
        
        /**
         * Initialize model 
         * 
         */
        override protected function initModel():void
        {
            this.nodeCollection = new AttachmentsCollection();       
        }

        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
            fileContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/" + model.locale + "/contextmenu/taskattachments/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/" + model.locale + "/contextmenu/taskattachments/folderContextMenu.xml");
            
            folderView.folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderView.folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }        

        /**
         * Set the task item to display attachments for
         *  
         * @param taskItem task item
         * 
         */
        public function setTask(taskItem:Object):void
        {
            this.taskItem = taskItem;
            
            var responder:Responder = new Responder(onResultTaskAttachments, onFaultTaskAttachments);
            var taskAttachmentsEvent:TaskAttachmentsEvent = new TaskAttachmentsEvent(TaskAttachmentsEvent.TASK_ATTACHMENTS, responder, taskItem.taskId);
            taskAttachmentsEvent.dispatch();
        }
        
        /**
         * Handler called when get task attachments successfully completed
         * 
         * @param info   task attchments data
         */
        private function onResultTaskAttachments(data:Object):void
        {
            var attachments:AttachmentsCollection = this.nodeCollection as AttachmentsCollection;
            attachments.initData(data);    
            
            folderView.folderGridView.repoFolderCollection = attachments; 
            folderView.folderIconView.repoFolderCollection = attachments;    
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = folderView.showThumbnails;
            }                                                 
        }

        /**
         * Handler called when get task attachments returns fault
         *  
         * @param fault info
         * 
         */
        protected function onFaultTaskAttachments(info:Object):void
        {
            trace("onFaultTaskAttachments" + info);            
        }
    }
}