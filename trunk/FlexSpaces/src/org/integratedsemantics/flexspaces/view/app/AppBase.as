package org.integratedsemantics.flexspaces.view.app
{
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	import org.alfresco.framework.service.error.ErrorRaisedEvent;
	import org.alfresco.framework.service.error.ErrorService;
	import org.alfresco.framework.service.webscript.ConfigCompleteEvent;
	import org.alfresco.framework.service.webscript.ConfigService;
	import org.integratedsemantics.flexspaces.model.AppModelLocator;
	import org.integratedsemantics.flexspaces.presmodel.error.ErrorDialogPresModel;
	import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
	import org.integratedsemantics.flexspaces.view.error.ErrorDialogView;
	import org.springextensions.actionscript.context.support.XMLApplicationContext;
	
	        
	public class AppBase extends Application
	{
        protected var model:AppModelLocator = AppModelLocator.getInstance();
            
        // make sure config service initialization is started soon so alfresco-config.xml loaded 
        // and config config complete gets called soon (before config info is needed) 
        protected var configService:ConfigService = ConfigService.instance;  
        
        [Bindable]
        protected var flexSpacesPresModel:FlexSpacesPresModel;
        
        protected var applicationContext:XMLApplicationContext;
        
        [Bindable]
        protected var applicationContextComplete:Boolean = false;
        
        
        public function AppBase()
        {
            super();
			
            // Register interest in the error service events
            ErrorService.instance.addEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);            
            
            // alfresco framework config           
            configService.addEventListener(ConfigCompleteEvent.CONFIG_COMPLETE, onConfigComplete);
            
            // spring actionscript config
            //applicationContext = new XMLApplicationContext("applicationContext.xml");
            //applicationContext.addEventListener(Event.COMPLETE, onApplicationContextComplete);
            //applicationContext.load();            	              
        }

        protected function onCreationComplete(event:Event):void
        {        	        	
            var ticket:String = this.parameters.alf_ticket;
            if ((ticket != null) && (ticket.length != 0))
            {
                model.userInfo.loginTicket = ticket;
            }
            
            var srcPath:String = this.parameters.srcPath;
            if ((srcPath != null) && (srcPath.length != 0))
            {
                model.appConfig.srcPath = srcPath;
            }
        }        
        
        /**
         * Handle alfresco-config.xml config read done
         *  
         * @param event config complete event
         * 
         */
        protected function onConfigComplete(event:Event):void
        {
            flexSpacesPresModel = new FlexSpacesPresModel();
            model.flexSpacesPresModel = flexSpacesPresModel;            

            var doclib:String = this.parameters.doclib;
            if ((doclib != null) && (doclib.length != 0))
            {
                flexSpacesPresModel.showDocLib = (doclib == "true");
            }
            var search:String = this.parameters.search;
            if ((search != null) && (search.length != 0))
            {
                flexSpacesPresModel.showSearch = (search == "true");
            }
            var tasks:String = this.parameters.tasks;
            if ((tasks != null) && (tasks.length != 0))
            {
                flexSpacesPresModel.showTasks = (tasks == "true");
            }
            var wcm:String = this.parameters.wcm;
            if ((wcm != null) && (wcm.length != 0))
            {
                flexSpacesPresModel.showWCM = (wcm == "true");
            }		                                                                   

            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
            	flexSpacesPresModel.showTasks = false;
            	flexSpacesPresModel.showWCM = false;
            }            
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
            //trace("onApplicationContextComplete");
            applicationContextComplete = true;  			
        }
        		
	}
}