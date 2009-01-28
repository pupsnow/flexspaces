package org.integratedsemantics.flexspaces.view.semantictags.map
{
    import com.google.maps.Color;
    import com.google.maps.LatLng;
    import com.google.maps.MapMouseEvent;
    import com.google.maps.overlays.Marker;
    import com.google.maps.overlays.MarkerOptions;
    
    import flash.events.Event;
    
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
    import org.integratedsemantics.flexspaces.model.vo.TagVO;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.map.SemanticTagMapPresModel;
    import org.integratedsemantics.flexspaces.view.map.MapView;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;


    public class SemanticTagMapViewBase extends MapView
    {

        public function SemanticTagMapViewBase()
        {
            super();
        }
        
        [Bindable]
        public function get semanticTagMapPresModel():SemanticTagMapPresModel
        {
        	return this.mapPresModel as SemanticTagMapPresModel;
        }
        
        public function set semanticTagMapPresModel(semanticTagMapPresModel:SemanticTagMapPresModel):void
        {
        	this.mapPresModel = semanticTagMapPresModel;
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

        /**
         * Handle google map ready event
         *  
         * @param event
         * 
         */
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
            if (this.isLoaded())
            {
            	clearOverlays();
            }

            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);

            semanticTagMapPresModel.refresh(responder);
        }
        
        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        protected function onResultGetTags(data:Object):void
        {           
        	var getTagsVO:GetTagsVO = data as GetTagsVO;
        	semanticTagMapPresModel.getTagsVO = getTagsVO;

            var markerOptions:MarkerOptions = new MarkerOptions({ 
            	strokeStyle: {color: 0x000000},
            	fillStyle: {color: Color.YELLOW, alpha: 0.6},
            	radius: 10,
            	hasShadow: false});
            
            for each (var tag:TagVO in getTagsVO.tags)
            {
            	if ((tag.latitude != "") && (tag.longitude != ""))
            	{
            		var lat:Number = new Number(tag.latitude);
            		var long:Number = new Number(tag.longitude);
            		var latLong:LatLng = new LatLng(lat, long);
            		markerOptions.tooltip = tag.name;
            		var marker:Marker = new Marker(latLong, markerOptions);
            		marker.addEventListener(MapMouseEvent.CLICK, onTagClick);
            		addOverlay(marker);
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
        	if (event.target is Marker)
        	{
                // get tag name
                var marker:Marker = event.target as Marker;
                var markerOptions:MarkerOptions = marker.getOptions();
                var tagName:String = markerOptions.tooltip; 
                
	            var responder:Responder = new Responder(onResultSearch, onFaultSearch);
	                
	            semanticTagMapPresModel.tagSearch(tagName, responder);
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