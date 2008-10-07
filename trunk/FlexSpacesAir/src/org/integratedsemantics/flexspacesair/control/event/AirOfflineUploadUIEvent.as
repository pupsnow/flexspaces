package org.integratedsemantics.flexspacesair.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;


    /**
     * Event to request upload of a file (without file chooser dialog) from offline area 
     * (from standard local flexspaces documents area in local folder path / file name
     *  mirroring repository path / filename) into an existing
     *  document in the repository
     *  
     * Note: files will be placed in this area by Make Available Offline
     * 
     */
    public class AirOfflineUploadUIEvent extends UMEvent
    {
        /** Event name */
        public static const AIR_OFFLINE_UPLOAD:String = "airOfflineUpload";

        public var selectedItem:Object;
        public var checkin:Boolean;
        public var parent:DisplayObject;
        public var onComplete:Function;  
        
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItem the selected node item
         * @param checkin whether to checkin also
         * @param view parent window for confirm
         * @param onComplete callback after complete
         * 
         */
        public function AirOfflineUploadUIEvent(eventType:String, handlers:IResponder, selectedItem:Object, checkin:Boolean,
                                                parent:DisplayObject, onComplete:Function=null)
        {
            super(eventType, handlers);
            
            this.selectedItem = selectedItem;
            this.checkin = checkin;
            this.parent = parent;
            this.onComplete = onComplete;
        }       
        
    }
}