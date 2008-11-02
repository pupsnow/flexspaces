package org.integratedsemantics.flexspaces.component.browser
{
    import flash.events.Event;
    
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.component.createspace.AddedFolderEvent;
    import org.integratedsemantics.flexspaces.component.deletion.DeletedFolderEvent;
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewPresenter;
    import org.integratedsemantics.flexspaces.component.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewChangePathEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewOnDropEvent;
    import org.integratedsemantics.flexspaces.component.tree.TreePresenter;
    import org.integratedsemantics.flexspaces.component.tree.TreeViewBase;
    import org.integratedsemantics.flexspaces.component.versions.versionlist.VersionListPresenter;
    import org.integratedsemantics.flexspaces.component.versions.versionlist.VersionListViewBase;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;

    
    /**
     * Presenter for repository tree/dual folder browser views
     *    
     * Presenter/Controller for RepoBrowserViewBase views
     * 
     */
    public class RepoBrowserPresenter extends Presenter
    {
        protected var treeView:TreeViewBase;
        protected var fileView1:FolderViewBase;
        protected var fileView2:FolderViewBase;        
        protected var versionListView:VersionListViewBase;
        protected var activeView:Boolean = false;

        public var treePresenter:TreePresenter;
        public var folderViewPresenter1:FolderViewPresenter;
        public var folderViewPresenter2:FolderViewPresenter;
        public var versionListPresenter:VersionListPresenter;

        // Cairngorm model locator                
        [Bindable] protected var model : AppModelLocator = AppModelLocator.getInstance();


        /**
         * Constructor
         *  
         * @param browserView view to control
         * 
         */
        public function RepoBrowserPresenter(browserView:RepoBrowserViewBase)
        {
            super(browserView);
                
            if (browserView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(browserView, onCreationComplete);            
            }
        }

        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get browserView():RepoBrowserViewBase
        {
            return this.view as RepoBrowserViewBase;            
        }       

        /**
         * Handle view creation complete initialization
         *  
         * @param event creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            this.treeView = browserView.treeView;
            this.fileView1 = browserView.fileView1;
            this.fileView2 = browserView.fileView2;
            this.versionListView = browserView.versionListView;
                   
            setupPresenters();
            
            treeView.addEventListener(ListEvent.CHANGE, treeChanged);
            treeView.addEventListener(ListEvent.ITEM_CLICK, treeClicked);           
            fileView1.addEventListener(FolderViewChangePathEvent.FOLDERLIST_CHANGEPATH, onChangePathFolderList1);
            fileView2.addEventListener(FolderViewChangePathEvent.FOLDERLIST_CHANGEPATH, onChangePathFolderList2);
            
            browserView.parentApplication.addEventListener(AddedFolderEvent.ADDED_FOLDER, onAddRemoveFolder);
            browserView.parentApplication.addEventListener(DeletedFolderEvent.DELETED_FOLDER, onAddRemoveFolder);
        }
        
        /**
         * Setup presenters for tree and each folder view 
         * 
         */
        protected function setupPresenters():void
        {
            treePresenter = new TreePresenter(treeView);           
            folderViewPresenter1 = new FolderViewPresenter(this.fileView1);     
            folderViewPresenter2 = new FolderViewPresenter(this.fileView2);   
            versionListPresenter = new VersionListPresenter(this.versionListView);                      
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
            fileView2.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, handler);            
            versionListView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, handler);            
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
            fileView2.addEventListener(FolderViewOnDropEvent.FOLDERLIST_ONDROP, handler);
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
            fileView2.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, handler);
            versionListView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, handler);
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
            fileView2.addEventListener(ClickNodeEvent.CLICK_NODE, handler);                        
            versionListView.addEventListener(ClickNodeEvent.CLICK_NODE, handler);                        
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
                model.currentNodeList = this.folderViewPresenter1.nodeCollection;
            }
            
            activeView = active;
            
            clearSelection();
        }
        
        /**
         * Handle toggling the showing the tree pane 
         * 
         */
        public function showHideRepoTree():void
        {
            if (treeView.visible == true)
            {
                treeView.visible = false;
                treeView.includeInLayout = false;
            }    
            else
            {
                treeView.visible = true;
                treeView.includeInLayout = true;
            }
        }

        /**
         * Handle toggling the showing the second folder pane 
         * 
         */
        public function showHideSecondRepoFolder():void
        {
            if (fileView2.visible == true)
            {
                fileView2.visible = false;
                fileView2.includeInLayout = false;
                
                // unselect things and select fileView1
                
                if (model.currentNodeList == this.folderViewPresenter2.nodeCollection)
                {
                    model.currentNodeList = this.folderViewPresenter1.nodeCollection;
                    clearSelection();
                } 
            }    
            else
            {
                fileView2.visible = true;
                fileView2.includeInLayout = true;
            }
        }

        /**
         * Handle redraw request by redrawing the folder views 
         * 
         */
        public function redraw():void
        {
            if (fileView1.visible == true)
            {
                this.folderViewPresenter1.redraw();
            }
            
            if (fileView2.visible == true)
            {
                this.folderViewPresenter2.redraw();
            }
        }

        /**
         * Handle clearing the selections of the two folder view 
         * 
         */
        public function clearSelection():void
        {
            folderViewPresenter1.clearSelection();
            folderViewPresenter2.clearSelection();     
            model.clearSelection();
            
			// since no selection in main folder view, version list should be clear
            versionListPresenter.initVersionList(null);			               
        }
        
        /**
         * Handle clearing folder view selection if they are the other selctions
         * and are not the current folder view
         *  
         * @param selectedFolderList selected/current folder view
         * 
         */
        public function clearOtherSelections(selectedFolderList:Presenter):void
        {
            folderViewPresenter1.clearOtherSelections(selectedFolderList);
            folderViewPresenter2.clearOtherSelections(selectedFolderList);  
            versionListPresenter.clearOtherSelections(selectedFolderList);  
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
            treePresenter.setPath(path);  
            
            // select fileView1 and clear item selection
            model.currentNodeList = this.folderViewPresenter1.nodeCollection;
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
            folderViewPresenter1.enableContextMenuItem(data, enabled, fileMenu);
            folderViewPresenter2.enableContextMenuItem(data, enabled, fileMenu);
            versionListPresenter.enableContextMenuItem(data, enabled, fileMenu);
        }


        /**
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            folderViewPresenter1.showHideThumbnails();
            folderViewPresenter2.showHideThumbnails(); 
        }


        /**
         * Toggle show / hide of version history list view  
         * 
         */
        public function showHideVersionHistory():void
        {
            if (versionListView.visible == true)
            {
                versionListView.visible = false;
                versionListView.includeInLayout = false;
            }    
            else
            {
                versionListView.visible = true;
                versionListView.includeInLayout = true;
                versionListPresenter.initVersionList(folderViewPresenter1.getSelectedItem());
            }
        }

        /**
		 * Initialize version list 
		 * 
		 * @param selectItem selected node to get version history on
		 */
		public function initVersionList(selectedItem:Object):void
		{
			if (versionListView.visible == true)
			{
				versionListPresenter.initVersionList(selectedItem);				
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
            var path:String = treePresenter.getPath();
            
            // for now tree only navigates the first folder list
            folderViewPresenter1.currentPath =  path;   
            
            // select fileView1 and clear item selection
            model.currentNodeList = this.folderViewPresenter1.nodeCollection;
            clearSelection();   
            
            // fire event to let container know about to new folder path in repo browser
            var changePathEvent:RepoBrowserChangePathEvent = new RepoBrowserChangePathEvent(RepoBrowserChangePathEvent.REPO_BROWSER_CHANGE_PATH, path);
            var dispatched:Boolean = browserView.dispatchEvent(changePathEvent);                                
        }

        protected var prevItem:Object;
        
        /**
         * Handle toggling open tree folder on clicks
         *  
         * @param event tree click event
         * 
         */
        protected function treeClicked(event:Event):void
        {
            var toggle:Boolean = treeView.isItemOpen(treeView.selectedItem);
            if (toggle == true)
            {
                if (treeView.selectedItem == prevItem)
                {
                    treePresenter.expandItem(treeView.selectedItem, false, false);
                }
            } 
            else
            {
                treePresenter.expandItem(treeView.selectedItem, true, false);
            }
            
            prevItem = treeView.selectedItem;
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
            model.currentNodeList = this.folderViewPresenter2.nodeCollection;
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
        	if (activeView == true)
        	{
				treePresenter.refreshCurrentFolder();
        	}
        }          

    }
}