package org.integratedsemantics.flexspaces.app
{
	import flash.events.Event;
	
	//flex4 import mx.core.Application;
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
	
	import spark.components.Application;
	
	        
	public class AppBase extends spark.components.Application
	{
        protected var model:AppModelLocator = AppModelLocator.getInstance();
            
        [Bindable]
        protected var flexSpacesPresModel:FlexSpacesPresModel;
                     
                
        public function AppBase()
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

            var thumbnailConfig:ThumbnailConfig = model.applicationContext.getObject("thumbnailConfig"); 
            model.thumbnailConfig = thumbnailConfig;
            
            flexSpacesPresModel = model.applicationContext.getObject("presModel");
            model.flexSpacesPresModel = flexSpacesPresModel;    
                   
            // setup search results
            flexSpacesPresModel.searchResultsPresModel = new SearchResultsPresModel();                     
            
            // setup nav panel pres model after all the config done 
            flexSpacesPresModel.navPanelPresModel.setupSubViews();        

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

            var header:String = this.parameters.header;
            if ((header != null) && (header.length != 0))
            {
                flexSpacesPresModel.showHeader = (header == "true");
            }   

            var coverflow:String = this.parameters.coverflow;
            if ((coverflow != null) && (coverflow.length != 0))
            {
                flexSpacesPresModel.haveCoverFlow = (coverflow == "true");
            } 
            
            var alfrescourl:String = this.parameters.alfrescourl;
            if ((alfrescourl != null) && (alfrescourl.length != 0))
            {
                model.ecmServerConfig.urlPrefix = alfrescourl;
            } 

            var user:String = this.parameters.user;
            if ((user != null) && (user.length != 0))
            {
                model.userInfo.loginUserName = user;
            } 

            var pw:String = this.parameters.pw;
            if ((pw != null) && (pw.length != 0))
            {
                model.userInfo.loginPassword = pw;
            } 

            var autologin:String = this.parameters.autologin;
            if ((autologin != null) && (autologin.length != 0))
            {
                model.userInfo.autoLogin = (autologin == "true");
            } 
                                    
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                flexSpacesPresModel.showTasks = false;
                flexSpacesPresModel.showWCM = false;
            }    
            
            model.configComplete = true;                                                       		
        }
        		
    }
}