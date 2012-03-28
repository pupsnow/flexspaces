package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.CopyMoveDelegate;
    import org.integratedsemantics.flexspaces.control.event.CopyMoveEvent;
    
	
	/**
	 * CopyMoveCommand provides copy/move operations for adm and avm nodes
	 */
	public class CopyMoveCommand extends Command
	{
        /**
         * Constructor
         */
        public function CopyMoveCommand()
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
                case CopyMoveEvent.COPY:
                    copy(event as CopyMoveEvent);  
                    break;
                case CopyMoveEvent.MOVE:
                    move(event as CopyMoveEvent);  
                    break;                    
                case CopyMoveEvent.AVM_COPY:
                    wcmCopy(event as CopyMoveEvent);  
                    break;
                case CopyMoveEvent.AVM_MOVE:
                    wcmMove(event as CopyMoveEvent);  
                    break;
                case CopyMoveEvent.ADM_TO_AVM_COPY:
                    copyAdmToAvm(event as CopyMoveEvent);  
                    break;
                case CopyMoveEvent.AVM_TO_ADM_COPY:
                    copyAvmToAdm(event as CopyMoveEvent);  
                    break;
            }
        }       
		
		/**
		 * Perform Copy action
		 * 
		 * @param event copy move event 
		 */
		public function copy(event:CopyMoveEvent):void
		{
            var handlers:Callbacks = new Callbacks(onCopySuccess, onFault);
            var delegate:CopyMoveDelegate = new CopyMoveDelegate(handlers);
            delegate.copy(event.sourceNode, event.targetFolderNode);                  		    
		}
		
        /**
         * Perform WCM Copy action
         * 
         * @param event avm copy move event
         */
        public function wcmCopy(event:CopyMoveEvent):void
        {
            var handlers:Callbacks = new Callbacks(onCopySuccess, onFault);
            var delegate:CopyMoveDelegate = new CopyMoveDelegate(handlers);
            delegate.wcmCopy(event.sourceNode, event.targetFolderNode);                             
        }

        /**
         * Perform Move action
         * 
         * @param event copy move event
         */
        public function move(event:CopyMoveEvent):void
        {
            var handlers:Callbacks = new Callbacks(onMoveSuccess, onFault);
            var delegate:CopyMoveDelegate = new CopyMoveDelegate(handlers);
            delegate.move(event.sourceNode, event.targetFolderNode);                             
        }

        /**
         * Perform WCM Move action
         * 
         * @param event avm copy move event
         */
        public function wcmMove(event:CopyMoveEvent):void
        {
            var handlers:Callbacks = new Callbacks(onMoveSuccess, onFault);
            var delegate:CopyMoveDelegate = new CopyMoveDelegate(handlers);
            delegate.wcmMove(event.sourceNode, event.targetFolderNode);                             
        }


        /**
         * Perform Copy from ADM to AVM
         * 
         * @param event adm to avm copy event
         */
        public function copyAdmToAvm(event:CopyMoveEvent):void
        {
            var handlers:Callbacks = new Callbacks(onCopySuccess, onFault);
            var delegate:CopyMoveDelegate = new CopyMoveDelegate(handlers);
            delegate.copyAdmToAvm(event.sourceNode, event.targetFolderNode);                             
        }

        /**
         * Perform Copy from AVM to ADM
         * 
         * @param event avm to adm copy event
         */
        public function copyAvmToAdm(event:CopyMoveEvent):void
        {
            var handlers:Callbacks = new Callbacks(onCopySuccess, onFault);
            var delegate:CopyMoveDelegate = new CopyMoveDelegate(handlers);
            delegate.copyAvmToAdm(event.sourceNode, event.targetFolderNode);                             
        }

        /**
         * onCopyActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onCopySuccess(event:*):void
        {
            this.result(event.result);
        }

        /**
         * onMoveActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onMoveSuccess(event:*):void
        {
            this.result(event.result);
        }
	}
	
}