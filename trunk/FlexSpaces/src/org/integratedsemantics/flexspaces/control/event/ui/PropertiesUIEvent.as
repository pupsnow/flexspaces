package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;


    /**
     * Event to request properties UI for a document/folder node
     * 
     */
    public class PropertiesUIEvent extends UMEvent
    {
        /** Event name */
        public static const PROPERTIES_UI:String = "propertiesUI";

        public var selectedItem:Object;
        public var parent:DisplayObject;
        public var onComplete:Function;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItem the selected node item
         * @param parent parent window for dialog
         * @param onComplete option handler for completion of rename dialog
         * 
         */
        public function PropertiesUIEvent(eventType:String, handlers:IResponder, selectedItem:Object, parent:DisplayObject, onComplete:Function=null)
        {
            super(eventType, handlers);
            
            this.selectedItem = selectedItem;
            this.parent = parent;            
            this.onComplete = onComplete;
        }       
        
    }
}