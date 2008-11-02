package org.integratedsemantics.flexspaces.component.wcm.createfolder
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.createspace.AddedFolderEvent;
    import org.integratedsemantics.flexspaces.control.event.FolderEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     *  Wcm Create Folder Dialog Presenter which creates an avm folder
     *  
     *  Supervising Presenter/Controller of WcmCreateFolderViewBase views 
     * 
     */
    public class WcmCreateFolderPresenter extends DialogPresenter
    {
        protected var parentNode:IRepoNode;
        protected var onComplete:Function;
        
        
        /**
         * Constructor
         *  
         * @param createFolderView 
         * @param parentNode parent avm folder for new folder
         * @param onComplete handler to call after creating new folder
         * 
         */
        public function WcmCreateFolderPresenter(createFolderView:WcmCreateFolderViewBase, parentNode:IRepoNode, 
                                                 onComplete:Function=null)
        {
            super(createFolderView);
            
            this.parentNode = parentNode;
            this.onComplete = onComplete;
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get createFolderView():WcmCreateFolderViewBase
        {
            return this.view as WcmCreateFolderViewBase;            
        }       

        /**
         * Handle view creation complete
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            // hide fields other than name readonly since javascript api to set properties
            // on avm nodes does not work
            createFolderView.titleItem.setVisible(false);
            createFolderView.titleItem.includeInLayout = false;    
            createFolderView.descriptionItem.setVisible(false);
            createFolderView.descriptionItem.includeInLayout = false;                
        }
                
        /**
         * Handler called when create avm folder action  successfully completed
         * 
         * @param result info
         */
        protected function onResultCreateAvmFolder(info:Object):void
        {
            // notify wcm repo browser to update the tree
            var parentPath:String = parentNode.getPath();
            var path:String = parentPath + "/" + createFolderView.foldername.text;
            var addedFolderEvent:AddedFolderEvent = new AddedFolderEvent(AddedFolderEvent.ADDED_FOLDER, parentPath, path);
            createFolderView.parentApplication.dispatchEvent(addedFolderEvent);            

            PopUpManager.removePopUp(createFolderView);
            if (onComplete != null)
            {
                this.onComplete();
            }
        }
        
        /**
         * Handler called when create avm folder action returns a fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultCreateAvmFolder(info:Object):void
        {
            PopUpManager.removePopUp(createFolderView);
            trace("onFaultCreateAvmFolder" + info);
        }

        /**
         * Handle ok buttion click by requesting create avm folder server operation
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            var responder:Responder = new Responder(onResultCreateAvmFolder, onFaultCreateAvmFolder);
            var folderEvent:FolderEvent = new FolderEvent(FolderEvent.CREATE_AVM_FOLDER, responder, parentNode, createFolderView.foldername.text);
            folderEvent.dispatch();                     
        }
        
    }
}
