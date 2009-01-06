package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.versionlist.VersionHistoryCollection;


    /**
     *  Lists version history of an adm doc via web script
     * 
     */
    public class VersionListDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function VersionListDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets list of version history nodes for given adm doc node
         * 
         * @param repoNode adm node to get version list on
         */
        public function getVersionList(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/versionlist";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onVersionListSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                
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
         * onVersionListSuccess event handler
         * 
         * @param event success event
         */
        protected function onVersionListSuccess(event:SuccessEvent):void
        {
            var xmlData:XML = event.result as XML;
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            var versionHistoryCollection:VersionHistoryCollection = new VersionHistoryCollection();
            
            var nodeXMLCollection:XMLListCollection = new XMLListCollection(xmlData.node);
            
            versionHistoryCollection.nodeCollection = new ArrayCollection();
            
            for each (var xmlNode:XML in nodeXMLCollection)
            {
                var node:Node = new Node();
                
                node.name = xmlNode.name;
                                
                node.nodeRef = xmlNode.noderef;
                
                node.storeProtocol = xmlNode.storeProtocol;
                node.storeId = xmlNode.storeId;
                node.id = xmlNode.id;

                node.parentPath = xmlNode.parentPath;
                node.path = xmlNode.path;
                
                // strip off initial slash, add src path, so local icons will be found.
                node.icon16 = xmlNode.icon16;
                node.icon16 = model.appConfig.srcPath + node.icon16.substr(1);
                node.icon32 = xmlNode.icon32;
                node.icon32 = model.appConfig.srcPath + node.icon32.substr(1);
                node.icon64 = xmlNode.icon64;
                node.icon64 = model.appConfig.srcPath + node.icon64.substr(1);

                node.isFolder = xmlNode.isFolder == "true";
                node.type = xmlNode.type;

                node.desc = xmlNode.desc;

                node.size = xmlNode.size;

                node.created = xmlNode.created;
                node.modified = xmlNode.modified;

                node.viewurl = xmlNode.viewurl;

                node.isLocked = (xmlNode.islocked == "true");
                node.isWorkingCopy = (xmlNode.isWorkingCopy == "true");
                
                node.readPermission = (xmlNode.readPermission == "true");
                node.writePermission = (xmlNode.writePermission == "true");
                node.deletePermission = (xmlNode.deletePermission == "true");
                node.createChildrenPermission = (xmlNode.createChildrenPermission == "true");

                if (node.isFolder == true)
                {
                    node.thumbnailUrl = node.icon64;
                }
                else
                {
                    node.thumbnailUrl = versionHistoryCollection.getThumbnailUrl(node);    
                }

				node.versionLabel = xmlNode.versionLabel;
				node.creator = xmlNode.creator;

                versionHistoryCollection.nodeCollection.addItem(node);
            }
        	
            notifyCaller(versionHistoryCollection, event);
        }
        
    }
}