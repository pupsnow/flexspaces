package org.integratedsemantics.flexspaces.presmodel.wcm.createfolder
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.FolderEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     *  Wcm create folder dialog presentation model which creates an avm folder
     *  
     */
    [Bindable] 
    public class WcmCreateFolderPresModel extends PresModel
    {
        public var parentNode:IRepoNode;      
        
        public var folderName:String = "";
        public var title:String = "";
        public var description:String = "";

        
        /**
         * Constructor
         *  
         * @param parentNode parent avm folder for new folder
         * 
         */
        public function WcmCreateFolderPresModel(parentNode:IRepoNode)
        {
            super();
            
            this.parentNode = parentNode;
        }
        
        /**
         * Reques create avm folder server operation
         * 
         */
        public function createWcmFolder(responder:Responder):void 
        {
            var folderEvent:FolderEvent = new FolderEvent(FolderEvent.CREATE_AVM_FOLDER, responder, parentNode, folderName);
            folderEvent.dispatch();                     
        }
        
        public function updateFolderName(newName:String):void
        {
        	this.folderName = newName;	
        }

        public function updateTitle(newTitle:String):void
        {
        	this.title = newTitle;	
        }

        public function updateDescription(newDesc:String):void
        {
        	this.description = newDesc;	
        }
        
    }
}
