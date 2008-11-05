package org.integratedsemantics.flexspaces.component.wcm.folderview
{
    import flash.events.Event;
    
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewPresenter;
    import org.integratedsemantics.flexspaces.component.menu.contextmenu.ConfigurableContextMenu;
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmFolderListEvent;
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmTreeDataEvent;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.wcm.folder.WcmFolder;
    
    
    /**
     * 
     * Presents wcm/avm folder view supporting multiple view modes (icons, detail list, etc.)
     * 
     * Supervising Presenter/Controller of FolderViewBase views
     * 
     */
    public class WcmFolderViewPresenter extends FolderViewPresenter
    {
        /**
         * Constructor
         *  
         * @param folderView view to control
         * 
         */
        public function WcmFolderViewPresenter(folderView:FolderViewBase)
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
        }
        
        /**
         * Initialize model 
         * 
         */
        override protected function initModel():void
        {
            this.nodeCollection = new WcmFolder();                      
            this.currentPath = "/AVM";           
        }

        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
            fileContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/" + model.locale + "/contextmenu/wcmfolderview/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(this, folderView, model.srcPath + "config/" + model.locale + "/contextmenu/wcmfolderview/folderContextMenu.xml");
            
            folderView.folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderView.folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }        

        /**
         * Setter of the current path of the wcm folder view
         *  
         * @param newPath new path of the folder
         * 
         */
        override public function set currentPath(newPath:String):void
        {
            this.curPath = newPath;
            var folder:Folder = this.nodeCollection as Folder; 
            folder.currentPath = newPath; 
            folderView.breadCrumb.path = newPath;

            if (newPath.length > 4)
            {
                var pathParts:Array = newPath.split("/");
                var storeId:String = pathParts[2];
                var wcmRepoFolderCollection:WcmFolder = this.nodeCollection as WcmFolder;
                wcmRepoFolderCollection.folderNode.storeId = storeId; 
                var pathWithoutStoreId:String = "/" + newPath.substr(storeId.length + 6);
                
                var responder:Responder = new Responder(onResultGetWcmFolderList, onFaultGetWcmFolderList);
                var wcmFolderListEvent:WcmFolderListEvent = new WcmFolderListEvent(WcmFolderListEvent.WCM_FOLDER_LIST, responder, 
                                                                                   storeId, pathWithoutStoreId);
                wcmFolderListEvent.dispatch();                                
            }  
            else
            {
                responder = new Responder(onResultGetStores, onFaultGetStores);
                var wcmTreeDataEvent:WcmTreeDataEvent = new WcmTreeDataEvent(WcmTreeDataEvent.WCM_STORES_DATA, responder);
                wcmTreeDataEvent.dispatch();                                
            }                              
        }
        
        /**
         * Get latest folder list data from server to redraw with 
         * 
         */
        override public function redraw():void
        {
            currentPath = this.curPath;       
        }
                
        /**
         * Handle return of folder list data
         * 
         * @param data folder content list data
         * 
         */
        protected function onResultGetWcmFolderList(data:Object):void
        {
            var wcmFolderCollection:WcmFolder = nodeCollection as WcmFolder;
            wcmFolderCollection.initFolderListData(data);
            
            folderView.folderGridView.repoFolderCollection = wcmFolderCollection; 
            folderView.folderIconView.repoFolderCollection = wcmFolderCollection;         
            
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
        protected function onFaultGetWcmFolderList(info:Object):void
        {
            trace("onFaultGetFolderList" + info);            
        }                                
                                   
        /**
         * Handle return of store list data
         * 
         * @param data store list data
         * 
         */
        protected function onResultGetStores(data:Object):void
        {
            var wcmFolderCollection:WcmFolder = nodeCollection as WcmFolder;
            wcmFolderCollection.initStoreData(data);
            
            folderView.folderGridView.repoFolderCollection = wcmFolderCollection; 
            folderView.folderIconView.repoFolderCollection = wcmFolderCollection;  
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = folderView.showThumbnails;
            }                                                                           
        }
        
        /**
         * Handler for error on return of store list data 
         * 
         * @param info fault information
         * 
         */
        protected function onFaultGetStores(info:Object):void
        {
            trace("onFaultGetStores" + info);            
        }                                

    }
}