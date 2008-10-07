package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


    /**
     * Event to request logout with alfresco 
     * 
     */
    public class LogoutEvent extends UMEvent
    {
        /** Event name */
        public static const LOGOUT:String = "logout";


        /**
         * Constructor
         * 
         * @param eventType event name
         * @param handlers handlers handlers responder with result and fault handlers
         * 
         */
        public function LogoutEvent(eventType:String, handlers:IResponder)
        {
            super(eventType, handlers);            
        }
        
    }
}