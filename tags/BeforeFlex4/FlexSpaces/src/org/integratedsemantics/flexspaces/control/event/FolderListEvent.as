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
        
        public var pageSize:int;
        public var pageNum:int;
        
        // cmis
        public var cmisChildren:String;

        		
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param path path of adm folder to list contents for
         * @param pageSize num of items in each page (0 for no paging)
         * @param pageNum  0 based page number to return
         * @param cmisChildren optional cmis url for getting folder chldren (cmis mode)
         * 
         */
        public function FolderListEvent(eventType:String, handlers:IResponder, path:String, pageSize:int=0, 
                                        pageNum:int=0, cmisChildren:String = null)
        {
            super(eventType, handlers);
            
            this.path = path;
            
            this.pageSize = pageSize;
            this.pageNum = pageNum;    
            // cmis
            this.cmisChildren = cmisChildren;         
        }       
				
	}
}