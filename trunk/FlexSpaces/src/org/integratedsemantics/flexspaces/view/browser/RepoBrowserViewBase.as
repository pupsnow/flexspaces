package org.integratedsemantics.flexspaces.view.browser
{
    import mx.containers.HDividedBox;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.presmodel.browser.RepoBrowserPresModel;
    import org.integratedsemantics.flexspaces.view.createspace.AddedFolderEvent;
    import org.integratedsemantics.flexspaces.view.deletion.DeletedFolderEvent;
    import org.integratedsemantics.flexspaces.view.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewChangePathEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewOnDropEvent;
    import org.integratedsemantics.flexspaces.view.tree.TreeViewBase;
    import org.integratedsemantics.flexspaces.view.versions.versionlist.VersionListViewBase;
    

    /**
     * Base view class for repository tree/dual folder browser views  
     * 
     */
    public class RepoBrowserViewBase extends HDividedBox
    {
        public var treeView:TreeViewBase;
        public var fileView1:FolderViewBase;
        public var fileView2:FolderViewBase;
        public var versionListView:VersionListViewBase;

        [Bindable]
        public var repoBrowserPresModel:RepoBrowserPresModel;
        
                
        /**
         * Constructor 
         */
        public function RepoBrowserViewBase()
        {
            super();
        }        
        
        /**
         * Handle view creation complete initialization
         *  
         * @param event creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            treeView.addEventListener(ListEvent.CHANGE, treeChanged);
            
            fileView1.addEventListener(FolderViewChangePathEvent.FOLDERLIST_CHANGEPATH, onChangePathFolderList1);
            if (fileView2 != null)
            {
                fileView2.addEventListener(FolderViewChangePathEvent.FOLDERLIST_CHANGEPATH, onChangePathFolderList2);
            }
            parentApplication.addEventListener(AddedFolderEvent.ADDED_FOLDER, onAddRemoveFolder);
            parentApplication.addEventListener(DeletedFolderEvent.DELETED_FOLDER, onAddRemoveFolder);
        }
        
        /**
         * Setup context menu handler for folder views
         *  
         * @param handler context menu event handler
         * 
         */
        public function setContextMenuHandler(handler:Function):void
        {
            fileView1.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, handler);
            if (fileView2 != null)
            {
                fileView2.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, handler);
            }   
            if (versionListView != null)
            {         
                versionListView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, handler);
            }            
        }

        /**
         * Setup drag drop onDrop event handler for folder views
         *  
         * @param handler onDrop handler
         * 
         */
        public function setOnDropHandler(handler:Function):void
        {
            fileView1.addEventListener(FolderViewOnDropEvent.FOLDERLIST_ONDROP, handler);
            if (fileView2 != null)
            {
                fileView2.addEventListener(FolderViewOnDropEvent.FOLDERLIST_ONDROP, handler);
            }
        }

        /**
         * Setup up double click doc event handler
         * 
         * @param handler double click doc handler
         * 
         */
        public function setDoubleClickDocHandler(handler:Function):void
        {
            fileView1.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, handler);
            if (fileView2 != null)
            {
                fileView2.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, handler);
            }
            if (versionListView != null)
            {                     
                versionListView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, handler);
            } 
        }

        /**
         * Setup up click node event handler
         * 
         * @param handler click node handler
         * 
         */
        public function setClickNodeHandler(handler:Function):void
        {
            fileView1.addEventListener(ClickNodeEvent.CLICK_NODE, handler);            
            if (fileView2 != null)
            {
                fileView2.addEventListener(ClickNodeEvent.CLICK_NODE, handler);
            }  
            if (versionListView != null)
            {                                           
                versionListView.addEventListener(ClickNodeEvent.CLICK_NODE, handler);
            }                        
        }
        
        public function initPaging():void
        {
            fileView1.initPaging();
            if (fileView2 != null)
            {
                fileView2.initPaging();
            }
        }

        /**
         * Handle toggling the showing the second folder pane 
         * 
         */
        public function showHideSecondRepoFolder():void
        {
            if ((fileView2 != null) && (fileView2.visible == true))
            {
                // unselect things and select fileView1
                if (repoBrowserPresModel.model.flexSpacesPresModel.currentNodeList == repoBrowserPresModel.folderViewPresModel2.nodeCollection)
                {
                    repoBrowserPresModel.model.flexSpacesPresModel.currentNodeList = repoBrowserPresModel.folderViewPresModel1.nodeCollection;
                    clearSelection();
                } 
            }
            
            repoBrowserPresModel.showDualFolders = ! repoBrowserPresModel.showDualFolders;
                
        }
        
        /**
         * Handle redraw request by redrawing the folder views 
         * 
         */
        public function redraw():void
        {
            if (fileView1.visible == true)
            {
                repoBrowserPresModel.folderViewPresModel1.redraw();
            }
            
            if ((fileView2 != null) && (fileView2.visible == true))
            {
                repoBrowserPresModel.folderViewPresModel2.redraw();
            }
        }

        /**
         * Handle clearing the selections of the two folder view 
         * 
         */
        public function clearSelection():void
        {
            fileView1.clearSelection();
            if (fileView2 != null)
            {            
                fileView2.clearSelection();
            }     
            repoBrowserPresModel.model.flexSpacesPresModel.clearSelection();
            
			// since no selection in main folder view, version list should be clear
            repoBrowserPresModel.versionListPresModel.initVersionList(null);	               
        }
        
        /**
         * Handle clearing folder view selection if they are the other selctions
         * and are not the current folder view
         *  
         * @param selectedFolderList selected/current folder view
         * 
         */
        public function clearOtherSelections(selectedFolderList:PresModel):void
        {
            fileView1.clearOtherSelections(selectedFolderList);
            if (fileView2 != null)
            {            
                fileView2.clearOtherSelections(selectedFolderList);
            }  
            if (versionListView != null)
            {                     
                versionListView.clearOtherSelections(selectedFolderList);
            }  
        }
        
        /**
         * Set folder path displayed in the repo browser
         *  
         * @param path path
         * 
         */
        public function setPath(path:String):void
        {
            // select folder in tree
            treeView.setPath(path);  
            
            // select fileView1 and clear item selection
            repoBrowserPresModel.model.flexSpacesPresModel.currentNodeList = repoBrowserPresModel.folderViewPresModel1.nodeCollection;
            clearSelection();                 
        }
        
        /**
         * Enable or disable a context menu item
         *  
         * @param data cmd data of the menu item
         * @param enabled true to enable, false to disable
         * @param fileMenu true for file context menu, false for folder context menu
         * 
         */
        public function enableContextMenuItem(data:String, enabled:Boolean, fileMenu:Boolean):void
        {
            fileView1.enableContextMenuItem(data, enabled, fileMenu);
            if (fileView2 != null)
            {
                fileView2.enableContextMenuItem(data, enabled, fileMenu);
            }
            if (versionListView != null)
            {                     
                versionListView.enableContextMenuItem(data, enabled, fileMenu);
            }
        }

        /**
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            fileView1.showHideThumbnails();
            if (fileView2 != null)
            {
                fileView2.showHideThumbnails();
            } 
        }

        /**
         * Toggle show / hide of version history list view  
         * 
         */
        public function showHideVersionHistory():void
        {
            if ((versionListView != null) && (versionListView.visible == false))
            {
                repoBrowserPresModel.versionListPresModel.initVersionList(fileView1.getSelectedItem());
            }
            
            repoBrowserPresModel.showVersionHistory = ! repoBrowserPresModel.showVersionHistory;
        }

        /**
		 * Initialize version list 
		 * 
		 * @param selectItem selected node to get version history on
		 */
		public function initVersionList(selectedItem:Object):void
		{
			if ((versionListView != null) &&(versionListView.visible == true))
			{
				repoBrowserPresModel.versionListPresModel.initVersionList(selectedItem);				
			}                     			
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
           
            // for now tree only navigates the first folder list
            
            if (repoBrowserPresModel.model.appConfig.cmisMode == false)
            {
                this.fileView1.currentPath = path;
            }
            else
            {
                this.fileView1.resetPaging();
            }   
            
            // select fileView1 and clear item selection
            repoBrowserPresModel.model.flexSpacesPresModel.currentNodeList = repoBrowserPresModel.folderViewPresModel1.nodeCollection;
            clearSelection();   
            
            // fire event to let container know about to new folder path in repo browser
            var changePathEvent:RepoBrowserChangePathEvent = new RepoBrowserChangePathEvent(RepoBrowserChangePathEvent.REPO_BROWSER_CHANGE_PATH, path);
            var dispatched:Boolean = dispatchEvent(changePathEvent);                                        
        }

        /**
         * Handle change in folder path  in the first folder view
         * 
         * @param event change path event
         * 
         */
        protected function onChangePathFolderList1(event:FolderViewChangePathEvent):void
        {
            setPath(event.path);            
        }    
        
        /**
         * Handle change in folder path the second folder view
         * 
         * @param event change path event
         * 
         */
        protected function onChangePathFolderList2(event:FolderViewChangePathEvent):void
        {
            // for now only folder list 1 navigates tree
           
            // select fileView2 and clear item selection
            repoBrowserPresModel.model.flexSpacesPresModel.currentNodeList = repoBrowserPresModel.folderViewPresModel2.nodeCollection;
            clearSelection();           
        }  
        
        /**
         * Handle add remove folder event by also refreshing selected folder parent in tree
         *  
         * @param event add or remove folder event
         * 
         */
        protected function onAddRemoveFolder(event:Event):void
        {
        	if (repoBrowserPresModel.activeView == true)
        	{
				treeView.refreshCurrentFolder();
        	}
        }          

        /**
         * Handle when main view switches to/from the browser view
         * 
         * @param handler double click doc handler
         * 
         */
        public function viewActive(active:Boolean):void
        {
            if (active == true)
            {
                // select main folder pane when the repo browser view in switched to
                repoBrowserPresModel.model.flexSpacesPresModel.currentNodeList = repoBrowserPresModel.folderViewPresModel1.nodeCollection;
            }
            
            repoBrowserPresModel.activeView = active;
            
            clearSelection();
        }
        
    }
}