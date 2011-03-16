package org.integratedsemantics.flexspaces.view.wcm.browser
{
	import org.integratedsemantics.flexspaces.presmodel.wcm.browser.WcmRepoBrowserPresModel;
	import org.integratedsemantics.flexspaces.view.browser.RepoBrowserViewBase;
	
    /**
     * Base view class for wcm repository tree/dual folder browser views  
     * 
     */
    public class WcmRepoBrowserViewBase extends RepoBrowserViewBase
    {
        /**
         * Constructor 
         */
        public function WcmRepoBrowserViewBase()
        {
            super();
        }        
        
        [Bindable] 
        public function get wcmRepoBrowserPresModel():WcmRepoBrowserPresModel
        {
            return this.repoBrowserPresModel as WcmRepoBrowserPresModel;            
        }       

        public function set wcmRepoBrowserPresModel(wcmRepoBrowserPresModel:WcmRepoBrowserPresModel):void
        {
            this.repoBrowserPresModel = wcmRepoBrowserPresModel;            
        }       
        
    }
}