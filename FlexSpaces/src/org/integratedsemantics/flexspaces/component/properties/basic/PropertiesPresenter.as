package org.integratedsemantics.flexspaces.component.properties.basic
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.properties.GetPropertiesEvent;
    import org.integratedsemantics.flexspaces.control.event.properties.SetPropertiesEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.PropertiesVO;

    /**
     *  Properties dialog for viewing and editing basic properties of docs/folders
     *  
     *  Presenter/Controller of PropertiesViewBase views
     * 
     */
    public class PropertiesPresenter extends DialogPresenter
    {
        protected var repoNode:IRepoNode;
        
        protected var wcmMode:Boolean;
        protected var onComplete:Function;
        
        protected var isFolder:Boolean = false;
        protected var isAvmStore:Boolean = false;
                        
        /**
         * Constructor 
         * 
         * @param propertiesView  view for to control
         * @param repoNode node to get / set properties on
         * @param wcmMode  is this for a wcm/avm node
         * @param onComplete  handler to call after properites setting
         * 
         */
        public function PropertiesPresenter(propertiesView:PropertiesViewBase, repoNode:IRepoNode, 
                                            wcmMode:Boolean=false, onComplete:Function=null)
        {
            super(propertiesView);
            
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
        protected function get propertiesView():PropertiesViewBase
        {
            return this.view as PropertiesViewBase;            
        }       

        /**
         * Handle creation complete by requesting properties data from server 
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
                propertiesView.authorItem.setVisible(false);
                propertiesView.authorItem.includeInLayout = false;
                propertiesView.emailidItem.setVisible(false);
                propertiesView.emailidItem.includeInLayout = false;
                
                if ( repoNode.getPath() == "/" )
                {
                    // for avm stores hide title, desc form areas
                    // use name area for viewing storeid
                    isAvmStore = true;
                    propertiesView.nameItem.label = "AVM Store:";
                    propertiesView.nodename.text = repoNode.getStoreId();
                    propertiesView.nodename.editable = false;
                    propertiesView.titleItem.setVisible(false);
                    propertiesView.titleItem.includeInLayout = false;    
                    propertiesView.descriptionItem.setVisible(false);
                    propertiesView.descriptionItem.includeInLayout = false;    
                    isFolder = true;
                    propertiesView.authorItem.setVisible(false);
                    propertiesView.authorItem.includeInLayout = false;
                    propertiesView.sizeItem.setVisible(false);
                    propertiesView.sizeItem.includeInLayout = false;
                    propertiesView.mimetypeItem.setVisible(false);
                    propertiesView.mimetypeItem.includeInLayout = false;
                }
                else
                {
                    // for avm nodes, make fields other than name readonly since 
                    // javascript api to set properties on avm nodes does not work
                    propertiesView.nodetitle.editable = false; 
                    propertiesView.description.editable = false;

                    responder = new Responder(onResultGetProperties, onFaultGetProperties);
                    getPropertiesEvent = new GetPropertiesEvent(GetPropertiesEvent.GET_AVM_PROPERTIES, responder, repoNode);
                    getPropertiesEvent.dispatch();                                
                }                
            }    
            
            // disable ok,cancel, have close if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                propertiesView.okBtn.enabled = false;
                propertiesView.okBtn.visible = false;
                propertiesView.okBtn.includeInLayout = false;
                propertiesView.cancelBtn.enabled = false;
                propertiesView.cancelBtn.visible = false;
                propertiesView.cancelBtn.includeInLayout = false;
                propertiesView.closeBtn.enabled = true;
                propertiesView.closeBtn.visible = true;
                propertiesView.closeBtn.includeInLayout = true;
            }                      
        }
        
        /**
         * handler called when get properties successfully completed
         * 
         * @param data properties data
         */
        protected function onResultGetProperties(data:Object):void
        {
            var propertiesVO:PropertiesVO = data as PropertiesVO;

            propertiesView.nodename.text = propertiesVO.name;
            propertiesView.nodetitle.text = propertiesVO.title;
            propertiesView.description.text = propertiesVO.description;
            propertiesView.author.text = propertiesVO.author;
            propertiesView.size.text = propertiesVO.size;
            propertiesView.creator.text = propertiesVO.creator;
            propertiesView.created.text = propertiesVO.created;
            propertiesView.modifier.text = propertiesVO.modifier;
            propertiesView.modified.text = propertiesVO.modified;
            propertiesView.emailid.text = propertiesVO.emailid;
            propertiesView.mimetype.text = propertiesVO.mimetype;

            if (propertiesVO.isFolder == true)
            {
                isFolder = true;
                propertiesView.authorItem.setVisible(false);
                propertiesView.authorItem.includeInLayout = false;
                propertiesView.sizeItem.setVisible(false);
                propertiesView.sizeItem.includeInLayout = false;
                propertiesView.mimetypeItem.setVisible(false);
                propertiesView.mimetypeItem.includeInLayout = false;
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
         * @info results info
         */
        protected function onResultSetProperties(info:Object):void
        {            
            PopUpManager.removePopUp(propertiesView);
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
            PopUpManager.removePopUp(propertiesView);
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
                var setPropertiesEvent:SetPropertiesEvent = new SetPropertiesEvent(SetPropertiesEvent.SET_PROPERTIES, responder, repoNode, 
                                               propertiesView.nodename.text, propertiesView.nodetitle.text, propertiesView.description.text, 
                                               propertiesView.author.text);
                setPropertiesEvent.dispatch();
            }
            else
            {
                if (isAvmStore == false)
                {
                    responder = new Responder(onResultSetProperties, onFaultSetProperties);
                    setPropertiesEvent= new SetPropertiesEvent(SetPropertiesEvent.SET_AVM_PROPERTIES, responder, repoNode, propertiesView.nodename.text);
                    setPropertiesEvent.dispatch();
                }
                else
                {
                    // can't set properties on avm store fake nodes
                    PopUpManager.removePopUp(propertiesView);
                }
            }                          
        }
        
        /**
         * Handle close buttion click
         * (not for X close in title area)
         * (used when no write permissions)
         * 
         * @param click event
         * 
         */
        override protected function onCloseBtn(event:MouseEvent):void 
        {            
            PopUpManager.removePopUp(propertiesView);
        }
        
        
    }
}