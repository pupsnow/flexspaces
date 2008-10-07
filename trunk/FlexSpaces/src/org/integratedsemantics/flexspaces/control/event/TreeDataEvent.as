package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


    /**
     * Event to use for adm tree, by requesting one level of folder children for a given folder
     */
	public class TreeDataEvent extends UMEvent
	{
		/** Event name */
		public static const TREE_DATA:String = "treeData";

        public var path:String;
        
                
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param path path of adm parent folder to get folder children
         * 
         */
        public function TreeDataEvent(eventType:String, handlers:IResponder, path:String)
        {
            super(eventType, handlers);
            
            this.path = path;
        }       
				
	}
}