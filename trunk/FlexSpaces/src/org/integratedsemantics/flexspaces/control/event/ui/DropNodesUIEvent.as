package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request dropping nodes (move or copy into target folder)
     * to complete drag drop operation
     * 
     */
    public class DropNodesUIEvent extends UMEvent
    {
        /** Event name */
        public static const DROP_NODES:String = "dropNodes";

        public var parentNode:IRepoNode;
        public var action:String;            
        public var items:Array;

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param parentNode parent folder to drop nodes into
         * @param action DragManager.COPY or DragManager.MOVE
         * @param items the node items to drop
         * 
         */
        public function DropNodesUIEvent(eventType:String, handlers:IResponder, parentNode:IRepoNode, action:String, items:Array)
        {
            super(eventType, handlers);

            this.parentNode = parentNode;
            this.action = action;            
            this.items = items;
        }       
        
    }
}