package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;


    /**
     * Event to request UI for start workflow on a document/file
     * 
     */
    public class StartWorkflowUIEvent extends UMEvent
    {
        /** Event name */
        public static const START_WORKFLOW_UI:String = "startWorkflowUI";

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
         * @param onComplete complete handler
         * 
         */
        public function StartWorkflowUIEvent(eventType:String, handlers:IResponder, selectedItem:Object, parent:DisplayObject, onComplete:Function=null)
        {
            super(eventType, handlers);
            
            this.selectedItem = selectedItem;
            this.parent = parent;
            this.onComplete = onComplete;            
        }       
        
    }
}