package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;

	/**
	 * Event to request a list of the contents of an adm folder
	 */
	public class FolderListEvent extends UMEvent
	{
		/** Event name */
		public static const FOLDER_LIST:String = "folderList";

        public var path:String;
        
        		
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param path path of adm folder to list contents for
         * 
         */
        public function FolderListEvent(eventType:String, handlers:IResponder, path:String)
        {
            super(eventType, handlers);
            
            this.path = path;
        }       
				
	}
}