package org.integratedsemantics.flexspacesair.app
{
    import flash.events.Event;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.control.error.ErrorRaisedEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.global.AppConfig;
    import org.integratedsemantics.flexspaces.model.global.CalaisConfig;
    import org.integratedsemantics.flexspaces.model.global.EcmServerConfig;
    import org.integratedsemantics.flexspaces.model.global.GoogleMapConfig;
    import org.integratedsemantics.flexspaces.model.global.ThumbnailConfig;
    import org.integratedsemantics.flexspaces.presmodel.error.ErrorDialogPresModel;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.results.SearchResultsPresModel;
    import org.integratedsemantics.flexspaces.view.error.ErrorDialogView;
    import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;
    
    import spark.components.WindowedApplication;
        
        
    public class AirAppBase extends WindowedApplication
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();
	        
        [Bindable]
        protected var flexSpacesAirPresModel:FlexSpacesPresModel;
                
        
        public function AirAppBase()
        {
            super();

            // Register interest in the error service events
            ErrorMgr.getInstance().addEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);            

            loadConfig();            			                                      
        }

        protected function loadConfig():void
        {
            // spring actionscript config
            model.applicationContext = new FlexXMLApplicationContext("FlexSpacesConfig.xml");
            model.applicationContext.addEventListener(Event.COMPLETE, onApplicationContextComplete);
            model.applicationContext.load();                                          
        }

        protected function onCreationComplete(event:Event):void
        {        	        	        	
        }        
        
        /**
         * Handler called when error is raised when making web script calls
         * 
         * @param event error raised vent
         */
        protected function onErrorRaised(event:ErrorRaisedEvent):void
        {
            if (event.getErrorType() == ErrorMgr.APPLICATION_ERROR)
            {
                var msg:String = event.getError().message;
                var errorDialogView:ErrorDialogView = new ErrorDialogView();
                var errorDialogPresModel:ErrorDialogPresModel = new ErrorDialogPresModel(msg, event.getError().getStackTrace() ); 
                errorDialogView.errorDialogPresModel = errorDialogPresModel;
                PopUpManager.addPopUp(errorDialogView, this);                                
            }
        } 
        
        protected function onApplicationContextComplete(event:Event):void
        {
            //trace("onApplicationContextComplete");

            var ecmServerConfig:EcmServerConfig = model.applicationContext.getObject("ecmServerConfig"); 
            
            if (ecmServerConfig.port != null)
            {
                ecmServerConfig.urlPrefix = ecmServerConfig.protocol + "://" + ecmServerConfig.domain + ":" + ecmServerConfig.port + ecmServerConfig.alfrescoUrlPart;
            }
            else
            {
                ecmServerConfig.urlPrefix = ecmServerConfig.protocol + "://" + ecmServerConfig.domain + ecmServerConfig.alfrescoUrlPart;
            }            
            
            model.ecmServerConfig = ecmServerConfig;                

            var appConfig:AppConfig = model.applicationContext.getObject("appConfig"); 
            model.appConfig = appConfig;                

            var calaisConfig:CalaisConfig = model.applicationContext.getObject("calaisConfig"); 
            model.calaisConfig = calaisConfig;                

            var googleMapConfig:GoogleMapConfig = model.applicationContext.getObject("googleMapConfig"); 
            model.googleMapConfig = googleMapConfig;
            
            model.appConfig.airMode = true;         

            var thumbnailConfig:ThumbnailConfig = model.applicationContext.getObject("thumbnailConfig"); 
            model.thumbnailConfig = thumbnailConfig;
            
            flexSpacesAirPresModel = model.applicationContext.getObject("presModel");
            model.flexSpacesPresModel = flexSpacesAirPresModel;            

            // setup search results
            flexSpacesAirPresModel.searchResultsPresModel = new SearchResultsPresModel();                     

            // setup nav panel after all the config done
            flexSpacesAirPresModel.navPanelPresModel.setupSubViews();        


            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                flexSpacesAirPresModel.showTasks = false;
                flexSpacesAirPresModel.showWCM = false;
            }    
            
            model.configComplete = true;                    
        }                
        		
	}
}