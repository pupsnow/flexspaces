package org.integratedsemantics.flexspaces.component.semantictags.map
{
    import com.adobe.rtc.util.ISO9075;
    import com.google.maps.Color;
    import com.google.maps.LatLng;
    import com.google.maps.MapMouseEvent;
    import com.google.maps.overlays.Marker;
    import com.google.maps.overlays.MarkerOptions;
    
    import flash.events.Event;
    
    import mx.collections.XMLListCollection;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.map.MapPresenter;
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;


	/**
	 * Presenter of semantic tags with geo-location info on a google map view
	 * 
	 * Presenter of SemanticTagMapViewBase views
	 * 
	 */
    public class SemanticTagMapPresenter extends MapPresenter
    {
        public var doSearchOnClick:Boolean = false;
        

        public function SemanticTagMapPresenter(semanticTagMapView:SemanticTagMapViewBase)
        {
            super(semanticTagMapView);

            if (semanticTagMapView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(semanticTagMapView, onCreationComplete);            
            }                        
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get semanticTagMapView():SemanticTagMapViewBase
        {
            return this.view as SemanticTagMapViewBase;            
        }        
        
        /**
         * Handle view creation complete by requesting tag cloud data
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void       
        {
			super.onCreationComplete(event);			        	
        }        

        override protected function onMapReady(event:Event):void
        {
        	super.onMapReady(event);	
        	
        	refresh();
        }

        /**
         * Refresh map view with latest tag data 
         * 
         */
        public function refresh():void
        {
            semanticTagMapView.clearOverlays();

            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAGS, responder, null, null);
            tagsEvent.dispatch();                        
        }
        
        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        protected function onResultGetTags(data:Object):void
        {           
            var markerOptions:MarkerOptions = new MarkerOptions({ 
            	strokeStyle: {color: 0x000000},
            	fillStyle: {color: Color.YELLOW, alpha: 0.6},
            	radius: 10,
            	hasShadow: false});
            
            var tagCollection:XMLListCollection = new XMLListCollection(data.tags.tag); 
            for each (var xmlTag:XML in tagCollection)
            {
            	if ((xmlTag.latitude != "") && (xmlTag.longitude != ""))
            	{
            		var lat:Number = new Number(xmlTag.latitude);
            		var long:Number = new Number(xmlTag.longitude);
            		var latLong:LatLng = new LatLng(lat, long);
            		markerOptions.tooltip = xmlTag.name;
            		var marker:Marker = new Marker(latLong, markerOptions);
            		marker.addEventListener(MapMouseEvent.CLICK, onTagClick);
            		semanticTagMapView.addOverlay(marker);
            	}
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
        protected function onTagClick(event:MapMouseEvent):void
        {
            if (doSearchOnClick == true)
            {
            	if (event.target is Marker)
            	{
	                // get tag name
	                var marker:Marker = event.target as Marker;
	                var markerOptions:MarkerOptions = marker.getOptions();
	                var tagName:String = markerOptions.tooltip; 
	                
	                if (tagName != null)
	                {
		                // search on nodes with this tag
		                var escapedTagName:String = ISO9075.encode(tagName);
		                
						var query:String = 'PATH:\"/cm:semantictaggable//cm:' + escapedTagName + '//*\"';                   
		                
		                var responder:Responder = new Responder(onResultSearch, onFaultSearch);
		                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
		                searchEvent.dispatch();
	                }
             	}
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
            var dispatched:Boolean = semanticTagMapView.dispatchEvent(searchResultsEvent);                        
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