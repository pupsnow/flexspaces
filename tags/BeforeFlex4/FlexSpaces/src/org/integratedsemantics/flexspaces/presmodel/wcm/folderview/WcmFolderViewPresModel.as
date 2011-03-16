package org.integratedsemantics.flexspaces.presmodel.wcm.folderview
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmFolderListEvent;
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmTreeDataEvent;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.wcm.folder.WcmFolder;
    import org.integratedsemantics.flexspaces.presmodel.folderview.FolderViewPresModel;
    
    
    /**
     * Presentation model for wcm/avm folder view supporting multiple view modes (icons, detail list, etc.)
     * 
     */
    [Bindable] 
    public class WcmFolderViewPresModel extends FolderViewPresModel
    {
        /**
         * Constructor
         *  
         */
        public function WcmFolderViewPresModel()
        {
            super();            
        }
        
        /**
         * Initialize model 
         * 
         */
        override public function initModel():void
        {
            this.nodeCollection = new WcmFolder();                      
            this.currentPath = "/AVM";           
        }

        /**
         * Getter for the wcm repo folder collection
         *  
         * @return the wcm folder collection
         * 
         */
        public function get wcmFolderCollection():WcmFolder
        {
            return this.nodeCollection as WcmFolder;            
        }       

        /**
         * Setter of the current path of the wcm folder view
         *  
         * @param newPath new path of the folder
         * 
         */
        override public function set currentPath(newPath:String):void
        {
        	setCurrentPath(newPath);	        	
        }
        
        public function setCurrentPath(newPath:String):void
        {
            this.curPath = newPath;
            var folder:Folder = this.nodeCollection as Folder; 
            folder.currentPath = newPath; 
            this.breadCrumbPath = newPath;
            
            if (newPath.length > 4)
            {
                var pathParts:Array = newPath.split("/");
                var storeId:String = pathParts[2];
                var wcmRepoFolderCollection:WcmFolder = this.nodeCollection as WcmFolder;
                wcmRepoFolderCollection.folderNode.storeId = storeId; 
                if (storeId != null)
                {
	                var pathWithoutStoreId:String = "/" + newPath.substr(storeId.length + 6);
	                
	                var responder:Responder = new Responder(onResultGetWcmFolderList, onFaultGetWcmFolderList);
	                var wcmFolderListEvent:WcmFolderListEvent = new WcmFolderListEvent(WcmFolderListEvent.WCM_FOLDER_LIST, responder, 
	                                                                                   storeId, pathWithoutStoreId);
	                wcmFolderListEvent.dispatch();
                }                                
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
            setCurrentPath(this.curPath);       
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
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = showThumbnails;
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
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = showThumbnails;
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