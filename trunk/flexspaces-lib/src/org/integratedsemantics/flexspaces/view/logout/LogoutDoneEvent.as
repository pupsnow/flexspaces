package org.integratedsemantics.flexspaces.view.logout
{
    import flash.events.Event;

    /**
     * Signals logout is done 
     * 
     */
    public class LogoutDoneEvent extends Event
    {
        /** Event name */
        public static const LOGOUT_DONE:String = "logoutDone";
        
        /**
         * Constructor
         *  
         * @param type event name
         * 
         */
        public function LogoutDoneEvent(type:String)
        {
            super(type);
        }
        
    }
}