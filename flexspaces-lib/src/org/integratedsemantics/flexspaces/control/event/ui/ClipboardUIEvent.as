package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


    /**
     * Event to request clipboard cut, copy, paste operations
     * 
     */
    public class ClipboardUIEvent extends UMEvent
    {
        /** Event name */
        public static const CLIPBOARD_CUT:String = "clipboardCut";
        public static const CLIPBOARD_COPY:String = "clipboardCopy";
        public static const CLIPBOARD_PASTE:String = "clipboardPaste";        

        public var selectedItems:Array;        
        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param selectedItems the selected node items to cut or copy, null for paste
         * 
         */
        public function ClipboardUIEvent(eventType:String, handlers:IResponder, selectedItems:Array=null)
        {
            super(eventType, handlers);
            
            this.selectedItems = selectedItems;
        }       
        
    }
}