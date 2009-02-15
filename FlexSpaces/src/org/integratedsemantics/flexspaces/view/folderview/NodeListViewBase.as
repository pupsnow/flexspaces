package org.integratedsemantics.flexspaces.view.folderview
{
    import com.decoursey.components.BreadcrumbDisplay;
    
    import flash.events.Event;
    
    import mx.containers.Canvas;
    import mx.containers.HBox;
    import mx.containers.ViewStack;
    import mx.controls.ComboBox;
    import mx.controls.ToggleButtonBar;
    import mx.events.IndexChangedEvent;
    import mx.events.ItemClickEvent;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.coverflow.CoverFlowViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.folderview.gridview.FolderGridViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.iconview.FolderIconViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.view.folderview.paging.PagerBar;
    import org.integratedsemantics.flexspaces.view.folderview.viewmodebar.ViewModeBarViewBase;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;


    /**
     * Node list view base class 
     * 
     */
    public class NodeListViewBase extends Canvas
    {       
        protected var fileContextMenu:ConfigurableContextMenu;
        protected var folderContextMenu:ConfigurableContextMenu;

        public var breadCrumbAreaBox:HBox;
        public var breadCrumb:BreadcrumbDisplay;
        
        public var viewModeBar:ViewModeBarViewBase;
        
        public var folderViewStack:ViewStack;
        
        public var folderIconView:FolderIconViewBase;
        
        public var folderGridView:FolderGridViewBase;
        
        public var coverFlowView:CoverFlowViewBase;

        [Bindable]
        public var nodeListViewPresModel:NodeListViewPresModel;
        
        [Bindable] public var pager:Pager;
        public var pageBar:PagerBar;
        public var pageSizeCombo:ComboBox;        
        
                  
        /**
         * Constructor 
         * 
         */
        public function NodeListViewBase()
        {
            super();
        }
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            folderGridView.folderGrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, folderListDoubleClick);
            folderGridView.folderGrid.addEventListener(ListEvent.ITEM_CLICK, folderListClick);

            folderIconView.folderTileList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK , folderListDoubleClick);
            folderIconView.folderTileList.addEventListener(ListEvent.ITEM_CLICK, folderListClick);
            
            viewModeBar.toggleButtonBar.addEventListener(ItemClickEvent.ITEM_CLICK, viewButtonClick);
                        
            initContextMenu();                

            nodeListViewPresModel.initModel();
            
            if (nodeListViewPresModel.serverVersionNum >= 3.0)
            {
                coverFlowView.coverFlowDataGrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK , folderListDoubleClick);
                coverFlowView.coverFlowDataGrid.addEventListener(ListEvent.ITEM_CLICK, folderListClick);

                coverFlowView.coverFlowContainer.addEventListener(IndexChangedEvent.CHANGE, coverFlowChange);
                coverFlowView.coverFlowDataGrid.addEventListener(ListEvent.ITEM_CLICK, coverFlowGridClick);
            }
            else
            { 
                //  remove coverflow view mode button (no 3.0 thumbnails service)
                var viewModes:ToggleButtonBar = viewModeBar.toggleButtonBar;              
                viewModes.dataProvider.removeItemAt(2);
            }             
        }
        
        /**
         * Initialize context menu 
         * 
         */
        protected function initContextMenu():void
        {
            // place holder for derived classes
        }        
                
        /**
         * Event handler for icon / detail view mode toggle buttons
         * 
         * @param event item click event
         */ 
        protected function viewButtonClick(event:ItemClickEvent):void
        {
            if (event.index == 0)
            {
                folderViewStack.selectedIndex = 0;
            }
            else if (event.index == 1)
            {
                folderViewStack.selectedIndex = 1;
            }
            else if (event.index == 2)
            {
                folderViewStack.selectedIndex = 2;
            }
            
            clearSelection();
            // have menus updated for no selection
            var clickNodeEvent:ClickNodeEvent = new ClickNodeEvent(ClickNodeEvent.CLICK_NODE, null, this);
            var dispatched:Boolean = dispatchEvent(clickNodeEvent);                        
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
            
            if (selectedItem.isFolder == false)
            {
                // fire event let parents of component know about document double clicked on
                var doubleClickDocEvent:DoubleClickDocEvent = new DoubleClickDocEvent(DoubleClickDocEvent.DOUBLE_CLICK_DOC, selectedItem);
                var dispatched:Boolean = dispatchEvent(doubleClickDocEvent);            
            }
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
            var model:AppModelLocator = nodeListViewPresModel.model;
            
            if (selectedItem != null)
            {
                if (selectedItem.isFolder == true)
                {
                    folderIconView.folderTileList.contextMenu = folderContextMenu.contextMenu;         
                    folderGridView.folderGrid.contextMenu = folderContextMenu.contextMenu; 
                    if (nodeListViewPresModel.serverVersionNum >= 3.0)
                    {                                   
                        coverFlowView.coverFlowDataGrid.contextMenu = folderContextMenu.contextMenu;
                    }                                    
                }
                else
                {
                    folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
                    folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;
                    if (nodeListViewPresModel.serverVersionNum >= 3.0)
                    {
                        coverFlowView.coverFlowDataGrid.contextMenu = fileContextMenu.contextMenu;
                    }
                    
                    var enablePaste:Boolean = (model.flexSpacesPresModel.cut != null) || (model.flexSpacesPresModel.copy != null);
                    enableContextMenuItem("paste", enablePaste, true);  
                } 
                
                // fire event let parents of component know about document / folder clicked on
                var clickNodeEvent:ClickNodeEvent = new ClickNodeEvent(ClickNodeEvent.CLICK_NODE, selectedItem, this);
                var dispatched:Boolean = dispatchEvent(clickNodeEvent);
            }                       
        } 
        

        /**
         * Handle change in the selected node in the coverflow view coverflow
         *  
         * @param event click event
         * 
         */
        protected function coverFlowChange(event:IndexChangedEvent):void
        {
            if (event.newIndex != event.oldIndex)
            {
                // todo: will need change this to handle grid sorting
                coverFlowView.coverFlowDataGrid.selectedIndex = event.newIndex;                
                folderListClick(new Event(""));
            }            
        }

        /**
         * Handle single click on coverflow view grid
         *  
         * @param event click event
         * 
         */
        protected function coverFlowGridClick(event:ListEvent):void
        {
            // todo: will need change this to handle grid sorting
            var index:int = event.rowIndex;
            coverFlowView.coverFlowContainer.selectedIndex = index;    
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
            }
            else
            {
                contextMenu = folderContextMenu;                
            }
            
            contextMenu.enableMenuItem(data, enabled);  
        }
                                
        /**
         * Get selected item (or last selected item if multiple selection
         *  
         * @return selected item 
         * 
         */
        public function getSelectedItem():Object
        {
        	return nodeListViewPresModel.selectedItem;
        }
                   
        /**
         * Get multiple selected items
         *  
         * @return selected items 
         * 
         */
        public function getSelectedItems():Array
        {
        	return nodeListViewPresModel.selectedItems;
        }
        
        /**
         * Clear selection in all view modes 
         * 
         */
        public function clearSelection():void
        {
            nodeListViewPresModel.clearSelection();
            folderIconView.folderTileList.selectedItem = null;
            folderGridView.folderGrid.selectedItem = null;
            if (nodeListViewPresModel.serverVersionNum >= 3.0)
            {            
                coverFlowView.coverFlowDataGrid.selectedItem = null;
            }
        }        

        /**
         * Clear selection if not selected folder presentation model / view 
         * 
         * @param selectedFolderList selected folder presentation model / view
         * 
         */
        public function clearOtherSelections(selectedFolderList:PresModel):void
        {
            if (selectedFolderList != nodeListViewPresModel)
            {
                this.clearSelection();
            }
        }
        
        /**
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            if (nodeListViewPresModel.serverVersionNum >= 3.0)
            {
                nodeListViewPresModel.showThumbnails = ! nodeListViewPresModel.showThumbnails;
                folderIconView.showThumbnails = nodeListViewPresModel.showThumbnails;

                var rowHeight:int;
                var columnWidth:int;
                if (nodeListViewPresModel.showThumbnails == true)
                {
                    rowHeight = 125;
                    columnWidth = 125;
                    //rowHeight = 175;
                    //columnWidth = 200;                    
                }
                else
                {
                    rowHeight = 85;
                    columnWidth = 125;
                }
                folderIconView.folderTileList.rowHeight = rowHeight;
                folderIconView.folderTileList.columnWidth = columnWidth;
                
                // set showThumbnail flags on nodes
                for each (var node:Node in nodeListViewPresModel.nodeCollection)
                {
                    node.showThumbnail = nodeListViewPresModel.showThumbnails;
                }
            }
        }  

        protected function onPageChange(event:Event):void
        {
            requery();     
        }

        protected function requery():void
        {
            // placeholder for override
        }     
        
    }
}