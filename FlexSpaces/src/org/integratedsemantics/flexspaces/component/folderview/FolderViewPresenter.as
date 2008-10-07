package org.integratedsemantics.flexspaces.component.folderview
{
    import com.decoursey.components.event.BreadcrumbDisplayEvent;
    
    import flash.events.Event;
    
    import mx.controls.ToggleButtonBar;
    import mx.events.DragEvent;
    import mx.managers.DragManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewChangePathEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewOnDropEvent;
    import org.integratedsemantics.flexspaces.component.folderview.iconview.FolderIconView;
    import org.integratedsemantics.flexspaces.component.menu.contextmenu.ConfigurableContextMenu;
    import org.integratedsemantics.flexspaces.control.event.FolderListEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;


    /**
     * Presents folder view supporting multiple view modes (icons, detail list, etc.)
     * for a folder
     * 
     * Supervising Presenter/Controller of databound FolderViewBase views
     */
    public class FolderViewPresenter extends NodeListViewPresenter
    {
        // for currentPath property change
        protected var curPath:String;

        /**
         * Constructor 
         * 
         * @param folderView view to control
         */
        public function FolderViewPresenter(folderView:FolderViewBase)
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
            
            folderView.breadCrumb.addEventListener(BreadcrumbDisplayEvent.BREADCRUMB_ACTION, breadCrumbClick);   
            
            folderView.folderGridView.folderGrid.addEventListener(DragEvent.DRAG_DROP, doDragDropDataGrid);

            folderView.folderIconView.folderTileList.addEventListener(DragEvent.DRAG_DROP, doDragDropTileList);    
                        
            if (serverVersionNum >= 3.0)
            {
                folderView.coverFlowView.coverFlowDataGrid.addEventListener(DragEvent.DRAG_DROP, doDragDropCoverFlowDataGrid);
            }
        }
        
        /**
         * Initialize model 
         * 
         */
        override protected function initModel():void
        {
            this.nodeCollection = new Folder();
            this.currentPath = "/";           
        }
        
        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
            fileContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/contextmenu/folderview/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/contextmenu/folderview/folderContextMenu.xml");
            
            folderView.folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderView.folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;    
            
            if (serverVersionNum >= 3.0)
            {
                folderView.coverFlowView.coverFlowDataGrid.contextMenu = fileContextMenu.contextMenu;                    
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
            if (this.curPath != newPath)
            {
                this.curPath = newPath;
                var folder:Folder = this.nodeCollection as Folder;
                folder.currentPath = newPath; 
                folderView.breadCrumb.path = newPath;
                
                var responder:Responder = new Responder(onResultGetFolderList, onFaultGetFolderList);
                var folderListEvent:FolderListEvent = new FolderListEvent(FolderListEvent.FOLDER_LIST, responder, newPath);
                folderListEvent.dispatch();  
                
                folderView.folderGridView.pager.pageIndex = 0;    
                folderView.folderIconView.pager.pageIndex = 0;
                folderView.coverFlowView.pager.pageIndex = 0;                          
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
            return this.curPath;
        }  
        
        
        /**
         * Get node of folder currently viewed
         *  
         * @return folder node
         * 
         */
        public function get currentFolderNode():Node
        {
            var folder:Folder = this.nodeCollection as Folder;
            return folder.folderNode;            
        }   
        
        /**
         * Handle return of folder list data
         * 
         * @param data folder content list data
         * 
         */
        protected function onResultGetFolderList(data:Object):void
        {
            var result:XML = data as XML;                
            var dataPath:String = String(result.path);

            //  when initializing curPath is "/", use company home path we will get back
            var folder:Folder = this.nodeCollection as Folder;
            if (this.curPath == "/")
            {
                this.curPath = dataPath;
                folder.currentPath = dataPath; 
                folderView.breadCrumb.path = dataPath;
            }
            folder.init(data);    
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = folderView.showThumbnails;
            }                    
        }
        
        /**
         * Handler for error on return of folder list data 
         * 
         * @param info fault information
         * 
         */
        protected function onFaultGetFolderList(info:Object):void
        {
            trace("onFaultGetFolderList" + info);            
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
                var dispatched:Boolean = folderView.dispatchEvent(changePathEvent);            
            }
            else
            {
                // fire event let parents of component know about document double clicked on
                var doubleClickDocEvent:DoubleClickDocEvent = new DoubleClickDocEvent(DoubleClickDocEvent.DOUBLE_CLICK_DOC, selectedItem);
                dispatched = folderView.dispatchEvent(doubleClickDocEvent);            
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
            var dispatched:Boolean = folderView.dispatchEvent(changePathEvent);            
        }  

        /**
         * Get latest folder list data from server to redraw with 
         * 
         */
        public function redraw():void
        {
            var responder:Responder = new Responder(onResultGetFolderList, onFaultGetFolderList);
            var folderListEvent:FolderListEvent = new FolderListEvent(FolderListEvent.FOLDER_LIST, responder, this.currentPath);
            folderListEvent.dispatch();                                
        }
                                
        /**
         * Handle drop on tile list view mode
         *  
         * @param event drag event
         * 
         */
        protected function doDragDropTileList(event:DragEvent):void
        {
            folderView.folderIconView.folderTileList.hideDropFeedback(event);
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
            folderView.folderGridView.folderGrid.hideDropFeedback(event);
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
            if (serverVersionNum >= 3.0)
            {            
                folderView.coverFlowView.coverFlowDataGrid.hideDropFeedback(event);
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
            var dispatched:Boolean = folderView.dispatchEvent(e);            
        }
                       
    }
}