package org.integratedsemantics.flexspaces.view.tasks.attachments
{
    import flash.events.Event;
    
    import org.integratedsemantics.flexspaces.presmodel.tasks.attachments.TaskAttachmentsPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.NodeListViewBase;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;

	
	public class TaskAttachmentsViewBase extends NodeListViewBase
	{		
		/**
		 * Constructor 
		 * 
		 */
		public function TaskAttachmentsViewBase()
		{
			super();
		}

        /**
         * Getter for the task attachments pres model
         *  
         * @return the pres model
         * 
         */
        [Bindable] 
        public function get taskAttachmentsPresModel():TaskAttachmentsPresModel
        {
            return this.nodeListViewPresModel as TaskAttachmentsPresModel;            
        }       

        public function set taskAttachmentsPresModel(taskAttachmentsPresModel:TaskAttachmentsPresModel):void
        {
            this.nodeListViewPresModel = taskAttachmentsPresModel;            
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
        }

        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
        	var srcPath:String = taskAttachmentsPresModel.model.appConfig.srcPath;
        	var locale:String = taskAttachmentsPresModel.model.appConfig.locale;

            fileContextMenu = new ConfigurableContextMenu(taskAttachmentsPresModel, this, srcPath + "config/" + locale + "/contextmenu/taskattachments/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(taskAttachmentsPresModel, this, srcPath + "config/" + locale + "/contextmenu/taskattachments/folderContextMenu.xml");
            
            folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }  
        
        public function redraw():void
        {
        	taskAttachmentsPresModel.setTask(taskAttachmentsPresModel.taskItem);	
        }    
        
        protected function onPageSizeChange(event:Event):void
        {
            taskAttachmentsPresModel.model.flexSpacesPresModel.taskAttachmentsPageSize = event.target.value;            
            pageBar.curPageIndex = 0;
        }
          
		
	}
}