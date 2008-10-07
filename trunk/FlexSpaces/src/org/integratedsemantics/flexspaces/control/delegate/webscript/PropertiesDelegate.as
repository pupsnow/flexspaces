package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.PropertiesVO;


    /**
     * Gets properties and sets properties of adm and avm nodes via web scripts 
     * 
     */
    public class PropertiesDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function PropertiesDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
              
        /**
         * Gets properties data for adm document / folder
         * 
         * @param repoNode adm node to get properties for 
         */
        public function getProperties(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/getProperties";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetPropertiesDataSuccess);
                
                var params:Object = new Object();
                
                params.path = repoNode.getPath();
                
                // using e4x instead of default object result format
                webScript.resultFormat = "e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * Gets properties data for avm file / folder
         * 
         * @param repoNode avm node to get properties for
         *  
         */
        public function getAvmProperties(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/getProperties";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetPropertiesDataSuccess);
                
                var params:Object = new Object();
                
                params.storeid = repoNode.getStoreId();
                params.path = repoNode.getPath();
                
                // using e4x instead of default object result format
                webScript.resultFormat = "e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }

        /**
         * Sets properties data for adm document / folder
         *  
         * @param repoNode adm node
         * @param name new name property value
         * @param title new title property value
         * @param description new description property value
         * @param author new author property value
         * 
         */
        public function setProperties(repoNode:IRepoNode, name:String, title:String=null, description:String=null, author:String=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/setProperties";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onSetPropertiesDataSuccess);
                
                var params:Object = new Object();
                
                params.path = repoNode.getPath();
                
                if (name != null)
                {
                    params.name = name;
                }
                
                if (title != null)
                {
                    params.title = title;
                }
                
                if (description != null)
                {
                    params.description = description;
                }
                
                if (author != null)
                {
                    params.author = author;
                }
                
                // using e4x instead of default object result format
                webScript.resultFormat = "e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }

        /**
         * Sets properties data for avm document / folder
         *  
         * @param repoNode avm node 
         * @param name new name property value
         * @param title new title property value
         * @param description new description property value
         * 
         */
        public function setAvmProperties(repoNode:IRepoNode, name:String, title:String=null, description:String=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/setProperties";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onSetPropertiesDataSuccess);
                
                var params:Object = new Object();
                
                params.storeid = repoNode.getStoreId();
                params.path = repoNode.getPath();
                
                if (name != null)
                {
                    params.name = name;
                }
                
                if (title != null)
                {
                    params.title = title;
                }
                
                if (description != null)
                {
                    params.description = description;
                }
                
                // using e4x instead of default object result format
                webScript.resultFormat = "e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }

        /**
         * onGetPropertiesDataSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetPropertiesDataSuccess(event:SuccessEvent):void
        {
            var result:XML = event.result as XML;               
            
            var propertiesVO:PropertiesVO = new PropertiesVO;
            propertiesVO.name = result.node.name;
            propertiesVO.title = result.node.title;
            propertiesVO.description = result.node.description;
            propertiesVO.author = result.node.author;
            propertiesVO.size = result.node.size;
            propertiesVO.creator = result.node.creator;
            propertiesVO.created = result.node.created;
            propertiesVO.modifier = result.node.modifier;
            propertiesVO.modified = result.node.modified;
            propertiesVO.emailid = result.node.emailid;
            propertiesVO.mimetype = result.node.mimetype;
            propertiesVO.isFolder = (result.node.isFolder == "true");
            
            notifyCaller(propertiesVO, event);
        }
        
        /**
         * onSetPropertiesDataSuccess event handler
         * 
         * @param event success event
         */
        protected function onSetPropertiesDataSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }        
        
    }
}