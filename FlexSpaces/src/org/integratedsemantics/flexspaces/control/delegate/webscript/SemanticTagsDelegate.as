package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;
    import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
    import org.integratedsemantics.flexspaces.model.vo.TagVO;


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
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetSemanticTagsSuccess);
                
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
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetNodeSemanticTagsSuccess);
                
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
                params.key = model.calaisConfig.calaisKey;
                
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
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onSuggestTagsSuccess);
                
                var params:Object = new Object();
                
                params.noderef = repoNode.getNodeRef();
                
				var model:AppModelLocator = AppModelLocator.getInstance();                                
                params.key = model.calaisConfig.calaisKey;
                
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
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetSemanticTagTreeSuccess);
                
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
      
        /**
         * onGetNodeSemanticTagsSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetNodeSemanticTagsSuccess(event:SuccessEvent):void
        {
        	var categoryCollection:ArrayCollection = new ArrayCollection();
        	
 			for each (var categoryXML:XML in event.result.tags.tag)
 			{
 				var category:CategoryVO = new CategoryVO();
 				category.name = categoryXML.name;
 				category.id = categoryXML.id;
 				category.nodeRef = categoryXML.noderef;
 				categoryCollection.addItem(category);
 			} 
        	
            notifyCaller(categoryCollection, event);
        }

        /**
         * onGetSemanticTagsSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetSemanticTagsSuccess(event:SuccessEvent):void
        {
        	var getTagsVO:GetTagsVO = new GetTagsVO();
        	            
            getTagsVO.countMin = event.result.countMin;
            getTagsVO.countMax = event.result.countMax;
            
            for each (var tagXML:XML in event.result.tags.tag)
            {
            	var tag:TagVO = new TagVO();
            	tag.name = tagXML.name;
            	tag.count = tagXML.count;
            	tag.latitude = tagXML.latitude;
            	tag.longitude = tagXML.longitude;
                getTagsVO.tags.addItem(tag);     
            }                       
            
            notifyCaller(getTagsVO, event);
        }
           
        /**
         * onGetSemanticTagTreeSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetSemanticTagTreeSuccess(event:SuccessEvent):void
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
         * onSuggestTagsSuccess event handler
         * 
         * @param event success event
         */
        protected function onSuggestTagsSuccess(event:SuccessEvent):void
        {            
            var rootNode:SemanticTagTreeNode = new SemanticTagTreeNode("", "rootCategory");
            rootNode.nodeRef = "rootCategory";  

            for each (var category:XML in event.result.type)
            {
            	var typeName:String = category.@name;
                var typeNode:SemanticTagTreeNode = new SemanticTagTreeNode(typeName, typeName);
                typeNode.name = typeName;    
                rootNode.children.addItem(typeNode);

                for each (var tag:XML in category.tag)
                {
                	var tagName:String = tag.name;
                	if (tag.normalized != "")
                	{
						tagName = tag.normalized;	                		
                	}
                    var tagNode:SemanticTagTreeNode = new SemanticTagTreeNode(tagName, tag.nameURI);
                    
                    tagNode.name = tag.name;    
                    tagNode.uri = tag.nameURI;
                    tagNode.relevance = tag.relevance;
                    tagNode.normalizedName = tag.normalized;
                    tagNode.latitude = tag.latitude;
                    tagNode.longitude = tag.longitude;
                    tagNode.website = tag.website;
                    tagNode.ticker = tag.ticker;
                    tagNode.semanticCategoryName = typeName;
                    
                    typeNode.children.addItem(tagNode);
                }
            }
            
            notifyCaller(rootNode, event);
        }
                      
    }
}




