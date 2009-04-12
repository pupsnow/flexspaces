package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.folder.Node;

	/**
	 * Event to request a list of checked out docs for the current user
	 */
	public class CheckedOutListEvent extends UMEvent
	{
		/** Event name */
		public static const CHECKED_OUT_LIST:String = "checkedOutList";

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * 
         */
        public function CheckedOutListEvent(eventType:String, handlers:IResponder)
        {
            super(eventType, handlers);            
        }       
				
	}
}