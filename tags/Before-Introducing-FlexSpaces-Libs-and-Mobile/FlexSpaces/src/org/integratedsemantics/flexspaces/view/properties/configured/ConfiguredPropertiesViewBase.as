package org.integratedsemantics.flexspaces.view.properties.configured
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.AsyncToken;
    import mx.rpc.Responder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.presmodel.properties.basic.PropertiesPresModel;
    

    /**
     * Base class for properties views  
     * 
     */
    public class ConfiguredPropertiesViewBase extends DialogViewBase
    {
        public var onComplete:Function;

        [Bindable]
        public var propPresModel:PropertiesPresModel;
        
        public var viewPropertiesView:ConfiguredViewPropertiesViewBase;
        public var editPropertiesView:ConfiguredEditPropertiesViewBase;
        
                        
        /**
         * Constructor
         * 
         * @param onComplete  handler to call after properites setting
         * 
         */
        public function ConfiguredPropertiesViewBase(onComplete:Function=null)
        {
            super();

            this.onComplete = onComplete;            
        }        
        
        /**
         * Handle creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            // login to share if haven't yet so can get form config
            var model:AppModelLocator = AppModelLocator.getInstance();
            if (model.ecmServerConfig.loggedInToShare == false)
            {
                loginToShare();
            }
            else
            {
                viewPropertiesView.getFormProperties(propPresModel.repoNode);            
                editPropertiesView.getFormProperties(propPresModel.repoNode);            
            }
        }
        
        private function loginToShare():void
        {
            var model:AppModelLocator = AppModelLocator.getInstance();
            var service:HTTPService = new HTTPService;            
            service.url = model.ecmServerConfig.shareUrl + "/page/dologin";            
            service.resultFormat = "text";
            
            service.addEventListener(ResultEvent.RESULT, onShareLoginComplete);           
            service.addEventListener(FaultEvent.FAULT, onFaultShareLogin);
            
            var parameters:Object = new Object();
            parameters.username = model.userInfo.loginUserName;
            parameters.password = model.userInfo.loginPassword;
            
            var result:AsyncToken = null;
            result = service.send(parameters);             
        }
        
        /**
         * Handle close buttion click
         * (not for X close in title area)
         * (used when no write permissions)
         * 
         * @param click event
         * 
         */
        override protected function onCloseBtn(event:MouseEvent):void 
        {            
            PopUpManager.removePopUp(this);
        }

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            if (editPropertiesView.haveChanges() == true)
            {
                var responder:Responder = new Responder(onSetFormPropertiesComplete, onIOErrorSetFormProperties);           
                editPropertiesView.setFormProperties(propPresModel.repoNode, responder);
            }
            else
            {
                done();    
            }
        }
                
        private function onShareLoginComplete(event:Event):void 
        {
            // todo: should add checking if worked
            
            var model:AppModelLocator = AppModelLocator.getInstance();
            model.ecmServerConfig.loggedInToShare = true;
            
            viewPropertiesView.getFormProperties(propPresModel.repoNode);            
            editPropertiesView.getFormProperties(propPresModel.repoNode);                        
        }
        
        private function onFaultShareLogin(event:FaultEvent):void
        {
            trace("onFaultShareLogin fault");           
            PopUpManager.removePopUp(this);            
        }  
        
        private function onSetFormPropertiesComplete(event:Event):void 
        {
            trace("onSetFormPropertiesComplete()");
            done();                            
        }        

        private function done():void 
        {
            PopUpManager.removePopUp(this);
            if (onComplete != null)
            {
                onComplete();
            }                                    
        }        
                
        private function onIOErrorSetFormProperties(e:IOErrorEvent):void 
        {
            trace("URLLoader onIOErrorSetFormProperties()");
            PopUpManager.removePopUp(this);            
        }              
        
    }
}