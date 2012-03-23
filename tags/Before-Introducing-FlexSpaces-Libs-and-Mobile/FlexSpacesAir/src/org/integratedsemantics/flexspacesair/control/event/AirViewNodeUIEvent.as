package org.integratedsemantics.flexspacesair.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.containers.ViewStack;
    import mx.rpc.IResponder;


    /**
     * Event to request viewing a document/file node
     * with special air features:
     * 
     *  1. automaticly doing a make available offline
     *  2. display in webkit html tab if formated supported,
     *     otherwise launches in a separate window
     * 
     */
    public class AirViewNodeUIEvent extends UMEvent
    {
        /** Event name */
        public static const AIR_VIEW_NODE:String = "airViewNode";

        public var selectedItem:Object;
        public var container:ViewStack;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItem the selected node item
         * @param container parent container to add webkit html view of file to
         * 
         */
        public function AirViewNodeUIEvent(eventType:String, handlers:IResponder, selectedItem:Object, container:ViewStack)
        {
            super(eventType, handlers);
            
            this.selectedItem = selectedItem;
            this.container = container;
        }       
        
    }
}