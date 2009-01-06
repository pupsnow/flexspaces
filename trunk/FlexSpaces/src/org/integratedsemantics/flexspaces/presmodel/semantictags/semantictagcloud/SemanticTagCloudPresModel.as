package org.integratedsemantics.flexspaces.presmodel.semantictags.semantictagcloud
{
	import com.adobe.rtc.util.ISO9075;
	
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.control.event.SearchEvent;
	import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
	import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
	import org.integratedsemantics.flexspaces.presmodel.tags.tagcloud.TagCloudPresModel;
	
   
	/**
	 * Presentation model for semantic tag cloud view
	 * 
	 */
	[Bindable] 
	public class SemanticTagCloudPresModel extends TagCloudPresModel
	{		
		// semantic category of tag cloud (Company, Person, Country, etc.) or null for all semantic categories
		public var semanticCategory:String = null;
		
		public function SemanticTagCloudPresModel(semanticCategory:String=null)
		{
			super();
			
			this.semanticCategory = semanticCategory;
		}
		
        /**
         * Refresh tag cloud with latest tag data 
         * 
         * @param responder responder
         * 
         */
        override public function refresh(responder:Responder):void
        {
            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAGS, responder, null, null, semanticCategory);
            tagsEvent.dispatch();                        
        }
                
        
        /**
         * Search on tag name
         *  
         * @param tagName semantic tag name
         * @param responder responder
         * 
         */
        override public function tagSearch(tagName:String, responder:Responder):void
        {
            if (doSearchOnClick == true)
            {
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

                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
                searchEvent.dispatch();
            }                                                          
        }
        			
	}
}