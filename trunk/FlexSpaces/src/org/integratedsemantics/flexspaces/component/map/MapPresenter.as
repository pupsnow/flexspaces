package org.integratedsemantics.flexspaces.component.map
{
    import com.google.maps.MapEvent;
    
    import flash.events.Event;
    
    import mx.events.FlexEvent;
    
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
        }
	        
        protected function onMapReady(event:Event):void
        {
        }
                            
    }
}