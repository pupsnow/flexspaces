package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.net.FileReferenceList;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.command.IUploadHandlers;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request browsing and upload of multiple files to an adm folder 
     * 
     */
	public class UploadFilesEvent extends UMEvent
	{
		/** Event name */
		public static const UPLOAD_FILES:String = "uploadFiles";
        public static const UPLOAD_AVM_FILES:String = "uploadAvmFiles";

        public var parentNode:IRepoNode;
        public var fileRefList:FileReferenceList;
        public var statusHandlers:IUploadHandlers;
        public var nodeType:String;

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param parentNode the parent folder to upload files to
         * @param fileRefList list of files to upload
         * @param statusHandlers upload status methods to call
         * @param nodeType type of node to create
         * 
         */
        public function UploadFilesEvent(eventType:String, handlers:IResponder, parentNode:IRepoNode, fileRefList:FileReferenceList, 
                                         statusHandlers:IUploadHandlers=null, nodeType:String="cm:content")
        {
            super(eventType, handlers);
            
            this.parentNode = parentNode;
            this.fileRefList = fileRefList;
            this.statusHandlers = statusHandlers;
            this.nodeType = nodeType;
        }       
		
	}
}