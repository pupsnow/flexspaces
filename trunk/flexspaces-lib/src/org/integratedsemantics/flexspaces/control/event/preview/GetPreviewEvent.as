package org.integratedsemantics.flexspaces.control.event.preview
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;

    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request the flash preview node, if it exists, for a given node
     */
    public class GetPreviewEvent extends UMEvent
    {
        /** Event name */
        public static const GET_PREVIEW:String = "getPreview";

        public var repoNode:IRepoNode;


        /**
         * Constructor
         * 
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param repoNode repository node
         * 
         */
        public function GetPreviewEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
        }       
        
    }
}