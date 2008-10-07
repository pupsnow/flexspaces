package org.integratedsemantics.flexspacesair.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;


    /**
     * Event to request making multiple selection of files and folders available offline
     * 
     * Note: selected folders themselves are made offline, not their contents
     *  
     * Nodes are made available offline by downloading them without a download dialog
     * to the flexpaces area in documents folder within folders mirroring the
     * repository folder / filenames. 
     * 
     */
    public class AirMakeAvailOfflineUIEvent extends UMEvent
    {
        /** Event name */
        public static const AIR_MAKE_AVAIL_OFFLINE:String = "airMakeAvailOffline";

        public var selectedItems:Array;  
        public var parent:DisplayObject;
        
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItems the selected node items
         * @param parent parent window for confirm dialog
         * 
         */
        public function AirMakeAvailOfflineUIEvent(eventType:String, handlers:IResponder, selectedItems:Array, parent:DisplayObject)
        {
            super(eventType, handlers);
            
            this.selectedItems = selectedItems;
            this.parent = parent;
        }       
        
    }
}