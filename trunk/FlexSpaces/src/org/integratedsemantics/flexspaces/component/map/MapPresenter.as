package org.integratedsemantics.flexspaces.component.map
{
    import com.adobe.rtc.util.ISO9075;
    import com.google.maps.LatLng;
    import com.google.maps.MapEvent;
    import com.google.maps.MapOptions;
    import com.google.maps.MapType;
    import com.google.maps.controls.MapTypeControl;
    import com.google.maps.controls.PositionControl;
    import com.google.maps.controls.ZoomControl;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.controls.LinkButton;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.control.event.TagsEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;


	/**
	 * Presenter of google map view
	 * 
	 * Presenter of MapViewBase views
	 * 
	 */
    public class MapPresenter extends Presenter
    {
        public function MapPresenter(mapView:MapViewBase)
        {
            super(mapView);

            if (mapView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(mapView, onCreationComplete);            
            }                        
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get mapView():MapViewBase
        {
            return this.view as MapViewBase;            
        }        
        
        /**
         * Handle view creation complete by requesting tag cloud data
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
        	mapView.addEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreInit);
        	mapView.addEventListener(MapEvent.MAP_READY, onMapReady);
        }        

        protected function onMapPreInit(event:Event):void
        {
        	var mapOptions:MapOptions = new MapOptions();
        	mapOptions.zoom = 3;
        	mapOptions.center = new LatLng(40.749444, -73.968056);
        	mapOptions.mapType =  MapType.NORMAL_MAP_TYPE;
        	mapView.setInitOptions(mapOptions);
        }
	
        
        protected function onMapReady(event:Event):void
        {
        	mapView.addControl(new ZoomControl());
        	mapView.addControl(new PositionControl());
        	mapView.addControl(new MapTypeControl());
        }
                            
    }
}