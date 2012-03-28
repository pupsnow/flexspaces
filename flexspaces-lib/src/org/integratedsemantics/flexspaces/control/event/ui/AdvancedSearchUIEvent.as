package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;


    /**
     * Event to request advanced search UI
     * 
     */
    public class AdvancedSearchUIEvent extends UMEvent
    {
        /** Event name */
        public static const ADVANCED_SEARCH_UI:String = "advancedSearchUI";

        public var parent:DisplayObject;
        public var onComplete:Function;        
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param parent parent window for dialog
         * @param onComplete complete handler
         * 
         */
        public function AdvancedSearchUIEvent(eventType:String, handlers:IResponder, parent:DisplayObject, onComplete:Function=null)
        {
            super(eventType, handlers);
            
            this.parent = parent;
            this.onComplete = onComplete;            
        }       
        
    }
}