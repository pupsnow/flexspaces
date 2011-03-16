package org.integratedsemantics.flexspaces.view.wcm.createfolder
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import mx.containers.FormItem;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.wcm.createfolder.WcmCreateFolderPresModel;
    import org.integratedsemantics.flexspaces.view.createspace.AddedFolderEvent;

    /**
     * Base class for wcm create folder views  
     * 
     */
    public class WcmCreateFolderViewBase extends DialogViewBase
    {
        public var onComplete:Function;
        
        public var nameItem:FormItem;
        public var foldername:TextInput;
        
        public var titleItem:FormItem;
        public var nodetitle:TextInput;

        public var descriptionItem:FormItem;
        public var description:TextInput;

        [Bindable]
        public var wcmCreateFolderPresModel:WcmCreateFolderPresModel;


        /**
         * Constructor
         *  
         * @param onComplete handler to call after creating new folder
         * 
         */
        public function WcmCreateFolderViewBase(onComplete:Function=null)
        {
            super();
            this.onComplete = onComplete;            
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
            titleItem.setVisible(false);
            titleItem.includeInLayout = false;    
            descriptionItem.setVisible(false);
            descriptionItem.includeInLayout = false;                
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
            
            wcmCreateFolderPresModel.createWcmFolder(responder);
        }

        /**
         * Handler called when create avm folder action  successfully completed
         * 
         * @param result info
         */
        protected function onResultCreateAvmFolder(info:Object):void
        {
            // notify wcm repo browser to update the tree
            var parentPath:String = wcmCreateFolderPresModel.parentNode.getPath();
            var path:String = parentPath + "/" + foldername.text;
            var addedFolderEvent:AddedFolderEvent = new AddedFolderEvent(AddedFolderEvent.ADDED_FOLDER, parentPath, path);
            parentApplication.dispatchEvent(addedFolderEvent);            

            PopUpManager.removePopUp(this);
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
            PopUpManager.removePopUp(this);
            trace("onFaultCreateAvmFolder" + info);
        }
                               
    }
}