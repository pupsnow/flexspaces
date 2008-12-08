package org.integratedsemantics.flexspaces.component.semantictags.semantictagcloud
{
	import flash.events.MouseEvent;
	
	import mx.collections.XMLListCollection;
	import mx.controls.LinkButton;
	import mx.rpc.Responder;
	import com.adobe.rtc.util.ISO9075;
	import org.integratedsemantics.flexspaces.component.tags.tagcloud.TagCloudPresenter;
	import org.integratedsemantics.flexspaces.component.tags.tagcloud.TagCloudViewBase;
	import org.integratedsemantics.flexspaces.control.command.search.QueryBuilder;
	import org.integratedsemantics.flexspaces.control.event.SearchEvent;
	import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
	

	public class SemanticTagCloudPresenter extends TagCloudPresenter
	{
		// semantic category of tag cloud (Company, Person, Country, etc.) or null for all semantic categories
		public var semanticCategory:String = null;
		
		public function SemanticTagCloudPresenter(tagCloudView:TagCloudViewBase, semanticCategory:String=null)
		{
			super(tagCloudView);
			
			this.semanticCategory = semanticCategory;
		}
		
        /**
         * Refresh tag cloud with latest tag data 
         * 
         */
        override public function refresh():void
        {
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAGS, responder, null, null, semanticCategory);
            tagsEvent.dispatch();                        
        }
        
        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        override protected function onResultGetTags(data:Object):void
        {
            var countMin:int = data.countMin;
            var countMax:int = data.countMax;
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
            
            tagCloudView.removeAllChildren();
            var tagCollection:XMLListCollection = new XMLListCollection(data.tags.tag); 
            for each (var xmlTag:XML in tagCollection)
            {
                var linkButton:LinkButton = new LinkButton();
                var count:int = xmlTag.count;
                //linkButton.label = xmlTag.name + " (" + count + ")";
                linkButton.label = xmlTag.name;
                linkButton.setStyle("paddingLeft", 1);
                linkButton.setStyle("paddingRight", 1);
                //linkButton.setStyle("textDecoration", "underline");
                var size:int = 10 + Math.round((count - countMin) / scale);              
                linkButton.setStyle("fontSize", size);
                linkButton.addEventListener(MouseEvent.CLICK, onTagClick);      
                tagCloudView.addChild(linkButton);     
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
            if (doSearchOnClick == true)
            {
                // get tag name
                var linkButton:LinkButton = event.target as LinkButton;
                var tagName:String = linkButton.label;
                
                // search on nodes with this tag
                var escapedTagName:String = ISO9075.encode(tagName);
                
                if (semanticCategory == null)
                {
                	var query:String = 'PATH:\"/cm:semantictaggable//cm:' + escapedTagName + '//*\"';                   
                }
                else
                {
	                var escapedSemanticCat:String = ISO9075.encode(semanticCategory);
                	query = 'PATH:\"/cm:semantictaggable/cm:' + escapedSemanticCat + '/cm:' + escapedTagName + '//*\"';                                   	
                }

                var responder:Responder = new Responder(onResultSearch, onFaultSearch);
                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
                searchEvent.dispatch();
            }                                                          
        }
        			
	}
}