package org.integratedsemantics.flexspaces.presmodel.rename
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.properties.GetPropertiesEvent;
    import org.integratedsemantics.flexspaces.control.event.properties.SetPropertiesEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.PropertiesVO;

    
    /**
     *  Presentation model for Rename dialog for changing the name of docs/folders
     *  
     */
    [Bindable] 
    public class RenamePresModel extends PresModel
    {
        public var repoNode:IRepoNode;
        
        public var wcmMode:Boolean;

        public var isFolder:Boolean = false;
        public var isAvmStore:Boolean = false;

        public var vo:PropertiesVO = new PropertiesVO();
        
        public var nameEditable:Boolean = true;

               
        /**
         * Constructor 
         * 
         * @param repoNode  node path (full path without store id if avm)
         * @param wcmMode  is this for a wcm/avm node
         * 
         */
        public function RenamePresModel(repoNode:IRepoNode, wcmMode:Boolean=false)
        {
            this.repoNode = repoNode;
            
            this.wcmMode = wcmMode;
            
            if (isAvmStore == true)
            {
                // for avm stores use name area for viewing storeid
                vo.name = repoNode.getStoreId();
                nameEditable = false;
            } 
            
        }
        
        /**
         * Get properties by requesting properties data from server 
         * 
         */
        public function getProperties():void
        {
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
                    isAvmStore = true;
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
           vo = data as PropertiesVO;

            if (vo.isFolder == true)
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
         * set properties on the repoNode
         * 
         * @param responder responder 
         * @param name new name
         * 
         */
        public function setProperties(responder:Responder):void 
        {            
            if (wcmMode == false)
            {
                var setPropertiesEvent:SetPropertiesEvent = new SetPropertiesEvent(SetPropertiesEvent.SET_PROPERTIES, 
                                                                                   responder, repoNode, vo.name);
                setPropertiesEvent.dispatch();
            }
            else
            {
                if (isAvmStore == false)
                {
                    setPropertiesEvent = new SetPropertiesEvent(SetPropertiesEvent.SET_AVM_PROPERTIES, responder, repoNode, vo.name);
                    setPropertiesEvent.dispatch();
                }
            }                                      
        }

        public function updateName(name:String):void
        {
        	this.vo.name = name;	
        }
        
    }
}