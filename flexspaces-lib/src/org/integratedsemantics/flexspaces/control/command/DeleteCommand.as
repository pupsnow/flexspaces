package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.DeleteDelegate;
    import org.integratedsemantics.flexspaces.control.event.DeleteEvent;


    /**
     * Delete Command provides deletion handling for adm and avm nodes 
     */
    public class DeleteCommand extends Command
    {
        /**
         * Constructor
         */
        public function DeleteCommand()
        {
            super();
        }
        
        /**
         * Execute command for the given event
         *  
         * @param event event calling command
         * 
         */
        override public function execute(event:CairngormEvent):void
        {
            // always call the super.execute() method which allows the 
            // callBack information to be cached.
            super.execute(event);
 
            switch(event.type)
            {
                case DeleteEvent.DELETE:
                    deleteNode(event as DeleteEvent);  
                    break;
                case DeleteEvent.DELETE_AVM:
                    deleteAvmNode(event as DeleteEvent);  
                    break;
            }
        }       

        /**
         * Delete document or folder with the given nodeId
         * 
         * @param event delete event
         */
        public function deleteNode(event:DeleteEvent):void
        {
            var handlers:Callbacks = new Callbacks(onDeleteActionSuccess, onFault);
            var delegate:DeleteDelegate = new DeleteDelegate(handlers);
            delegate.deleteNode(event.repoNode);                  
        }

        /**
         * Delete document or folder with the given avm store id and path
         * 
         * @param event delete avm event
         */
        public function deleteAvmNode(event:DeleteEvent):void
        {
            var handlers:Callbacks = new Callbacks(onDeleteActionSuccess, onFault);
            var delegate:DeleteDelegate = new DeleteDelegate(handlers);
            delegate.deleteAvmNode(event.repoNode);                  
        }
        
        /**
         * onDeleteActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onDeleteActionSuccess(event:*):void
        {
            this.result(event.result);
        }
        
    }
}