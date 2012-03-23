package org.integratedsemantics.flexspaces.control.event.ui
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import flash.display.DisplayObject;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request UI for create space/folder
     * 
     */
    public class CreateSpaceUIEvent extends UMEvent
    {
        /** Event name */
        public static const CREATE_SPACE_UI:String = "createSpaceUI";

        public var parentNode:IRepoNode;
        public var parent:DisplayObject;
        public var onComplete:Function;

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param parentNode the parent folder to create space/folder in
         * @param parent parent window for dialog
         * @param onComplete completion handler
         * 
         */
        public function CreateSpaceUIEvent(eventType:String, handlers:IResponder, parentNode:IRepoNode, parent:DisplayObject, onComplete:Function=null)
        {
            super(eventType, handlers);
            
            this.parentNode = parentNode;
            this.parent = parent;
            this.onComplete = onComplete;
        }       
        
    }
}