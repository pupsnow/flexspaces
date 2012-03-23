package org.integratedsemantics.flexspacesair.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.containers.ViewStack;
    import mx.rpc.IResponder;


    public class AirOfflineEditUIEvent extends UMEvent
    {
        /** Event name */
        public static const AIR_OFFLINE_EDIT:String = "airOfflineEdit";

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
        public function AirOfflineEditUIEvent(eventType:String, handlers:IResponder, selectedItem:Object, container:ViewStack)
        {
            super(eventType, handlers);
            
            this.selectedItem = selectedItem;
            this.container = container;
        }       
        
    }
}