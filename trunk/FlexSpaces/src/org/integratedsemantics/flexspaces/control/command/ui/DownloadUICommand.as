package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    
    import org.integratedsemantics.flexspaces.control.event.ui.DownloadUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    

    /**
     * Download the single document node
     * A file location dialog will be displayed to choose the local location
     * and the file will be downloaded when oked
     * 
     * TODO: add progress bar feedback
     */
    public class DownloadUICommand extends Command
    {
        protected var model : AppModelLocator = AppModelLocator.getInstance();

        /**
         * Constructor
         */
        public function DownloadUICommand()
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
                case DownloadUIEvent.DOWNLOAD_UI:
                    downloadFileUI(event as DownloadUIEvent); 
                    break;
            }
        }       

        /**
         * Download File UI
         * 
         * @param download UI event
         */
        public function downloadFileUI(event:DownloadUIEvent):void
        {
            var selectedItem:Object = event.selectedItem;            
            var model : AppModelLocator = AppModelLocator.getInstance();                            
            
            if (selectedItem != null && selectedItem.isFolder != true)
            {
                // air seems to need ticket on url instead in the params data   
                if (event.airMode == true)
                {
                    if (model.ecmServerConfig.isLiveCycleContentServices == true)
                    {
                        var viewurl:String = selectedItem.viewurl;
                    }
                    else
                    {
                        viewurl = selectedItem.viewurl + "?alf_ticket=" + model.userInfo.loginTicket;
                    }                    
                    var request:URLRequest = new URLRequest(viewurl);
                }
                else
                {
                    viewurl = selectedItem.viewurl;                
                    request = new URLRequest(viewurl);
                    var params:URLVariables = new URLVariables();
                    if (model.ecmServerConfig.isLiveCycleContentServices == false)
                    {
                        params.alf_ticket = model.userInfo.loginTicket;
                    }    
                    request.data = params;
                }                                
                
                var fileRef:FileReference = new FileReference();
                fileRef.addEventListener(Event.COMPLETE, completeHandler);
                fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            
                try
                {
                    fileRef.download(request, selectedItem.name);
                } 
                catch (error:Error)
                {
                    trace("Unable to browse for files.");
                }
            } 

            function completeHandler(event:Event):void
            {
                trace("downloaded");
            }       
            
            function progressHandler(event:ProgressEvent):void
            {
                var file:FileReference = FileReference(event.target);
                trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
            }                         
        }
        
    }
}