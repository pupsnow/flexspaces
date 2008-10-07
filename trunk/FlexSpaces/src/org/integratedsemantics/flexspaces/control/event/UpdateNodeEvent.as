package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.net.FileReference;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.command.IUploadHandlers;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request file upload for updating the content of a doc node
     * 
     */
	public class UpdateNodeEvent extends UMEvent
	{
		/** Event name */
		public static const UPDATE_NODE:String = "updateNode";
        public static const UPDATE_AVM_NODE:String = "updateAvmNode";

        public var repoNode:IRepoNode;
        public var fileRef:FileReference;
        public var statusHandlers:IUploadHandlers;

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param repoNode node to update with the uploaded content
         * @param fileRef file to upload
         * @param statusHandlers upload status methods to call
         * 
         */
        public function UpdateNodeEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, fileRef:FileReference, statusHandlers:IUploadHandlers=null)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
            this.fileRef = fileRef;
            this.statusHandlers = statusHandlers;
        }       
		
	}
}