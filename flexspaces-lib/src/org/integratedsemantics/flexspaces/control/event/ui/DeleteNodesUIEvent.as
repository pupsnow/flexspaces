package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;


    /**
     * Event to request delete nodes UI
     * 
     */
    public class DeleteNodesUIEvent extends UMEvent
    {
        /** Event name */
        public static const DELETE_NODES_UI:String = "deleteNodesUI";
        
        public var selectedItems:Array;        
        public var parent:DisplayObject;
        public var onComplete:Function;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItems the selected node items
         * @param parent parent window for dialog
         * @param onComplete complete handler
         * 
         */
        public function DeleteNodesUIEvent(eventType:String, handlers:IResponder, selectedItems:Array, parent:DisplayObject, onComplete:Function=null)
        {
            super(eventType, handlers);
            
            this.selectedItems = selectedItems;
            this.parent = parent;
            this.onComplete = onComplete;
        }       
        
    }
}