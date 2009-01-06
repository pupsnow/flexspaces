package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.navigateToURL;
    
    import mx.utils.Base64Encoder;
    
    import org.integratedsemantics.flexspaces.control.event.ui.ViewNodeUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    

    /**
     * View Command provides the operation for viewing a document/file node
     * 
     */
    public class ViewNodeUICommand extends Command
    {
        protected var model : AppModelLocator = AppModelLocator.getInstance();

        /**
         * Constructor
         */
        public function ViewNodeUICommand()
        {
            super();
        }

        /**
         * Execute command for the given event
         *  
         * @param event event calling command
         * 
         */
        override public function execute(event:CairngormEvent):void
        {
            // always call the super.execute() method which allows the 
            // callBack information to be cached.
            super.execute(event);
 
            switch(event.type)
            {
                case ViewNodeUIEvent.VIEW_NODE:
                    viewNode(event as ViewNodeUIEvent);  
                    break;
            }
        }       

        /**
         * View Node
         * 
         * @param event view node event
         */
        public function viewNode(event:ViewNodeUIEvent):void
        {
            var selectedItem:Object = event.selectedItem;
            if (selectedItem != null)
            {
                if (selectedItem.isFolder == false)
                {
                	var request:URLRequest;
                    var model : AppModelLocator = AppModelLocator.getInstance();                            
                    if (model.ecmServerConfig.isLiveCycleContentServices == true)
                    {
                        var url:String = selectedItem.viewurl;
                    	request = new URLRequest(url);                    	
						var ticketHeader:URLRequestHeader = new URLRequestHeader("ticket", model.userInfo.loginTicket);
			            request.requestHeaders.push(ticketHeader);	                    	
                    }
                    else
                    {
                        url = selectedItem.viewurl + "?alf_ticket=" + model.userInfo.loginTicket;
                    	request = new URLRequest(url);
                    }                    

                    try 
                    {            
                        navigateToURL(request);
                        this.result("viewNode success");
                    }
                    catch (e:Error) 
                    {
                        this.fault("viewNode error with navigateToURL " + e.message);
                    }
                }
            }
        }
        
    }
}