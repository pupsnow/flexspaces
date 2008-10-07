package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


    /**
     * Event to request login for a user 
     * 
     */
    public class LoginEvent extends UMEvent
    {
        /** Event name */
        public static const LOGIN:String = "login";

        public var userName:String;
        public var password:String;


        /**
         * Constructor
         * 
         * @param eventType event name
         * @param handlers handlers handlers responder with result and fault handlers
         * @param userName user name of the user to login
         * @param password password of the user to login
         * 
         */
        public function LoginEvent(eventType:String, handlers:IResponder, userName:String, password:String)
        {
            super(eventType, handlers);
            
            this.userName = userName;
            this.password = password;
        }
        
    }
}