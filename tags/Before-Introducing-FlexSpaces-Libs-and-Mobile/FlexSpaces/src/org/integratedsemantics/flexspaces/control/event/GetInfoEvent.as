package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


    /**
     * Event to request getting server and user info
     * 
     */
    public class GetInfoEvent extends UMEvent
    {
        /** Event name */
        public static const GET_INFO:String = "getInfo";


        /**
         * Constructor
         * 
         * @param eventType event name
         * @param handlers handlers handlers responder with result and fault handlers
         * @param userName user name of the user to login
         * @param password password of the user to login
         * 
         */
        public function GetInfoEvent(eventType:String, handlers:IResponder)
        {
            super(eventType, handlers);            
        }
        
    }
}