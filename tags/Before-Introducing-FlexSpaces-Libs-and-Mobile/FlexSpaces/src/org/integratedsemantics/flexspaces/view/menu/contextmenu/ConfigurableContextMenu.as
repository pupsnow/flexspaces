package org.integratedsemantics.flexspaces.view.menu.contextmenu
{
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuBuiltInItems;
    import flash.ui.ContextMenuItem;
    
    import mx.collections.XMLListCollection;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.view.menu.event.MenuConfiguredEvent;

    
    /**
     * File/Folder context menu for folder view
     * Note: ContextMenu class is final so can't derive from it. 
     * 
     */
    public class ConfigurableContextMenu
    {
        protected var folderViewPresModel:PresModel;
        protected var folderView:Object;
        
        public var contextMenu:ContextMenu;
        
        // use associative array features for lookup of menu item data with menu caption as key
        public var captionToDataMap:Object = new Object();
        public var dataToMenuMap:Object = new Object();
        
        public var configFilePath:String;
        
        [Bindable]
        protected var menuCollection:XMLListCollection;
        
        protected var loader:URLLoader;

        
        /**
         * Constructor
         *  
         * @param folderViewPresModel presentation model of folder view
         * @param folderView folder view
         * 
         */
        public function ConfigurableContextMenu(folderViewPresModel:PresModel, folderView:Object, configFilePath:String)
        {
            this.folderViewPresModel = folderViewPresModel;
            this.folderView = folderView;            
            this.configFilePath = configFilePath;
            
            this.menuCollection = new XMLListCollection();       

            this.contextMenu = new ContextMenu();
            
            this.loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onLoadSuccess);   
            load();                        
        }
        
        /**
         * Enable or disable menu item 
         * 
         * @param data menu cmd data to identify menu
         * @param enable true to enable, false to disable
         * 
         */
        public function enableMenuItem(data:String, enable:Boolean):void
        {
            var menuItem:ContextMenuItem = dataToMenuMap[data] as ContextMenuItem;
            if (menuItem != null)
            {
                menuItem.enabled = enable;
            }    
        }
        
        /**
         * Creates context menu for folder view
         *  
         * @return ContextMenu
         * 
         */
        protected function initContextMenu():void
        {                                   
            contextMenu.hideBuiltInItems();

            var menuItems:Array = new Array();

            for each (var xmlMenuItem:XML in menuCollection)
            {
                var label:String = xmlMenuItem.@label;
                
                var data:String = xmlMenuItem.@data;
                
                var seperatorBefore:String = xmlMenuItem.@seperatorBefore;
                
                var builtIn:String = xmlMenuItem.@builtIn;
                
                createMenuItem(label, data, contextMenuHandler, menuItems, seperatorBefore=="true", builtIn=="true");
            }
            
            contextMenu.customItems = menuItems;   
            
            var event:MenuConfiguredEvent = new MenuConfiguredEvent(MenuConfiguredEvent.MENU_CONFIGURED);
            folderView.dispatchEvent(event);
        }

        /**
         * Create menu item 
         * 
         * @param label menu lablel
         * @param data menu data
         * @param listener menu item listener
         * @param items items array to add it to
         * 
         */
        protected function createMenuItem(label:String, data:String, listener:Function, items:Array, 
                                          seperatorBefore:Boolean=false, builtIn:Boolean=false):void
        {
            if (builtIn == true)
            {
                var defaultItems:ContextMenuBuiltInItems = contextMenu.builtInItems;
                // todo: add support for adding back any built in items or edit menu items
                // for now using different wording for edit menus to allow them to be added as custom           
            }
            else
            {
                var menuItem:ContextMenuItem = new ContextMenuItem(label, seperatorBefore);                               
                items.push(menuItem);            
            }

            // use associative array features for lookup of menu item data with menu caption as key
            captionToDataMap[label] = data;
            dataToMenuMap[data] = menuItem;

            menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, listener);                     
        }
         
        /**
         * Handler for context menus
         * 
         * @param event context menu event
         * 
         */
        protected function contextMenuHandler(event:ContextMenuEvent):void
        {
            var data:String = captionToDataMap[event.target.caption];
            var e:FolderViewContextMenuEvent = new FolderViewContextMenuEvent(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, 
                                                                              data, folderViewPresModel);
            var dispatched:Boolean = folderView.dispatchEvent(e);
        }
         
        /**
         * Load menu config file specified in configPath property 
         * 
         */
        public function load():void
        {
            loader.load(new URLRequest(configFilePath));            
        }
        
        /**
         * Handle completion of loading xml file
         * 
         * @param event completion event
         * 
         */
        protected function onLoadSuccess(event:Event):void
        {
            var xml:XML = new XML(loader.data);            
            menuCollection.source = xml.menuitem;
            
            initContextMenu();
        }
         
    }
}