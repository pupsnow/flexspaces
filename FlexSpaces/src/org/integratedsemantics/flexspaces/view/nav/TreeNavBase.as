package org.integratedsemantics.flexspaces.view.nav
{
    import flash.events.Event;
    
    import mx.containers.Box;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.presmodel.tree.TreePresModel;
    import org.integratedsemantics.flexspaces.view.createspace.AddedFolderEvent;
    import org.integratedsemantics.flexspaces.view.deletion.DeletedFolderEvent;
    import org.integratedsemantics.flexspaces.view.tree.TreeViewBase;


    public class TreeNavBase extends Box
    {
        public var treeView:TreeViewBase;

        public var treePresModel:TreePresModel;

        
        public function TreeNavBase()
        {
            super();
            treePresModel = new TreePresModel();   
        }
              
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            // setup tree
            treeView.addEventListener(ListEvent.CHANGE, treeChanged);                                                              
            parentApplication.addEventListener(AddedFolderEvent.ADDED_FOLDER, onAddRemoveFolder);
            parentApplication.addEventListener(DeletedFolderEvent.DELETED_FOLDER, onAddRemoveFolder);                                                                       
        }


        /**
         * Refresh
         * 
         */
        public function refresh():void
        {
        }

        public function redraw():void
        {
            refresh();
        }     
        
        /**
         * Handle tree changed event
         *  
         * @param event tree changed event
         * 
         */
        protected function treeChanged(event:Event):void
        {        
            var path:String = treeView.getPath();
           
            // fire event to let container know about to new folder path selected in tree
            var changePathEvent:TreeChangePathEvent = new TreeChangePathEvent(TreeChangePathEvent.TREE_CHANGE_PATH, path);
            var dispatched:Boolean = dispatchEvent(changePathEvent);                                        
        }
           
        /**
         * Set folder path in tree
         *  
         * @param path path
         * 
         */
        public function setPath(path:String):void
        {
            treeView.setPath(path);              
        }

        /**
         * Get folder path in active tree
         *  
         * @param path path
         * 
         */
        public function getPath():String
        {
            var path:String = null;
            path = treeView.getPath();              
            return path;          
        }


        /**
         * Handle add remove folder event by also refreshing selected folder parent in tree
         *  
         * @param event add or remove folder event
         * 
         */
        protected function onAddRemoveFolder(event:Event):void
        {
            treeView.refreshCurrentFolder();
        }  
        
    }
}