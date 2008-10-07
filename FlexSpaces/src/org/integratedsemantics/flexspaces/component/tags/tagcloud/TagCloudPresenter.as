package org.integratedsemantics.flexspaces.component.tags.tagcloud
{
    import flash.events.MouseEvent;
    
    import mx.collections.XMLListCollection;
    import mx.controls.LinkButton;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.control.event.TagsEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;


    public class TagCloudPresenter extends Presenter
    {
        public var doSearchOnClick:Boolean = false;
        

        public function TagCloudPresenter(tagCloudView:TagCloudViewBase)
        {
            super(tagCloudView);

            if (tagCloudView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(tagCloudView, onCreationComplete);            
            }                        
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get tagCloudView():TagCloudViewBase
        {
            return this.view as TagCloudViewBase;            
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
        
        /**
         * Refresh tag cloud with latest tag data 
         * 
         */
        public function refresh():void
        {
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, null);
            tagsEvent.dispatch();                        
        }
        
        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        protected function onResultGetTags(data:Object):void
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
            if (doSearchOnClick == true)
            {
                // get tag name
                var linkButton:LinkButton = event.target as LinkButton;
                var tagName:String = linkButton.label;
                
                // search on nodes with this tag
                var query:String = 'PATH:\"/cm:categoryRoot/cm:taggable/cm:' + tagName + '/member\"';                   
                var responder:Responder = new Responder(onResultSearch, onFaultSearch);
                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
                searchEvent.dispatch();
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
            var dispatched:Boolean = tagCloudView.dispatchEvent(searchResultsEvent);                        
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