package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;


    /**
     * Event to request downloading UI for a document/file node
     * 
     */
    public class DownloadUIEvent extends UMEvent
    {
        /** Event name */
        public static const DOWNLOAD_UI:String = "downloadUI";

        public var selectedItem:Object;
        public var parent:DisplayObject;
        public var airMode:Boolean;
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItem the selected node item
         * @param parent parent window for progress dialog
         * @param airMode indicate ir running with AIR, which needs special handling
         * 
         */
        public function DownloadUIEvent(eventType:String, handlers:IResponder, selectedItem:Object, parent:DisplayObject, airMode:Boolean=false)
        {
            super(eventType, handlers);
            
            this.selectedItem = selectedItem;
            this.parent = parent;
            this.airMode = airMode;
        }       
        
    }
}