package org.integratedsemantics.flexspaces.view.menu.menubar
{
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import mx.collections.XMLListCollection;
    import mx.controls.MenuBar;
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.view.menu.event.MenuConfiguredEvent;

    /**
     * Menu Bar supporting loading menu configuration from an XML (configPath property) 
     * 
     */
    public class ConfigurableMenuBar extends MenuBar
    {
        public var configPath:String;
        
        public var configurationDone:Boolean = false;
        
        [Bindable]
        public var menuBarCollection:XMLListCollection;
        
        protected var loader:URLLoader;
        
        

        /**
         * Constructor 
         * 
         */
        public function ConfigurableMenuBar()
        {
            super();
            
            menuBarCollection = new XMLListCollection();       
            dataProvider = menuBarCollection;
             
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onLoadSuccess);   
        }
        
        protected function onCreationComplete(event:FlexEvent):void
        {    
            load();
        }
        
        /**
         * Load menu config file specified in configPath property 
         * 
         */
        public function load():void
        {
            loader.load(new URLRequest(configPath));            
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
            
            menuBarCollection.source = xml.menuitem;
            
            configurationDone = true;
            
            var configuredEvent:MenuConfiguredEvent = new MenuConfiguredEvent(MenuConfiguredEvent.MENU_CONFIGURED);
            this.dispatchEvent(configuredEvent);            
        }
                
    }
}