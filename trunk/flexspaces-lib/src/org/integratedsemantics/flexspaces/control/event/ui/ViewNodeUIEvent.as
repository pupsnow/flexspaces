package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


    /**
     * Event to request viewing a document/file node
     * 
     */
    public class ViewNodeUIEvent extends UMEvent
    {
        /** Event name */
        public static const VIEW_NODE:String = "viewNode";

        public var selectedItem:Object;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItem the selected node item
         * 
         */
        public function ViewNodeUIEvent(eventType:String, handlers:IResponder, selectedItem:Object)
        {
            super(eventType, handlers);
            
            this.selectedItem = selectedItem;
        }       
        
    }
}