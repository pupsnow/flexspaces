package org.integratedsemantics.flexspaces.control.event.preview
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     *  Event to request making a flash preview for a given node
     */
    public class MakePreviewEvent extends UMEvent
    {
        /** Event name */
        public static const MAKE_PREVIEW:String = "makePreview";

        public var repoNode:IRepoNode;
        public var parentNode:IRepoNode;


        /**
         * Constructor
         * 
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param repoNode repository node to make flash preview for
         * @param parentNode folder to create the preview node in
         * 
         */
        public function MakePreviewEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, parentNode:IRepoNode)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
            this.parentNode = parentNode;
        }       
                
    }
}