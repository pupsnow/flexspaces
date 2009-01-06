package org.integratedsemantics.flexspaces.view.createspace
{
    import flash.events.MouseEvent;
    
    import mx.controls.ComboBox;
    import mx.controls.TextInput;
    import mx.controls.TileList;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.createspace.CreateSpacePresModel;


    /**
     * Base class for create space views  
     * 
     */
    public class CreateSpaceViewBase extends DialogViewBase
    {                
        public var foldername:TextInput;
        public var nodetitle:TextInput;
        public var description:TextInput;
        public var templatecombo:ComboBox;
        public var iconlist:TileList;
        
        public var onComplete:Function;

        [Bindable]
        public var createSpacePresModel:CreateSpacePresModel;        


        /**
         * Constructor
         * 
         * @param onComplete handler to call after creating space/folder
         * 
         */
        public function CreateSpaceViewBase(onComplete:Function=null)
        {
            super();

            this.onComplete = onComplete;            
        }        
        
        /**
         * Handle view creation complete by requesting space template data
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            iconlist.selectedIndex = 0;
            createSpacePresModel.changeSelectedIcon(iconlist.selectedItem);
			
			createSpacePresModel.updateFolderName(foldername.text);
			
			createSpacePresModel.getSpaceTemplates();
        }

        /**
         * Handle ok buttion click by requesting create space server operation
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
			createSpacePresModel.changeSelectedTemplate(templatecombo.selectedItem);

            var responder:Responder = new Responder(onResultCreateSpace, onFaultCreateSpace);
			createSpacePresModel.createSpace(responder);          
        }
        
        /**
         * Handler called when create space server call successfully completed
         * 
         * @info info result info
         */
        protected function onResultCreateSpace(info:Object):void
        {
            // notify repo browser to update the tree
            var parentPath:String = createSpacePresModel.parentNode.getPath();
            var path:String = parentPath + "/" + foldername.text;
            var addedFolderEvent:AddedFolderEvent = new AddedFolderEvent(AddedFolderEvent.ADDED_FOLDER, parentPath, path);
            parentApplication.dispatchEvent(addedFolderEvent);            

            PopUpManager.removePopUp(this);                        
            
            if (onComplete != null)
            {
                onComplete();
            }
        }
        
        /**
         * Handle fault from create space server call
         *  
         * @param info
         * 
         */
        protected function onFaultCreateSpace(info:Object):void
        {
            trace("onFaultCreateSpace" + info);
            PopUpManager.removePopUp(this);
        }        
        
    }
}