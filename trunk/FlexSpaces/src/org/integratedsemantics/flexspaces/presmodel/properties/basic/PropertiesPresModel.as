package org.integratedsemantics.flexspaces.presmodel.properties.basic
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.properties.GetPropertiesEvent;
    import org.integratedsemantics.flexspaces.control.event.properties.SetPropertiesEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.PropertiesVO;

    /**
     *  Properties dialog presentation model for viewing and editing basic properties of docs/folders
     *  
     */
    [Bindable] 
    public class PropertiesPresModel extends PresModel
    {
        public var repoNode:IRepoNode;
        
        public var wcmMode:Boolean;
        
        public var isFolder:Boolean = false;
        public var isAvmStore:Boolean = false;
        
        public var vo:PropertiesVO = new PropertiesVO();
        
        public var okVisible:Boolean = true;
        public var cancelVisible:Boolean = true;
        public var closeVisible:Boolean = false;

        public var authorVisible:Boolean = true;
        public var emailIdVisible:Boolean = true;

        public var titleVisible:Boolean = true;
        public var descriptionVisible:Boolean = true;
        public var sizeVisible:Boolean = true;
        public var mimetypeVisible:Boolean = true;
        
        public var nameEditable:Boolean = true;
        public var titleEditable:Boolean = true;
        public var descriptionEditable:Boolean = true;

                        
        /**
         * Constructor 
         * 
         * @param repoNode node to get / set properties on
         * @param wcmMode  is this for a wcm/avm node
         * 
         */
        public function PropertiesPresModel(repoNode:IRepoNode, wcmMode:Boolean=false, onComplete:Function=null)
        {
            super();
            
            this.repoNode = repoNode;
            
            this.wcmMode = wcmMode;
            
            if (repoNode.getIsFolder() == true)
            {
				authorVisible = false;
				sizeVisible = false;            	
            	mimetypeVisible = false;
            }
          
            if (wcmMode == true)
            {
                authorVisible = false;
                emailIdVisible = false;
                
                if (isAvmStore == true)
                {
                    vo.name = repoNode.getStoreId();                    
                    nameEditable = false;
                    
                    titleVisible = false;
                    descriptionVisible = false;
                    authorVisible = false;
                    sizeVisible = false;
                    mimetypeVisible = false;
                }
                else
                {
                    // for avm nodes, make fields other than name readonly since 
                    // javascript api to set properties on avm nodes does not work
                    titleEditable = false; 
                    descriptionEditable = false;
                }                
            }
            
            // disable ok,cancel, have close if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                okVisible = false;
                cancelVisible = false;
                closeVisible = true;
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
                if (repoNode.getPath() == "/" )
                {
                    isAvmStore = true;
                    isFolder = true;
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
         * handler called when get properties successfully completed
         * 
         * @param data properties data
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
         * 
         */
        public function setProperties(responder:Responder):void 
        {
            if (wcmMode == false)
            {
                var setPropertiesEvent:SetPropertiesEvent = new SetPropertiesEvent(SetPropertiesEvent.SET_PROPERTIES, responder, repoNode, 
                		vo.name, vo.title, vo.description, vo.author);
                setPropertiesEvent.dispatch();
            }
            else
            {
                if (isAvmStore == false)
                {
                    setPropertiesEvent= new SetPropertiesEvent(SetPropertiesEvent.SET_AVM_PROPERTIES, responder, repoNode, vo.name);
                    setPropertiesEvent.dispatch();
                }
            }                          
        }
        
        public function updateName(name:String):void
        {
        	this.vo.name = name;	
        }

        public function updateTitle(title:String):void
        {
        	this.vo.title = title;	
        }

        public function updateDescription(desc:String):void
        {
        	this.vo.description = desc;	
        }
        
        public function updateAuthor(author:String):void
        {
        	this.vo.author = author;	
        }
                
    }
}