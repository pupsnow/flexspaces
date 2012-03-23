package org.integratedsemantics.flexspacesair.util
{
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;    

    public class DownloadToTempFiles
    {
        private var model:AppModelLocator = AppModelLocator.getInstance();
        private var tempDir:File = File.createTempDirectory();

        public function download(items:Array):Array
        {
            var fileArray:Array = new Array();
                       
            for (var i:int = 0; i < items.length; i++)
            {
                var selectedItem:Object = items[i];
                       
                if (selectedItem != null && selectedItem.isFolder != true)
                {
                    var file:File = tempDir.resolvePath(selectedItem.name);        
                    
                    downloadItem(selectedItem, file);                    
                                                    
                    fileArray.push(file);                   
                } 
            }

            return fileArray;              
        }
        
        private function downloadItem(selectedItem:Object, file:File):void
        {
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                // use formfetch url on lc content services es2 which has support for ticket
                var viewurl:String = model.ecmServerConfig.urlPrefix + "/adobe/formfetch?storeprotocol=" + selectedItem.storeProtocol + 
                    "&storeid=" + selectedItem.storeId + "&formid=" + selectedItem.id +  "&ticket=" + model.userInfo.loginTicket;                     
            }
            else
            {
                viewurl = selectedItem.viewurl + "?alf_ticket=" + model.userInfo.loginTicket;
            }
                                
            var request:URLRequest = new URLRequest(viewurl);
            
            var urlLoader:URLLoader = new URLLoader();
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            configureListeners(urlLoader);      
            try 
            {      
                urlLoader.load(request);      
            }
            catch (e:Error) 
            {
                // todo
            }  
            
            function configureListeners(dispatcher:IEventDispatcher):void
            {
                dispatcher.addEventListener(Event.COMPLETE, completeHandler);
                dispatcher.addEventListener(Event.OPEN, openHandler);
                dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
                dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
                dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            }
    
            function completeHandler(event:Event):void
            {
                trace("DownloadToTempFiles.downloadItem completeHandler ");
                try
                {
                    var loader:URLLoader = URLLoader(event.target);
                    var stream:FileStream = new FileStream();
                    stream.open(file, FileMode.WRITE);
                    stream.writeBytes(loader.data, 0, loader.bytesTotal);
                    stream.close();
                }
                catch (e:Error)
                {
                    // todo
                }
            }
    
            function openHandler(event:Event):void
            {
                trace("DownloadToTempFiles.downloadItem openHandler ");
            }
    
            function progressHandler(event:ProgressEvent):void 
            {
                //trace("DownloadToTempFiles.downloadItem progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
            }
    
            function securityErrorHandler(event:SecurityErrorEvent):void
            {
                trace("DownloadToTempFiles.downloadItem securityErrorHandler: " + event);
            }
    
            function httpStatusHandler(event:HTTPStatusEvent):void
            {
                trace("DownloadToTempFiles.downloadItem httpStatusHandler: " + event.status);
            }
    
            function ioErrorHandler(event:IOErrorEvent):void 
            {
                trace("DownloadToTempFiles.downloadItem ioErrorHandler: " + event);
            }            
        
        }                       
    }
}