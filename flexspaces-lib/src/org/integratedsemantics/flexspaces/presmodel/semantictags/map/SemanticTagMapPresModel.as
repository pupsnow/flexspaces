package org.integratedsemantics.flexspaces.presmodel.semantictags.map
{
    import com.adobe.rtc.util.ISO9075;
    
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
    import org.integratedsemantics.flexspaces.presmodel.map.MapPresModel;


	/**
	 * Presentation model of semantic tags with geo-location info on a google map view
	 * 
	 */
	[Bindable] 
    public class SemanticTagMapPresModel extends MapPresModel
    {
        public var getTagsVO:GetTagsVO = null;

        public var doSearchOnClick:Boolean = false;

        
        public function SemanticTagMapPresModel()
        {
            super();
        }
        
        /**
         * Refresh map view with latest tag data 
         * 
         */
        public function refresh(responder:Responder):void
        {
            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAGS, responder, null, null);
            tagsEvent.dispatch();                        
        }
                        
        /**
         * Search on semantic tag name
         *  
         * @param tagName semantic tag name
         * @param responder responder
         * 
         */
        public function tagSearch(tagName:String, responder:Responder):void
        {
            if (doSearchOnClick == true)
            {
                if (tagName != null)
                {
	                // search on nodes with this tag
	                var escapedTagName:String = ISO9075.encode(tagName);
	                
					var query:String = 'PATH:\"/cm:semantictaggable//cm:' + escapedTagName + '//*\"';                   
	                
	                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
	                searchEvent.dispatch();
                }
            }                                                          
        }
                    
    }
}