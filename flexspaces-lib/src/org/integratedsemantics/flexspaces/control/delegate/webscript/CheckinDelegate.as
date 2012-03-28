package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.CheckoutVO;


    /**
     * Provides checkin, checkout, cancel checkout, make versionable actions via web scripts
     * 
     */
    public class CheckinDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function CheckinDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Perform Cancel Checkout
         * 
         * @param repoNode repository node
         * 
         */
        public function cancelCheckout(repoNode:IRepoNode):void
        {
            try
            {          
                var url:String = "/flexspaces/cancelCheckout";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onDocActionSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * Perform Checkout
         * 
         * @param repoNode repository node
         * 
         */
        public function checkout(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/checkout";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCheckoutSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * Perform Checkin
         * 
         * @param repoNode repository node
         * 
         */
        public function checkin(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/checkin";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onDocActionSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * Perform Make Versionable
         * 
         * @param repoNode repository node
         * 
         */
        public function makeVersionable(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/makeVersionable";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onDocActionSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }

        /**
         * onDocActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onDocActionSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

        /**
         * onCheckoutSuccess event handler
         * 
         * @param event success event
         */
        protected function onCheckoutSuccess(event:SuccessEvent):void
        {
        	var result:XML = event.result as XML;
        	
            var checkoutVO:CheckoutVO = new CheckoutVO();
            
            checkoutVO.name = result.workingCopy.name;
            checkoutVO.nodeRef = result.workingCopy.noderef;
            checkoutVO.storeProtocol = result.workingCopy.storeProtocol;
            checkoutVO.storeId = result.workingCopy.storeId;
            checkoutVO.id = result.workingCopy.id;
            checkoutVO.viewUrl = result.workingCopy.viewurl;
            
            notifyCaller(checkoutVO, event);
        }
        
    }
}