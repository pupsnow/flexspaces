package org.integratedsemantics.flexspaces.component.rename
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.properties.GetPropertiesEvent;
    import org.integratedsemantics.flexspaces.control.event.properties.SetPropertiesEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.PropertiesVO;

    
    /**
     *  Presenter for Rename dialog for changing the name of docs/folders
     *  
     *  Presenter/Controller of RenameViewBase views  
     * 
     */
    public class RenamePresenter extends DialogPresenter
    {
        protected var repoNode:IRepoNode;
        
        protected var wcmMode:Boolean;
        protected var onComplete:Function;

        protected var isFolder:Boolean = false;
        protected var isAvmStore:Boolean = false;

               
        /**
         * Constructor 
         * 
         * @param renameView  view for to control
         * @param repoNode  node path (full path without store id if avm)
         * //@param storeId store id for node
         * @param wcmMode  is this for a wcm/avm node
         * @param onComplete  handler to call after renaming
         * 
         */
        public function RenamePresenter(renameView:RenameViewBase, repoNode:IRepoNode, 
                                        wcmMode:Boolean=false, onComplete:Function=null)
        {
            super(renameView);
            
            this.repoNode = repoNode;
            
            this.wcmMode = wcmMode;
            this.onComplete = onComplete;            
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get renameView():RenameViewBase
        {
            return this.view as RenameViewBase;            
        }       

        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);

            if (wcmMode == false)
            {
                var responder:Responder = new Responder(onResultGetProperties, onFaultGetProperties);
                var getPropertiesEvent:GetPropertiesEvent = new GetPropertiesEvent(GetPropertiesEvent.GET_PROPERTIES, responder, repoNode);
                getPropertiesEvent.dispatch();
            }
            else
            {
                if ( repoNode.getPath() == "/" )
                {
                    // for avm stores use name area for viewing storeid
                    isAvmStore = true;
                    renameView.nameItem.label = "AVM Store:";
                    renameView.nodename.text = repoNode.getStoreId();
                    renameView.nodename.editable = false;
                } 
                else
                {
                    responder = new Responder(onResultGetProperties, onFaultGetProperties);
                    getPropertiesEvent = new GetPropertiesEvent(GetPropertiesEvent.GET_AVM_PROPERTIES, responder, repoNode);
                    getPropertiesEvent.dispatch();
                }
            }                                                                                   
        }
        
        /**
         * Handler called when get properties successfully completed
         * 
         * @param data  properites data 
         */
        protected function onResultGetProperties(data:Object):void
        {
            var propertiesVO:PropertiesVO = data as PropertiesVO;

           renameView.nodename.text = propertiesVO.name;

            if (propertiesVO.isFolder == true)
            {
                isFolder = true;
            }            
        }
        
        /**
         * Handler for get properties fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultGetProperties(info:Object):void
        {
            trace("onFaultGetProperties" + info);            
        }
        
        /**
         * Handler called when set properties successfully completed
         * 
         * @info  results info
         */
        protected function onResultSetProperties(info:Object):void
        {            
            PopUpManager.removePopUp(renameView);
            if (onComplete != null)
            {
                onComplete();
            }                        
        }
        
        /**
         * Handler for set properties fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultSetProperties(info:Object):void
        {
            PopUpManager.removePopUp(renameView);
            trace("onFaultSetProperties" + info);
        }

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {            
            if (wcmMode == false)
            {
                var responder:Responder = new Responder(onResultSetProperties, onFaultSetProperties);
                var setPropertiesEvent:SetPropertiesEvent = new SetPropertiesEvent(SetPropertiesEvent.SET_PROPERTIES, 
                                                                                   responder, repoNode, renameView.nodename.text);
                setPropertiesEvent.dispatch();
            }
            else
            {
                if (isAvmStore == false)
                {
                    responder = new Responder(onResultSetProperties, onFaultSetProperties);
                    setPropertiesEvent = new SetPropertiesEvent(SetPropertiesEvent.SET_AVM_PROPERTIES, responder, repoNode, renameView.nodename.text);
                    setPropertiesEvent.dispatch();
                }
                else
                {
                    PopUpManager.removePopUp(renameView);
                }
            }                                      
        }
        
    }
}