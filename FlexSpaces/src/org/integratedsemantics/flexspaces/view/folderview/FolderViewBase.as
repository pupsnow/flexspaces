package org.integratedsemantics.flexspaces.view.folderview
{
    import com.decoursey.components.event.BreadcrumbDisplayEvent;
    
    import flash.events.Event;
    
    import mx.binding.utils.ChangeWatcher;
    import mx.events.DragEvent;
    import mx.managers.DragManager;
    
    import org.integratedsemantics.flexspaces.presmodel.folderview.FolderViewPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewChangePathEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewOnDropEvent;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;
    import org.integratedsemantics.flexspaces.view.wcm.folderview.WcmFolderViewBase;


    /**
     * Folder view base class 
     * 
     */
    public class FolderViewBase extends NodeListViewBase
    {          	
        /**
         * Constructor 
         * 
         */
        public function FolderViewBase()
        {
            super();
        }        

        /**
         * Getter for the folder view pres model
         *  
         * @return the pres model
         * 
         */
    	[Bindable]
    	public function get folderViewPresModel():FolderViewPresModel
        {
            return this.nodeListViewPresModel as FolderViewPresModel;            
        }       

    	public function set folderViewPresModel(folderViewPresModel:FolderViewPresModel):void
        {
            this.nodeListViewPresModel = folderViewPresModel;            
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
            
            breadCrumb.addEventListener(BreadcrumbDisplayEvent.BREADCRUMB_ACTION, breadCrumbClick);   
            folderGridView.folderGrid.addEventListener(DragEvent.DRAG_DROP, doDragDropDataGrid);

            folderIconView.folderTileList.addEventListener(DragEvent.DRAG_DROP, doDragDropTileList);    
                        
            if (folderViewPresModel.serverVersionNum >= 3.0)
            {
                coverFlowView.coverFlowDataGrid.addEventListener(DragEvent.DRAG_DROP, doDragDropCoverFlowDataGrid);
            }               
        }

        public function initPaging():void
        {
            ChangeWatcher.watch(pageBar, "curPageIndex", onPageChange);            
            pager.clientSidePage = false;             
        }
        
        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
        	var srcPath:String = folderViewPresModel.model.appConfig.srcPath;
        	var locale:String = folderViewPresModel.model.appConfig.locale;
            fileContextMenu = new ConfigurableContextMenu(folderViewPresModel, this, srcPath + "config/" + locale + "/contextmenu/folderview/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(folderViewPresModel, this, srcPath + "config/" + locale + "/contextmenu/folderview/folderContextMenu.xml");
            
            folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;    
            
            if (folderViewPresModel.serverVersionNum >= 3.0)
            {
                coverFlowView.coverFlowDataGrid.contextMenu = fileContextMenu.contextMenu;                    
            }
        }        

        /**
         * Setter of the current path of the folder view
         *  
         * @param newPath new path of the folder
         * 
         */
        public function set currentPath(newPath:String):void
        {
            if (currentPath != newPath)
            {            	
                folderViewPresModel.currentPath = newPath;
           
                pager.pageIndex = 0;    
            }
        }

        /**
         * Getter for current folder path
         * 
         * @return current folder path
         * 
         */
        public function get currentPath():String
        {
            return folderViewPresModel.currentPath;
        }
        
        /**
         * Handle double click on an item
         *  
         * @param event double click event
         * 
         */
        override protected function folderListDoubleClick(event:Event):void
        {
            var selectedItem:Object = getSelectedItem();
            
            if (selectedItem.isFolder == true)
            {
                // navigate into folder double clicked on
                this.currentPath = selectedItem.displayPath;
                
                // fire event to let parents of component know about navigation of folder list to new folder path
                var changePathEvent:FolderViewChangePathEvent = new FolderViewChangePathEvent(FolderViewChangePathEvent.FOLDERLIST_CHANGEPATH, 
                                                                                              this.currentPath);
                var dispatched:Boolean = dispatchEvent(changePathEvent);            
            }
            else
            {
                // fire event let parents of component know about document double clicked on
                var doubleClickDocEvent:DoubleClickDocEvent = new DoubleClickDocEvent(DoubleClickDocEvent.DOUBLE_CLICK_DOC, selectedItem);
                dispatched = dispatchEvent(doubleClickDocEvent);            
            }
        }
                
        /**
         * Handle navigating folder path when bread crumb is used
         *  
         * @param event bread crumb event
         * 
         */
        protected function breadCrumbClick(event:BreadcrumbDisplayEvent):void
        {
            this.currentPath = event.path;
            
            // fire event to let user of component know about navigation of folder list to new folder path
            var changePathEvent:FolderViewChangePathEvent = new FolderViewChangePathEvent(FolderViewChangePathEvent.FOLDERLIST_CHANGEPATH, 
                                                                                          this.currentPath);
            var dispatched:Boolean = dispatchEvent(changePathEvent);            
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
            if (folderViewPresModel.serverVersionNum >= 3.0)
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
        
        override protected function requery():void
        {
            var pageSize:int = folderViewPresModel.model.flexSpacesPresModel.docLibPageSize;
            var pageNum:int = pageBar.curPageIndex;
            folderViewPresModel.requery(pageSize, pageNum);                
        }

        protected function onPageSizeChange(event:Event):void
        {
            folderViewPresModel.model.flexSpacesPresModel.docLibPageSize = event.target.value;
            
            pageBar.curPageIndex = 0;
            requery();
        }
        
    }
}