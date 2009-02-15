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
    import org.integratedsemantics.flexspaces.model.favorites.FavoritesCollection;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Provides favorites/shortcuts operations via web scripts 
     * 
     */
    public class FavoritesDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function FavoritesDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets list of favorites
         * 
         */
        public function getFavoritesList():void
        {
            try
            {                
                var url:String = ConfigService.instance.url +  "/flexspaces/favorites/favoritesList";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onFavoritesListSuccess);
                
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
         * onFavoritesListSuccess event handler
         * 
         * @param event success event
         */
        protected function onFavoritesListSuccess(event:SuccessEvent):void
        {
            var xmlData:XML = event.result as XML;
            
            var model:AppModelLocator = AppModelLocator.getInstance();            
            
            var favoritesCollection:FavoritesCollection = new FavoritesCollection();
                        
            var nodeXMLCollection:XMLListCollection = new XMLListCollection(xmlData.node);
            
            favoritesCollection.nodeCollection = new ArrayCollection();
            
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
                node.mimetype = xmlNode.mimetype;

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
                    node.thumbnailUrl = favoritesCollection.getThumbnailUrl(node);    
                }

                favoritesCollection.nodeCollection.addItem(node);
            }
        	
            notifyCaller(favoritesCollection, event);
        }
        
        /**
         * Add new favorite / shortcut for node for current user
         * 
         * @param repoNode node to add favorite for
         */
        public function newFavorite(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/favorites/newFavorite";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.PUT, onAddActionSuccess);
                
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
         * onAddActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onAddActionSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);            
        }        

        /**
         * Delete favorite / shortcut for node for current user
         * 
         * @param repoNode node to delete favorite for
         */
        public function deleteFavorite(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/favorites/deleteFavorite";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.DELETE, onDeleteActionSuccess);
                
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
         * onDeleteActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onDeleteActionSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);            
        }                
        
    }
}