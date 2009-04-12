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
        
        // cmis
        public var cmisChildren:String;
        
                
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param path path of adm parent folder to get folder children
         * @param cmisChildren optional cmis url for getting folder chldren (cmis mode)
         * 
         */
        public function TreeDataEvent(eventType:String, handlers:IResponder, path:String, cmisChildren:String = null)
        {
            super(eventType, handlers);
            
            this.path = path;
            
            // cmis
            this.cmisChildren = cmisChildren;                     
        }       
				
	}
}