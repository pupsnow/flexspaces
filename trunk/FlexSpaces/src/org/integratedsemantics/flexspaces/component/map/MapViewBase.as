package org.integratedsemantics.flexspaces.component.map
{
    import com.google.maps.Map;
    
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
        
    }
}