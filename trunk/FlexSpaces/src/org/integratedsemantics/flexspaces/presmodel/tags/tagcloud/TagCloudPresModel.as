package org.integratedsemantics.flexspaces.presmodel.tags.tagcloud
{
    import com.adobe.rtc.util.ISO9075;
    
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.control.event.TagsEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;


    /**
     * Presentation model for tag cloud views 
     * 
     */
    [Bindable] 
    public class TagCloudPresModel extends PresModel
    {
        public var doSearchOnClick:Boolean = false;
        
        public var getTagsVO:GetTagsVO = null;
        

        public function TagCloudPresModel()
        {
            super();
        }
                
        /**
         * Refresh tag cloud with latest tag data 
         * 
         * @param responder responder
         * 
         */
        public function refresh(responder:Responder):void
        {
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, null);
            tagsEvent.dispatch();                        
        }                
        
        /**
         * Search on tag name
         *  
         * @param tagName semantic tag name
         * @param responder responder
         * 
         */
        public function tagSearch(tagName:String, responder:Responder):void
        {
            if (doSearchOnClick == true)
            {
                // search on nodes with this tag
                var escapedTagName:String = ISO9075.encode(tagName);
                var query:String = 'PATH:\"/cm:categoryRoot/cm:taggable/cm:' + escapedTagName + '/member\"';                   
                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
                searchEvent.dispatch();
            }                                                          
        }
                    
    }
}