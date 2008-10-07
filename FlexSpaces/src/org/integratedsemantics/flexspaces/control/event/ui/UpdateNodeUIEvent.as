package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;

    
    /**
     * Event to request UI for uploading and updating the content of a doc node
     * 
     */
    public class UpdateNodeUIEvent extends UMEvent
    {
        /** Event name */
        public static const UPDATE_NODE_UI:String = "updateNodeUI";

        public var repoNode:IRepoNode;
        public var parent:DisplayObject;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param repoNode the node to update
         * @param parent parent window for progress dialog
         * 
         */
        public function UpdateNodeUIEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, parent:DisplayObject)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
            this.parent = parent;
        }       
        
    }
}