 
package org.integratedsemantics.flexspaces.component.versions.versionlist
{
    import flash.events.Event;
    
    import mx.events.ListEvent;
    import mx.printing.*;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.component.menu.contextmenu.ConfigurableContextMenu;
    import org.integratedsemantics.flexspaces.control.event.VersionListEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.versionlist.VersionHistoryCollection;


	/**
	 * Presenter of version history for doc node with folder like view display (icons/details modes)
	 * 
	 * Supervising Presenter/Controller of databoud FolderViewBase views
	 * 
	 */	 	
	public class VersionListPresenter extends Presenter
	{
		protected var selectedNode:IRepoNode = null;
	    		    
        [Bindable]
        public var nodeCollection:NodeCollection;
        
        protected var fileContextMenu:ConfigurableContextMenu;

        protected var model:AppModelLocator = AppModelLocator.getInstance();

        
	    /**
	     * Constructor 
	     * 
	     * @param folderView view to control
	     */
	    public function VersionListPresenter(versionListView:VersionListViewBase)
	    {
            super(versionListView);
                        
            if (versionListView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(versionListView, onCreationComplete);            
            }
        }
     	
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get versionListView():VersionListViewBase
        {
            return this.view as VersionListViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            versionListView.versionListGrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, folderListDoubleClick);
            versionListView.versionListGrid.addEventListener(ListEvent.ITEM_CLICK, folderListClick);
                                    
            initContextMenu();                

            initModel();
            versionListView.repoFolderCollection = this.nodeCollection; 
        }

        
        /**
         * Initialize model 
         * 
         */
        protected function initModel():void
        {
            this.nodeCollection = new VersionHistoryCollection();       
        }

        /**
         * Initialize context menus 
         * 
         */
        protected function initContextMenu():void
        {
            fileContextMenu = new ConfigurableContextMenu(this, versionListView, model.srcPath + "config/" + model.locale + "/contextmenu/versionlist/fileContextMenu.xml");
            
            versionListView.versionListGrid.contextMenu = fileContextMenu.contextMenu;    
        }        

        /**
         * Handle double click on an item
         *  
         * @param event double click event
         * 
         */
        protected function folderListDoubleClick(event:Event):void
        {
            var selectedItem:Object = getSelectedItem();
            
            // fire event let parents of component know about document double clicked on
            var doubleClickDocEvent:DoubleClickDocEvent = new DoubleClickDocEvent(DoubleClickDocEvent.DOUBLE_CLICK_DOC, selectedItem);
            var dispatched:Boolean = versionListView.dispatchEvent(doubleClickDocEvent);            
        }

        /**
         * Handle single click on an item
         *  
         * @param event click event
         * 
         */
        protected function folderListClick(event:Event):void
        {
            var selectedItem:Object = getSelectedItem();
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            if (selectedItem != null)
            {
                versionListView.versionListGrid.contextMenu = fileContextMenu.contextMenu;
                
                // fire event let parents of component know about document / folder clicked on
                var clickNodeEvent:ClickNodeEvent = new ClickNodeEvent(ClickNodeEvent.CLICK_NODE, selectedItem, this);
                var dispatched:Boolean = versionListView.dispatchEvent(clickNodeEvent);
            }                       
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
            if (fileMenu == true)
            {
                var contextMenu:ConfigurableContextMenu = fileContextMenu;
	            contextMenu.enableMenuItem(data, enabled);  
            }            
        }

        /**
         * Get selected item (or last selected item if multiple selection
         *  
         * @return selected item 
         * 
         */
        public function getSelectedItem():Object
        {
	        return versionListView.versionListGrid.selectedItem;
        }
                   
        /**
         * Get multiple selected items
         *  
         * @return selected items 
         * 
         */
        public function getSelectedItems():Array
        {
            return versionListView.versionListGrid.selectedItems;
        }
        
        /**
         * Clear selection in all view modes 
         * 
         */
        public function clearSelection():void
        {
            versionListView.versionListGrid.selectedItem = null;
        }        

        /**
         * Clear selection if not selected folder presenter/view 
         * 
         * @param selectedFolderList selected folder presenter/view
         * 
         */
        public function clearOtherSelections(selectedFolderList:Presenter):void
        {
            if (selectedFolderList != this)
            {
                this.clearSelection();
            }
        }

        /**
		 * Initialize version list 
		 * 
		 * @param selectItem selected node to get version history on
		 */
		public function initVersionList(selectedItem:Object):void
		{
			this.selectedNode = selectedItem as IRepoNode;
			
			if (selectedNode != null)
			{
				if (selectedNode.getIsFolder() == true)
				{
					// have empty version list for folders
					this.nodeCollection = new VersionHistoryCollection();
	            	versionListView.repoFolderCollection = this.nodeCollection; 
				}
				else
				{
					// get doc version history
		            var responder:Responder = new Responder(onResultVersionList, onFaultVersionList);
		            var versionListEvent:VersionListEvent = new VersionListEvent(VersionListEvent.VERSION_LIST, responder, selectedNode);
		            versionListEvent.dispatch();
	   			}
   			} 
   			else
   			{
				// have empty version list for when no node selected in main folder view
				this.nodeCollection = new VersionHistoryCollection();
            	versionListView.repoFolderCollection = this.nodeCollection; 
        	}                       			
		}		
		
        /**
         * Handler called for successful call to server for get version list
         *  
         * @param data version list data result
         * 
         */
        protected function onResultVersionList(data:Object):void
        {
		    var resultsCollection:VersionHistoryCollection = this.nodeCollection as VersionHistoryCollection; 
		    resultsCollection.initData(data);
		    
            versionListView.repoFolderCollection = resultsCollection; 
        }

        /**
         * Handler call for fault return in response to server call for get version list
         *  
         * @param info fault info
         * 
         */
        protected function onFaultVersionList(info:Object):void
        {
            trace("onFaultVersionList" + info);            
        }
				
     }
}