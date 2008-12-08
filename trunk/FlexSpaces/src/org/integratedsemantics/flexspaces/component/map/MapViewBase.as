package org.integratedsemantics.flexspaces.component.map
{
    import com.google.maps.LatLng;
    import com.google.maps.Map;
    import com.google.maps.MapOptions;
    import com.google.maps.MapType;
    import com.google.maps.controls.MapTypeControl;
    import com.google.maps.controls.PositionControl;
    import com.google.maps.controls.ZoomControl;
    
    import flash.events.Event;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;

    public class MapViewBase extends Map
    {
        public function MapViewBase()
        {
            super();

			var model:AppModelLocator = AppModelLocator.getInstance();
            
            if (model.enableGoogleMap == true)
            {
            	this.url = model.googleMapUrl;
            	this.key = model.googleMapKey;
            }
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