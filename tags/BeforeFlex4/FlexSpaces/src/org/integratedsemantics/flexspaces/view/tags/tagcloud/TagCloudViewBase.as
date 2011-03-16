package org.integratedsemantics.flexspaces.view.tags.tagcloud
{
    import flash.events.MouseEvent;
    
    import flexlib.containers.FlowBox;
    
    import mx.controls.LinkButton;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
    import org.integratedsemantics.flexspaces.model.vo.TagVO;
    import org.integratedsemantics.flexspaces.presmodel.tags.tagcloud.TagCloudPresModel;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    

    public class TagCloudViewBase extends FlowBox
    {
        [Bindable]
        public var tagCloudPresModel:TagCloudPresModel;


        public function TagCloudViewBase()
        {
            super();
        }
        
        /**
         * Handle view creation complete by requesting tag cloud data
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            refresh();
        }        
        
        public function refresh():void
        {
        	if (tagCloudPresModel != null)
        	{
            	var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            	tagCloudPresModel.refresh(responder);
        	}
        }        

        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        protected function onResultGetTags(data:Object):void
        {
        	var getTagsVO:GetTagsVO = data as GetTagsVO;
        	tagCloudPresModel.getTagsVO = getTagsVO;
        	
            var countMin:int = getTagsVO.countMin;
            var countMax:int = getTagsVO.countMax;
            var range:int = countMax - countMin;
            var scale:Number;
            if (range > 20)
            {
                scale = range / 20;
            }
            else
            {
                scale = 1;
            } 
            
            removeAllChildren();
            
            for each (var tag:TagVO in getTagsVO.tags)
            {
                var linkButton:LinkButton = new LinkButton();
                var count:int = tag.count;
                linkButton.label = tag.name;
                linkButton.setStyle("paddingLeft", 1);
                linkButton.setStyle("paddingRight", 1);
                var size:int = 10 + Math.round((count - countMin) / scale);              
                linkButton.setStyle("fontSize", size);
                linkButton.addEventListener(MouseEvent.CLICK, onTagClick);      
                addChild(linkButton);     
            }                       
        }
        
        /**
         * Handler for get tags fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultGetTags(info:Object):void
        {
            trace("onFaultGetTags" + info);            
        }    
        
        /**
         * Handler called when a tag is clicked on
         *  
         * @param event click event
         * 
         */
        protected function onTagClick(event:MouseEvent):void
        {
            if (tagCloudPresModel.doSearchOnClick == true)
            {
                // get tag name
                var linkButton:LinkButton = event.target as LinkButton;
                var tagName:String = linkButton.label;
                
                // search on nodes with this tag
                var responder:Responder = new Responder(onResultSearch, onFaultSearch);
                tagCloudPresModel.tagSearch(tagName, responder);
            }                                                          
        }
        
        /**
         * Handler called when search service successfully returns results
         * 
         * @parm data search results data
         */
        protected function onResultSearch(data:Object):void
        {
            var searchResultsEvent:SearchResultsEvent = new SearchResultsEvent(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, data);
            var dispatched:Boolean = dispatchEvent(searchResultsEvent);                        
        }

        /**
         * Handle fault in search operation
         * 
         * @param info fault info
         */
        protected function onFaultSearch(info:Object):void
        {
            trace("onFaultSearch " + info);     
        }        
        
        
    }
}