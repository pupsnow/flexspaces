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
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;


    /**
     * Gets list of sub-categories within a category one level at a time for 
     * category trees, etc. via web script 
     * 
     */
    public class CategoriesDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function CategoriesDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Gets list of sub-category childen for given category (one level)
         * 
         * @param repoNode category node or node with noderef of "rootCategory" for root level  
         */
        public function getCategories(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/categories";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetCategoriesSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                
                // using e4x not default object result format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * Gets categories assigned to a node
         * 
         * @param repoNode node to get category properties on  
         */
        public function getCategoryProperties(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/categoryProperties";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onCategoryPropertiesSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                
                // using e4x not default object result format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }

        /**
         * Add category to a document / folder
         * 
         * @param repoNode node to add category to 
         * @param categoryNode category node to add 
         */
        public function addCategory(repoNode:IRepoNode, categoryNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/addCategory";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCategoriesSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                params.categorynoderef = categoryNode.getNodeRef();
                
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
         * Remove category from a document / folder
         * 
         * @param repoNode node to remove category form 
         * @param categoryNode category node to remove 
         */
        public function removeCategory(repoNode:IRepoNode, categoryNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/removeCategory";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCategoriesSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                params.categorynoderef = categoryNode.getNodeRef();
                
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
         * onCategoriesSuccess event handler
         * 
         * @param event success event
         */
        protected function onCategoriesSuccess(event:SuccessEvent):void
        {            
            notifyCaller(event.result, event);
        }

        /**
         * onGetCategoriesSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetCategoriesSuccess(event:SuccessEvent):void
        {            
            var currentNode:TreeNode = new TreeNode("", "");

            currentNode.children = new ArrayCollection();

            for each (var category:XML in event.result.category)
            {
                var childNode:TreeNode = new TreeNode(category.name, category.id);
                childNode.nodeRef = category.noderef;
                childNode.name = category.name;    
                childNode.qnamePath = category.qnamePath;                
                currentNode.children.addItem(childNode);
            }
            currentNode.hasBeenLoaded = true;
        	
            notifyCaller(currentNode, event);
        }

         /**
         * onCategoryPropertiesSuccess event handler
         * 
         * @param event success event
         */
        protected function onCategoryPropertiesSuccess(event:SuccessEvent):void
        {
        	var categoryCollection:ArrayCollection = new ArrayCollection();
        	
 			for each (var categoryXML:XML in event.result.categories.category)
 			{
 				var category:CategoryVO = new CategoryVO();
 				category.name = categoryXML.name;
 				category.id = categoryXML.id;
 				category.nodeRef = categoryXML.noderef;
 				categoryCollection.addItem(category);
 			} 
            
            notifyCaller(categoryCollection, event);
        }

   }
}