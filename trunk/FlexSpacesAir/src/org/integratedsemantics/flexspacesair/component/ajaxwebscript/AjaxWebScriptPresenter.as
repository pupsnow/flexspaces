package org.integratedsemantics.flexspacesair.component.ajaxwebscript
{
    import flash.events.Event;
    
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    

    /**
     * Example showing integrating ajax/html webscript UI into flex app 
     * This uses air specific mx:HTML control, for use in fiex+browser need
     * to switch in use of 3rd party html control wrapping iframe
     * 
     *  Presenter/Controller of AjaxWebScriptViewBase views
     */
    public class AjaxWebScriptPresenter extends Presenter
    {

        /** 
         * Constructor
         * 
         * @param ajaxView view to control
         * 
         */
        public function AjaxWebScriptPresenter(ajaxView:AjaxWebScriptViewBase)
        {
            super(ajaxView);
            
            if (ajaxView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(ajaxView, onCreationComplete);            
            }
        }
        
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get ajaxView():AjaxWebScriptViewBase
        {
            return this.view as AjaxWebScriptViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            var model:AppModelLocator = AppModelLocator.getInstance();
            ajaxView.html1.location = model.urlPrefix + "/ui/myspaces?f=0" + "&alf_ticket=" + model.loginTicket;
            ajaxView.html2.location = model.urlPrefix + "/ui/mytasks?f=0" + "&alf_ticket=" + model.loginTicket;            
        }
    }
}