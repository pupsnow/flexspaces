package org.integratedsemantics.flexspaces.view.login
{
    import flash.events.Event;

    /**
     * Signals login is all done 
     * 
     */
    public class LoginDoneEvent extends Event
    {
        /** Event name */
        public static const LOGIN_DONE:String = "loginDone";
        
        /**
         * Constructor
         * 
         * @param type event name
         * 
         */
        public function LoginDoneEvent(type:String)
        {
            super(type);
        }
        
    }
}