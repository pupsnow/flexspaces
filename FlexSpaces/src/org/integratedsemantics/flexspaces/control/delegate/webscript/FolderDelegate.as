package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.TemplateVO;


    /**
     * Provides creation of adm spaces and avm folders via web scripts
     * 
     */
    public class FolderDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function FolderDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Creates new adm space
         *  
         * @param parentNode parent folder node to create new space in
         * @para newName name for new folder
         * @param newTitle title for new space
         * @param newDesc decription for new space
         * @param templateNode space template to use
         * @param iconName symbolic name of icon to use for space
         * 
         */
        public function newSpace(parentNode:IRepoNode, newName:String, newTitle:String=null,
                                 newDesc:String=null, templateNode:IRepoNode=null, iconName:String=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/createSpace";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCreateSpaceSuccess);
                
                var params:Object = new Object();
                
                params.parentpath = parentNode.getPath();
                params.sn = newName;
                params.st = newTitle;
                params.sd = newDesc;
                params.t = templateNode.getId();
                params.icon = iconName;
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }

        /**
         * Returns list of space templates
         */
        public function getSpaceTemplates():void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/spaceTemplates";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onSpaceTemplatesSuccess);
                
                var params:Object = new Object();
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }

        /**
         * Creates new avm folder
         * 
         * @param parentNode parent avm folder node to create new folder in
         * @param newName name for new folder
         * @param newTitle title for new folder
         * @param newDesc description for new folder
         * 
         */
        public function createAvmFolder(parentNode:IRepoNode, newName:String, newTitle:String=null, newDesc:String=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/wcm/createFolder";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCreateAvmFolderSuccess);
                
                var params:Object = new Object();
                
                params.storeid = parentNode.getStoreId();
                params.parentpath = parentNode.getPath();
                params.name = newName;
                params.title = newTitle;
                params.desc = newDesc;
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onCreateSpaceSuccess event handler
         * 
         * @param event success event
         */
        protected function onCreateSpaceSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }        

        /**
         * onCreateAvmFolderSuccess event handler
         * 
         * @param event success event
         */
        protected function onCreateAvmFolderSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }                
        
        /**
         * onSpaceTemplatesSuccess event handler
         * 
         * @param event success event
         */
        protected function onSpaceTemplatesSuccess(event:SuccessEvent):void
        {
        	var templateCollection:ArrayCollection = new ArrayCollection();
       	
 			for each (var templateXML:XML in event.result.template)
 			{
 				var template:TemplateVO = new TemplateVO();
 				template.name = templateXML.name;
 				template.id = templateXML.id;
 				templateCollection.addItem(template);
 			} 

            notifyCaller(templateCollection, event);
        }        
        
    }
}