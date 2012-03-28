package org.integratedsemantics.flexspaces.view.menu.event
{
    import flash.events.Event;

    /**
     * Event lets listeners know when a menu has loaded its xml config file and is all configured
     * using the config info 
     * 
     */
    public class MenuConfiguredEvent extends Event
    {
        /** Event name */
        public static const MENU_CONFIGURED:String = "menuConfigured";

        /**
         * Constructor
         *  
         * @param type event name
         * 
         */
        public function MenuConfiguredEvent(type:String)
        {
            super(type);
        }
        
    }
}