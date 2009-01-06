package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
    import org.integratedsemantics.flexspaces.model.vo.TagVO;


    /**
     * Provides listing all tags, listing/adding/removing tags assoicated with a node via web scripts
     * 
     */
    public class TagsDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function TagsDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets tags associated with an adm document / folder
         * 
         * @param repoNode node to get tags for or null for all tags 
         */
        public function getTags(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/getTags";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetTagsSuccess);
                
                var params:Object = new Object();
                
                if (repoNode != null)
                {
                    params.noderef = repoNode.getNodeRef();
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
         * Add tag to an adm document / folder
         * 
         * @param tagName name of tag to add 
         * @param repoNode node to add tag to or null 
         */
        public function addTag(tagName:String, repoNode:IRepoNode=null):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/addTag";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onAddTagSuccess);
                
                var params:Object = new Object();
                
                params.tag = tagName;
                if (repoNode != null)
                {
                    params.noderef = repoNode.getNodeRef();
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
         * Remove tag from an adm document / folder
         * 
         * @param tagName name of tag to remove
         * @param repoNode node to  remove tag from 
         */
        public function removeTag(tagName:String, repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/removeTag";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onRemoveTagSuccess);
                
                var params:Object = new Object();
                
                params.tag = tagName;
                if (repoNode != null)
                {
                    params.noderef = repoNode.getNodeRef();
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
         * onAddTagSuccess event handler
         * 
         * @param event success event
         */
        protected function onAddTagSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

        /**
         * onRemoveTagSuccess event handler
         * 
         * @param event success event
         */
        protected function onRemoveTagSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

        /**
         * onGetTagsSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetTagsSuccess(event:SuccessEvent):void
        {
        	var getTagsVO:GetTagsVO = new GetTagsVO();
        	            
            getTagsVO.countMin = event.result.countMin;
            getTagsVO.countMax = event.result.countMax;
            
            for each (var tagXML:XML in event.result.tags.tag)
            {
            	var tag:TagVO = new TagVO();
            	tag.name = tagXML.name;
            	tag.count = tagXML.count;
                getTagsVO.tags.addItem(tag);     
            }                       
            
            notifyCaller(getTagsVO, event);
        }
        
    }
}