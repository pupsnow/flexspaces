package org.integratedsemantics.flexspaces.view.versions.versionlist
{   
    import flash.events.Event;
    
    import mx.containers.VBox;
    import mx.controls.DataGrid;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.presmodel.versions.versionlist.VersionListPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;

        
    /**
     * Folder grid base view class 
     * 
     */
    public class VersionListViewBase extends  VBox
    {
        public var versionListGrid:DataGrid;

        [Bindable]
        public var versionListPresModel:VersionListPresModel;
                
        protected var fileContextMenu:ConfigurableContextMenu;

        
        /**
         * Constructor 
         * 
         */
        public function VersionListViewBase()
        {
            super();
        }
        
        /**
         * Handle creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            versionListGrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, folderListDoubleClick);
            versionListGrid.addEventListener(ListEvent.ITEM_CLICK, folderListClick);
                                    
            initContextMenu();                

            versionListPresModel.initModel();
        }
        
        /**
         * Initialize context menus 
         * 
         */
        protected function initContextMenu():void
        {
        	var srcPath:String = versionListPresModel.model.appConfig.srcPath;
        	var locale:String = versionListPresModel.model.appConfig.locale;
            fileContextMenu = new ConfigurableContextMenu(versionListPresModel, this, srcPath + "config/" + locale + "/contextmenu/versionlist/fileContextMenu.xml");
            
            versionListGrid.contextMenu = fileContextMenu.contextMenu;    
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
            var dispatched:Boolean = dispatchEvent(doubleClickDocEvent);            
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
            
            if (selectedItem != null)
            {
                versionListGrid.contextMenu = fileContextMenu.contextMenu;
                
                // fire event let parents of component know about document / folder clicked on
                var clickNodeEvent:ClickNodeEvent = new ClickNodeEvent(ClickNodeEvent.CLICK_NODE, selectedItem, this);
                var dispatched:Boolean = dispatchEvent(clickNodeEvent);
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
	        return versionListGrid.selectedItem;
        }
                   
        /**
         * Get multiple selected items
         *  
         * @return selected items 
         * 
         */
        public function getSelectedItems():Array
        {
            return versionListGrid.selectedItems;
        }
        
        /**
         * Clear selection in all view modes 
         * 
         */
        public function clearSelection():void
        {
            versionListGrid.selectedItem = null;
        }        

        /**
         * Clear selection if not selected folder presentation model / view 
         * 
         * @param selectedFolderList selected folder presentation model / view
         * 
         */
        public function clearOtherSelections(selectedFolderList:PresModel):void
        {
            if (selectedFolderList != versionListPresModel)
            {
                this.clearSelection();
            }
        }
        
    }
}