package org.integratedsemantics.flexspaces.view.map
{
    import com.google.maps.LatLng;
    import com.google.maps.Map;
    import com.google.maps.MapOptions;
    import com.google.maps.MapType;
    import com.google.maps.controls.MapTypeControl;
    import com.google.maps.controls.PositionControl;
    import com.google.maps.controls.ZoomControl;
    
    import flash.events.Event;
    
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.presmodel.map.MapPresModel;


    public class MapViewBase extends Map
    {
        [Bindable]
        public var mapPresModel:MapPresModel;
                
        public function MapViewBase()
        {
            super();      
            
	        var model:AppModelLocator = AppModelLocator.getInstance();
	        
            this.url = model.googleMapConfig.googleMapUrl;
            this.key = model.googleMapConfig.googleMapKey;
        }
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void       
        {
        }        

        protected function onMapPreInit(event:Event):void
        {
        	var mapOptions:MapOptions = new MapOptions();
        	mapOptions.zoom = 3;
        	mapOptions.center = new LatLng(40.749444, -73.968056);
        	mapOptions.mapType =  MapType.NORMAL_MAP_TYPE;
        	setInitOptions(mapOptions);
        }
	        
        protected function onMapReady(event:Event):void
        {
        	addControl(new ZoomControl());
        	addControl(new PositionControl());
        	addControl(new MapTypeControl());
        }        
                
    }
}