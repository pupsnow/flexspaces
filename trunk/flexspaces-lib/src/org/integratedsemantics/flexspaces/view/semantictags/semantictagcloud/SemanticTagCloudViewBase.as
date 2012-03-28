package org.integratedsemantics.flexspaces.view.semantictags.semantictagcloud
{
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	import mx.events.FlexEvent;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
	import org.integratedsemantics.flexspaces.model.vo.TagVO;
	import org.integratedsemantics.flexspaces.presmodel.semantictags.semantictagcloud.SemanticTagCloudPresModel;
	import org.integratedsemantics.flexspaces.view.tags.tagcloud.TagCloudViewBase;


    public class SemanticTagCloudViewBase extends TagCloudViewBase
    {
    	
        /**
         * Constructor 
         * 
         */
        public function SemanticTagCloudViewBase()
        {
            super();
        }

        /**
         * Getter for the semantic tag cloud pres model
         *  
         * @return the pres model
         * 
         */
        protected function get semanticTagCloudPresModel():SemanticTagCloudPresModel
        {
            return this.tagCloudPresModel as SemanticTagCloudPresModel;            
        }       

        /**
         * Handle view creation complete
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            refresh();
        }        

        override public function refresh():void
        {
        	if (semanticTagCloudPresModel != null)
        	{
	            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
	            semanticTagCloudPresModel.refresh(responder);
         	}
        }        

        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        override protected function onResultGetTags(data:Object):void
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
        override protected function onFaultGetTags(info:Object):void
        {
            trace("onFaultGetTags" + info);            
        }            
        
        /**
         * Handler called when a tag is clicked on
         *  
         * @param event click event
         * 
         */
        override protected function onTagClick(event:MouseEvent):void
        {
            if (semanticTagCloudPresModel.doSearchOnClick == true)
            {
                // get tag name
                var linkButton:LinkButton = event.target as LinkButton;
                var tagName:String = linkButton.label;
                
                // search on nodes with this semantic tag
                var responder:Responder = new Responder(onResultSearch, onFaultSearch);
                semanticTagCloudPresModel.tagSearch(tagName, responder);
            }                                                          
        }
        
    }
}