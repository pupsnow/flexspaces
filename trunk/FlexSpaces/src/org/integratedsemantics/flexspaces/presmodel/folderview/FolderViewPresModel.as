package org.integratedsemantics.flexspaces.presmodel.folderview
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.FolderListEvent;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;


    /**
     * Presentation model for folder views supporting multiple view modes (icons, detail list, etc.)
     * for a folder
     * 
     */
    [Bindable] 
    public class FolderViewPresModel extends NodeListViewPresModel
    {        
        public var breadCrumbPath:String;

        // for currentPath property change
        protected var curPath:String;


        /**
         * Constructor 
         * 
         */
        public function FolderViewPresModel()
        {            
            super();                        
        }
                
        /**
         * Initialize model 
         * 
         */
        override public function initModel():void
        {
            this.nodeCollection = new Folder();
            this.currentPath = "/";
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
                this.breadCrumbPath = newPath;
                
                var responder:Responder = new Responder(onResultGetFolderList, onFaultGetFolderList);
                var folderListEvent:FolderListEvent = new FolderListEvent(FolderListEvent.FOLDER_LIST, responder, newPath);
                folderListEvent.dispatch();                  
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
         * Handle return of folder list data
         * 
         * @param data folder content list data
         * 
         */
        protected function onResultGetFolderList(data:Object):void
        {
            var result:Folder = data as Folder;                
            var dataPath:String = String(result.folderNode.path);

            //  when initializing curPath is "/", use company home path we will get back
            var folder:Folder = this.nodeCollection as Folder;
            if (this.curPath == "/")
            {
                this.curPath = dataPath;
                folder.currentPath = dataPath; 
                breadCrumbPath = dataPath;
            }
            folder.init(data);    
            
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
        protected function onFaultGetFolderList(info:Object):void
        {
            trace("onFaultGetFolderList" + info);            
        }
                                                                     
    }
}