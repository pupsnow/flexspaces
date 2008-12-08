package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Provides listing all tags, listing/adding/removing tags assoicated with a node via web scripts
     * 
     */
    public class SemanticTagsDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function SemanticTagsDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
		 * Gets semantic tags data (for semantic tag clouds)
		 * (and tags are a particular semantic category or all semantic categories)
         * 
         * @param semanticCategory semantic category or null for all semantic categories 
         */
        public function getSemanticTags(semanticCategory:String=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/getSemanticTags";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onTagsDataSuccess);
                
                var params:Object = new Object();
                               
                if (semanticCategory != null)
                {
					params.semanticCat = semanticCategory;                	
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
         * Gets semantic tags associated with an adm document / folder
         * 
         * @param repoNode node to get tags for 
         */
        public function getNodeSemanticTags(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/nodeSemanticTags";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onTagsDataSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                
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
         * Semantically auto-tag a doc node
         * 
         * @param repoNode node to auto tag 
         */
        public function autoTag(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/autoTag";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onTagsDataSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                
				var model:AppModelLocator = AppModelLocator.getInstance();                                
                params.key = model.calaisKey;
                
                params.autoTag = "true";
                
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
         * Get semantic tag suggestions for a doc node
         * 
         * @param repoNode node to suggest tags for
         */
        public function suggestTags(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/tagSuggestList";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onTagsDataSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                
				var model:AppModelLocator = AppModelLocator.getInstance();                                
                params.key = model.calaisKey;
                
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
         * Add new semantic tag 
         * 
         * @param tagName	name of new tag
         * @param semanticCategoryName  new of parent semantic category for tag
         * @param repoNode	optional node to add tag to
         * @param normalizedName resolved more standard name  
         * @param latitude  geo-location latitude coordinate
         * @param longitude geo-location longitude coordinate
         * @param linkedDataURI calais linked data / semantic web unique id / uri for tag
         * @param website  website url for companies
         * @param stockTicker stock ticker symbol for companies (not stored yet)
         * 
         */
        public function addNewSemanticTag(tagName:String, semanticCategoryName:String, repoNode:IRepoNode=null, normalizedName:String=null,
							           latitude:String=null, longitude:String=null, linkedDataURI:String=null, 
							           website:String=null, stockTicker:String=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/addNewSemanticTag";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onTagsDataSuccess);
                
                var params:Object = new Object();
        
               	params.tagname = tagName;
               	params.semanticCat = semanticCategoryName;
                
				if (repoNode != null)
				{
                	params.noderef = repoNode.getNodeRef();
    			}
				if ((normalizedName != null) && (normalizedName != ""))
				{
                	params.normalized = normalizedName;
                	params.tagname = normalizedName;
    			}
				if ((latitude != null) && (latitude != ""))
				{
                	params.latitude = latitude;
    			}
				if ((longitude != null) && (longitude != ""))
				{
                	params.longitude = longitude;
    			}
				if ((linkedDataURI != null) && (linkedDataURI != ""))
				{
                	params.uri = linkedDataURI;
    			}
				if ((website != null) && (website != ""))
				{
                	params.website = website;
    			}
				if ((stockTicker != null) && (stockTicker != ""))
				{
                	params.ticker = stockTicker;
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
         * Add semantic tag to an adm document / folder
         * 
         * @param repoNode node to add tag to
         * @param tagNode semantic tag node to add 
         * 
         */
        public function addSemanticTag(repoNode:IRepoNode, tagNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/addNodeSemanticTag";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onTagsDataSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                params.tagnoderef = tagNode.getNodeRef();
                
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
         * Remove semantic tag from an adm document / folder
         * 
         * @param repoNode node to  remove tag from 
         * @param tagNode semantic tag node to add 
         * 
         */
        public function removeSemanticTag(repoNode:IRepoNode, tagNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/removeNodeSemanticTag";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onTagsDataSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                params.tagnoderef = tagNode.getNodeRef();
                
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
		 * Gets semantic tag category/tag tree data, one level of children
		 * a time from a given semantic tag cateogry tree node) 
         * 
         * @param repoNode semantic tag category node or node with noderef of "rootCategory" for 
         *                 root level semantic tag categories 
         *  
         */
        public function getSemanticTagTree(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/semantics/semanticTagTree";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onTagsDataSuccess);
                
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
         * onTagsDataSuccess event handler
         * 
         * @param event success event
         */
        protected function onTagsDataSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }
        
    }
}