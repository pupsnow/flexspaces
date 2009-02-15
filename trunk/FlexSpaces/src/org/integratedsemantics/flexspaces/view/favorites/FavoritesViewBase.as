package org.integratedsemantics.flexspaces.view.favorites
{
    import flash.events.Event;
    
    import mx.events.DragEvent;
    import mx.managers.DragManager;
    
    import org.integratedsemantics.flexspaces.presmodel.favorites.FavoritesPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.NodeListViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewOnDropEvent;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;

	
	/**
	 * View of user's favorites/shortcuts with folder like view display (icons/details modes)
	 * 
	 */
	public class FavoritesViewBase extends NodeListViewBase
	{		
		/**
		 * Constructor 
		 * 
		 */
		public function FavoritesViewBase()
		{
			super();
		}

        /**
         * Getter for the favorites pres model
         *  
         * @return the pres model
         * 
         */
    	[Bindable]
    	public function get favoritesPresModel():FavoritesPresModel
        {
            return this.nodeListViewPresModel as FavoritesPresModel;            
        }       
        
    	public function set favoritesPresModel(favoritesPresModel:FavoritesPresModel):void
        {
            this.nodeListViewPresModel = favoritesPresModel;            
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
            
            // currently the add favorite webscript may be using javascript
            // api added in alfresco 3.0
            if (favoritesPresModel.serverVersionNum >= 3.0)
            {
                folderGridView.folderGrid.addEventListener(DragEvent.DRAG_DROP, doDragDropDataGrid);
                folderIconView.folderTileList.addEventListener(DragEvent.DRAG_DROP, doDragDropTileList);    
                // also need alfresco 3.0 thumbnail service                
                coverFlowView.coverFlowDataGrid.addEventListener(DragEvent.DRAG_DROP, doDragDropCoverFlowDataGrid);
            }                        
        }

        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
        	var srcPath:String = favoritesPresModel.model.appConfig.srcPath;
        	var locale:String = favoritesPresModel.model.appConfig.locale;
        	
            fileContextMenu = new ConfigurableContextMenu(favoritesPresModel, this, srcPath + "config/" + locale + "/contextmenu/favorites/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(favoritesPresModel, this, srcPath + "config/" + locale + "/contextmenu/favorites/folderContextMenu.xml");
            
            folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }        

        /**
         * Handle drop on tile list view mode
         *  
         * @param event drag event
         * 
         */
        protected function doDragDropTileList(event:DragEvent):void
        {
            folderIconView.folderTileList.hideDropFeedback(event);
            doDragDrop(event);               
        }
        
        /**
         * Handle drop on details grid view mode
         *  
         * @param event drag event 
         * 
         */
        protected function doDragDropDataGrid(event:DragEvent):void
        {
            folderGridView.folderGrid.hideDropFeedback(event);
            doDragDrop(event);   
        }

        /**
         * Handle drop on coverflow details grid view mode
         *  
         * @param event drag event 
         * 
         */
        protected function doDragDropCoverFlowDataGrid(event:DragEvent):void
        {
            if (favoritesPresModel.serverVersionNum >= 3.0)
            {            
                coverFlowView.coverFlowDataGrid.hideDropFeedback(event);
                doDragDrop(event);
            }   
        }

        /**
         * Common drop handler for view modes 
         * @param event
         * 
         */
        protected function doDragDrop(event:DragEvent):void
        {
            // prevent default behavior since providing custom behavior
            event.preventDefault(); 

            var action:String = DragManager.COPY;
            if (event.shiftKey == true)
            {
                action = DragManager.MOVE;
            }          

            var e:FolderViewOnDropEvent = new FolderViewOnDropEvent(FolderViewOnDropEvent.FOLDERLIST_ONDROP, action,
                                                                    event.dragSource, this);
            var dispatched:Boolean = dispatchEvent(e);            
        }

        protected function onPageSizeChange(event:Event):void
        {
            favoritesPresModel.model.flexSpacesPresModel.favoritesPageSize = event.target.value;            
            pageBar.curPageIndex = 0;
        }

	}
}