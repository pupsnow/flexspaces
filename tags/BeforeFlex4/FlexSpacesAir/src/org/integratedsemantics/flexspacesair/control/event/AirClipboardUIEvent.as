package org.integratedsemantics.flexspacesair.control.event
{
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.event.ui.ClipboardUIEvent;


    /**
     * Event to request clipboard cut, copy, paste operations
     * in air with native or internal nodes support
     */
    public class AirClipboardUIEvent extends ClipboardUIEvent
    {
        /** Event name */
        public static const AIR_CLIPBOARD_CUT:String = "airClipboardCut";
        public static const AIR_CLIPBOARD_COPY:String = "airClipboardCopy";
        public static const AIR_CLIPBOARD_PASTE:String = "airClipboardPaste";
        
        public var view:DisplayObject;
        public var onComplete:Function;        

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param view for use when adding flexspaces format to clipboard
         * @param selectedItems the selected node items to cut or copy, null for paste
         * @param onComplete callback after complete
         * 
         */
        public function AirClipboardUIEvent(eventType:String, handlers:IResponder, view:DisplayObject, selectedItems:Array=null, 
                                            onComplete:Function=null)
        {
            super(eventType, handlers, selectedItems);     
            this.view = view;       
            this.onComplete = onComplete;
        }       
        
    }
}