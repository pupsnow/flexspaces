package org.integratedsemantics.flexspaces.control.event.wcm
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


	/**
	 * Event to reqeust list of contents of an AVM folder
	 */
	public class WcmFolderListEvent extends UMEvent
	{
		/** Event name */
		public static const WCM_FOLDER_LIST:String = "wcmFolderList";

        public var storeId:String;
        public var path:String;

		
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param storeId avm store id of folder
         * @param path full avm path without store id of folder
         * 
         */
        public function WcmFolderListEvent(eventType:String, handlers:IResponder, storeId:String, path:String)
        {
            super(eventType, handlers);
            
            this.storeId = storeId;
            this.path = path;
        }       
				
	}
}