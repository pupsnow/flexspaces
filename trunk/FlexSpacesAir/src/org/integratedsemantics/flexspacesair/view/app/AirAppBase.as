package org.integratedsemantics.flexspacesair.view.app
{
    import flash.events.Event;
    
    import mx.core.WindowedApplication;
    import mx.managers.PopUpManager;
    
    import org.alfresco.framework.service.error.ErrorRaisedEvent;
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigCompleteEvent;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.presmodel.error.ErrorDialogPresModel;
    import org.integratedsemantics.flexspaces.view.error.ErrorDialogView;
    import org.integratedsemantics.flexspacesair.presmodel.main.FlexSpacesAirPresModel;
    import org.springextensions.actionscript.context.support.XMLApplicationContext;
        
        
    public class AirAppBase extends WindowedApplication
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();
	        
        protected var configService:ConfigService;  
        
        [Bindable]
        protected var flexSpacesAirPresModel:FlexSpacesAirPresModel;
        
        protected var applicationContext:XMLApplicationContext;
        
        [Bindable]
        protected var applicationContextComplete:Boolean = false;
        
        
        public function AirAppBase()
        {
            super();

            // Register interest in the error service events
            ErrorService.instance.addEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);            

            // make sure config service initialization is started soon so alfresco-config.xml loaded 
            // and config config complete gets called soon (before config info is needed) 
            if (model.appConfig.cmisMode == false)
            {
                configService = ConfigService.instance;
                configService.addEventListener(ConfigCompleteEvent.CONFIG_COMPLETE, onConfigComplete);   
            }   
            			                                      
            model.appConfig.airMode = true;			
        }

        protected function onCreationComplete(event:Event):void
        {        	        	
        	
        }        
        
        /**
         * Handle alfresco-config.xml config read done
         *  
         * @param event config complete event
         * 
         */
        protected function onConfigComplete(event:Event):void
        {
            flexSpacesAirPresModel = new FlexSpacesAirPresModel();
            model.flexSpacesPresModel = flexSpacesAirPresModel;            

            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
            	flexSpacesAirPresModel.showTasks = false;
            	flexSpacesAirPresModel.showWCM = false;
            }    
            
            model.configComplete = true;                    
        }
        
        /**
         * Handler called when error is raised when making web script calls
         * 
         * @param event error raised vent
         */
        protected function onErrorRaised(event:ErrorRaisedEvent):void
        {
            if (event.errorType == ErrorService.APPLICATION_ERROR)
            {
                var msg:String = event.error.message;
                var errorDialogView:ErrorDialogView = new ErrorDialogView();
                var errorDialogPresModel:ErrorDialogPresModel = new ErrorDialogPresModel(msg, event.error.getStackTrace() ); 
                errorDialogView.errorDialogPresModel = errorDialogPresModel;
                PopUpManager.addPopUp(errorDialogView, this);                                
            }
        } 
        
        protected function onApplicationContextComplete(event:Event):void
        {
            applicationContextComplete = true;  			
        }                
        		
	}
}