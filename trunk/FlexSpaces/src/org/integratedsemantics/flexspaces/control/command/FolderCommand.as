package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.FolderDelegate;
    import org.integratedsemantics.flexspaces.control.event.FolderEvent;


    /**
     * FolderCommand provides operations for creating new adm spaces/folders and getting list of space templates 
     * 
     */
    public class FolderCommand extends Command
    {
        /**
         * Constructor
         */
        public function FolderCommand()
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
                case FolderEvent.CREATE_SPACE:
                    newSpace(event as FolderEvent);  
                    break;
                case FolderEvent.SPACE_TEMPLATES:
                    getSpaceTemplates(event as FolderEvent);  
                    break;
                case FolderEvent.CREATE_AVM_FOLDER:
                    createAvmFolder(event as FolderEvent);  
                    break;
            }
        }       

        /**
         * Perform New Space Folder Action
         * 
         * @param event folder event
         */
        public function newSpace(event:FolderEvent):void
        {
            var handlers:Callbacks = new Callbacks(onCreateSpaceSuccess, onFault);
            var delegate:FolderDelegate = new FolderDelegate(handlers);
            delegate.newSpace(event.parentNode, event.newName, event.newTitle, event.newDesc, event.templateNode, event.iconName);                  
        }

        /**
         * Perform Get Space Templates Action
         * 
         * @param event folder event
         */
        public function getSpaceTemplates(event:FolderEvent):void
        {
            var handlers:Callbacks = new Callbacks(onSpaceTemplatesSuccess, onFault);
            var delegate:FolderDelegate = new FolderDelegate(handlers);
            delegate.getSpaceTemplates();                  
        }

        /**
         * Perform New Avm Folder Action
         * 
         * @param event avm folder event
         */
        public function createAvmFolder(event:FolderEvent):void
        {
            var handlers:Callbacks = new Callbacks(onCreateAvmFolderSuccess, onFault);
            var delegate:FolderDelegate = new FolderDelegate(handlers);
            delegate.createAvmFolder(event.parentNode, event.newName, event.newTitle, event.newDesc);             
        }
        
        /**
         * onCreateSpaceSuccess event handler
         * 
         * @param event success event
         */
        protected function onCreateSpaceSuccess(event:*):void
        {
            this.result(event.result);
        }        

        /**
         * onCreateAvmFolderSuccess event handler
         * 
         * @param event success event
         */
        protected function onCreateAvmFolderSuccess(event:*):void
        {
            this.result(event.result);
        }                
        
        /**
         * onSpaceTemplatesSuccess event handler
         * 
         * @param event success event
         */
        protected function onSpaceTemplatesSuccess(event:*):void
        {
            this.result(event.result);
        }        
    }
}