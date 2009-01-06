package org.integratedsemantics.flexspaces.view.deletion
{   
    import flash.events.MouseEvent;
    
    import mx.controls.Text;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.deletion.DeletePresModel;


    /**
     * Base class for delete views  
     * 
     */
    public class DeleteViewBase extends DialogViewBase
    {
        public var filelist:Text;
        
        [Bindable]
        public var deletePresModel:DeletePresModel;

        public var onComplete:Function;

        
        /**
         * Constructor 
         * 
         * @param onComplete  handler to call after each node deletion
         *                           
         */
        public function DeleteViewBase(onComplete:Function=null)
        {
            super();

            this.onComplete = onComplete;
        }        

        /**
         * Init the dialog with the display of list of files to delete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            // display list of files to delete
            filelist.text = deletePresModel.filesToDeleteDisplay;
        }
                
        /**
         * Handle ok buttion click by requesting first delete node server operation
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            var responder:Responder = new Responder(onResultDelete, onFaultDelete);
            deletePresModel.deleteNodes(responder);
        }
        
        /**
         * Handle successful completion of all delete operations
         *  
         * @param info delete operation result info
         * 
         */
        protected function onResultDelete(info:Object):void
        {
            // notify repo browser to update the tree
            if ((deletePresModel.folderDeletion == true) && (deletePresModel.parentPath != null))
            {
            	var deletedFolderEvent:DeletedFolderEvent = new DeletedFolderEvent(DeletedFolderEvent.DELETED_FOLDER, deletePresModel.parentPath);
            	parentApplication.dispatchEvent(deletedFolderEvent);            
        	}            	
            PopUpManager.removePopUp(this);
            if (onComplete != null)
            {
                onComplete();
            }          
        }

        /**
         * Handle error in a delete operation
         * 
         * @param info delete operation fault info
         */
        protected function onFaultDelete(info:Object):void
        {
            PopUpManager.removePopUp(this);
        }        
        
    }
}