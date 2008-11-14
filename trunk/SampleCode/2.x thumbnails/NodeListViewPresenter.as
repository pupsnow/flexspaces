package org.integratedsemantics.flexspaces.component.folderview
{
    import flash.events.Event;
    
    import mx.controls.ToggleButtonBar;
    import mx.events.IndexChangedEvent;
    import mx.events.ItemClickEvent;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.component.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.component.menu.contextmenu.ConfigurableContextMenu;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;


    /**
     * Presents folder like view supporting multiple view modes (icons, detail list, etc.)
     * for any list of nodes such as search results, task attachments, etc.
     * 
     * Supervising Presenter/Controller of databound FolderViewBase views
     */
    public class NodeListViewPresenter extends Presenter
    {
        [Bindable]
        public var nodeCollection:NodeCollection
        
        protected var fileContextMenu:ConfigurableContextMenu;
        protected var folderContextMenu:ConfigurableContextMenu;

        protected var model:AppModelLocator = AppModelLocator.getInstance();
        protected var serverVersionNum:Number;
        
        /**
         * Constructor 
         * 
         * @param folderView view to control
         */
        public function NodeListViewPresenter(folderView:FolderViewBase)
        {
            super(folderView);
                        
            if (folderView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(folderView, onCreationComplete);            
            }
        }
        
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get folderView():FolderViewBase
        {
            return this.view as FolderViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            folderView.folderGridView.folderGrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, folderListDoubleClick);
            folderView.folderGridView.folderGrid.addEventListener(ListEvent.ITEM_CLICK, folderListClick);

            folderView.folderIconView.folderTileList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK , folderListDoubleClick);
            folderView.folderIconView.folderTileList.addEventListener(ListEvent.ITEM_CLICK, folderListClick);
            
            folderView.viewModeBar.toggleButtonBar.addEventListener(ItemClickEvent.ITEM_CLICK, viewButtonClick);
                        
            initContextMenu();                

            initModel();
            folderView.folderGridView.repoFolderCollection = this.nodeCollection; 
            folderView.folderIconView.repoFolderCollection = this.nodeCollection;                                                                        
            
            serverVersionNum = model.serverVersionNum();
            if (serverVersionNum >= 3.0)
            {
                folderView.coverFlowView.coverFlowDataGrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK , folderListDoubleClick);
                folderView.coverFlowView.coverFlowDataGrid.addEventListener(ListEvent.ITEM_CLICK, folderListClick);
                folderView.coverFlowView.repoFolderCollection = this.nodeCollection;    

                folderView.coverFlowView.coverFlowContainer.addEventListener(IndexChangedEvent.CHANGE, coverFlowChange);
                folderView.coverFlowView.coverFlowDataGrid.addEventListener(ListEvent.ITEM_CLICK, coverFlowGridClick);
            }
            else
            { 
                // remove coverflow view mode button
                var viewModes:ToggleButtonBar = folderView.viewModeBar.toggleButtonBar;              
                viewModes.dataProvider.removeItemAt(2);
            }                  
                                                                                
        }
        
        /**
         * Initialize model 
         * 
         */
        protected function initModel():void
        {            
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
                folderView.folderViewStack.selectedIndex = 0;
            }
            else if (event.index == 1)
            {
                folderView.folderViewStack.selectedIndex = 1;
            }
            else if (event.index == 2)
            {
                folderView.folderViewStack.selectedIndex = 2;
            }
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
                var dispatched:Boolean = folderView.dispatchEvent(doubleClickDocEvent);            
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
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            if (selectedItem != null)
            {
                if (selectedItem.isFolder == true)
                {
                    folderView.folderIconView.folderTileList.contextMenu = folderContextMenu.contextMenu;         
                    folderView.folderGridView.folderGrid.contextMenu = folderContextMenu.contextMenu; 
                    if (serverVersionNum >= 3.0)
                    {                                   
                        folderView.coverFlowView.coverFlowDataGrid.contextMenu = folderContextMenu.contextMenu;
                    }                                    
                }
                else
                {
                    folderView.folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
                    folderView.folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;
                    if (serverVersionNum >= 3.0)
                    {
                        folderView.coverFlowView.coverFlowDataGrid.contextMenu = fileContextMenu.contextMenu;
                    }
                    
                    var enablePaste:Boolean = (model.cut != null) || (model.copy != null);
                    enableContextMenuItem("paste", enablePaste, true);  
                } 
                
                // fire event let parents of component know about document / folder clicked on
                var clickNodeEvent:ClickNodeEvent = new ClickNodeEvent(ClickNodeEvent.CLICK_NODE, selectedItem, this);
                var dispatched:Boolean = folderView.dispatchEvent(clickNodeEvent);
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
                folderView.coverFlowView.coverFlowDataGrid.selectedIndex = event.newIndex;                
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
            folderView.coverFlowView.coverFlowContainer.selectedIndex = index;    
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
            if (folderView.folderViewStack.selectedIndex == 0)
            {
                return folderView.folderIconView.folderTileList.selectedItem;
            } 
            else if (folderView.folderViewStack.selectedIndex == 1)
            {
                return folderView.folderGridView.folderGrid.selectedItem;
            }
            else
            {
                if (serverVersionNum >= 3.0)
                {
                    return folderView.coverFlowView.coverFlowDataGrid.selectedItem;
                }
                else
                {
                    return null;
                }
            }
        }
                   
        /**
         * Get multiple selected items
         *  
         * @return selected items 
         * 
         */
        public function getSelectedItems():Array
        {
            if (folderView.folderViewStack.selectedIndex == 0)
            {
                return folderView.folderIconView.folderTileList.selectedItems;
            } 
            else if (folderView.folderViewStack.selectedIndex == 1)
            {
                return folderView.folderGridView.folderGrid.selectedItems;
            }
            else
            {
                if (serverVersionNum >= 3.0)
                {
                    return folderView.coverFlowView.coverFlowDataGrid.selectedItems;
                }
                else
                {
                    return null;
                }
            }
        }
        
        /**
         * Clear selection in all view modes 
         * 
         */
        public function clearSelection():void
        {
            folderView.folderIconView.folderTileList.selectedItem = null;
            folderView.folderGridView.folderGrid.selectedItem = null;
            if (serverVersionNum >= 3.0)
            {            
                folderView.coverFlowView.coverFlowDataGrid.selectedItem = null;
            }
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
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            var model:AppModelLocator = AppModelLocator.getInstance();
            var serverVersionNum:Number = model.serverVersionNum();
            // chanage for thumbnails from thumbnails forge project
            //if (serverVersionNum >= 3.0)
            //{
                folderView.showThumbnails = ! folderView.showThumbnails;
                folderView.folderIconView.showThumbnails = folderView.showThumbnails;

                var rowHeight:int;
                if (folderView.showThumbnails == true)
                {
                    rowHeight = 125;
                }
                else
                {
                    rowHeight = 85;
                }
                folderView.folderIconView.folderTileList.rowHeight = rowHeight;
                
                // set showThumbnail flags on nodes
                for each (var node:Node in nodeCollection)
                {
                    node.showThumbnail = folderView.showThumbnails;
                }
            //}
        }        
                       
    }
}