package org.integratedsemantics.flexspaces.control.event.wcm
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


	/**
	 * Event to request avm tree data: stores for first level with WCM_STORES_DATA event type,
	 * and WCM_TREE_DATA event type to request folders at next levels (1 level at a time)
	 */
	public class WcmTreeDataEvent extends UMEvent
	{
		/** Event name */
		public static const WCM_TREE_DATA:String = "wcmTreeData";
        public static const WCM_STORES_DATA:String = "wcmStoresData";
		
        public var storeId:String;
        public var path:String;

        
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param storeId avm store id of parent folder  ( pass null when getting WCM_STORES_DATA)
         * @param path full avm path without store id of parent folder to get folder children ( null for WCM_STORES_DATA)
         * 
         */
        public function WcmTreeDataEvent(eventType:String, handlers:IResponder, storeId:String=null, path:String=null)
        {
            super(eventType, handlers);
            
            this.storeId = storeId;
            this.path = path;
        }       
				
	}
}