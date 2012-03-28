package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;

    
    /**
     * Event to request UI for uploading files
     * 
     */
    public class UploadFilesUIEvent extends UMEvent
    {
        /** Event name */
        public static const UPLOAD_FILES_UI:String = "uploadFilesUI";

        public var parentNode:IRepoNode;
        public var parent:DisplayObject;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param parentNode the parent folder to upload files to
         * @param parent parent window for progress dialog
         * 
         */
        public function UploadFilesUIEvent(eventType:String, handlers:IResponder, parentNode:IRepoNode, parent:DisplayObject)
        {
            super(eventType, handlers);
            
            this.parentNode = parentNode;
            this.parent = parent;
        }       
        
    }
}