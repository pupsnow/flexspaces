package org.integratedsemantics.flexspacesairmobile.view.filebrowse
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
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
    
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspacesair.control.event.AirMakeAvailOfflineUIEvent;
    import org.integratedsemantics.flexspacesair.util.AirOfflineUtil;


    public class MobileDownload
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();        
        
        protected var selectedItems:Array;

               
        /**
         * Constructor
         */
        public function MobileDownload()
        {
            super();
        }


        public function downloadBrowse(parent:DisplayObject, selectedItems:Array):void
        {
            this.selectedItems = selectedItems;  
            
            var folderBrowseView:FolderBrowseView = FolderBrowseView(PopUpManager.createPopUp(parent, FolderBrowseView, false));    
            folderBrowseView.onComplete = browseComplete;            
        }
        
        public function browseComplete(selectedDir:File):void
        {
            if ( (selectedDir != null) && (selectedDir.isDirectory == true) )
            {
                if ( (selectedItems != null) && (selectedItems.length > 0) )
                {
                    for each (var selectedItem:Object in selectedItems)
                    {
                        if (selectedItem != null)
                        {
                            if (selectedItem.isFolder == true)
                            {
                                // for now no folder download
                            }  
                            else
                            {
                                download(selectedItem, selectedDir); 
                            }
                        }
                    }  
                }
            }
        }
        

        protected function download(selectedItem:Object, downloadDir:File):void
        {
            if (selectedItem != null && selectedItem.isFolder == false)
            {                
                var model : AppModelLocator = AppModelLocator.getInstance();                            
                if (model.ecmServerConfig.isLiveCycleContentServices == true)
                {
                    var url:String = model.ecmServerConfig.urlPrefix + "/adobe/formfetch?storeprotocol=" + selectedItem.storeProtocol + 
                        "&storeid=" + selectedItem.storeId + "&formid=" + selectedItem.id +  "&ticket=" + model.userInfo.loginTicket;                     
                }
                else
                {
                    url = selectedItem.viewurl + "?alf_ticket=" + model.userInfo.loginTicket;
                }
                                
                var request:URLRequest = new URLRequest(url);
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
                try
                {
                    var loader:URLLoader = URLLoader(event.target);
                    trace("mobileDownload completeHandler " );
                    var filename:String = selectedItem.name;
                    var file:File = downloadDir.resolvePath(filename);
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
                trace("mobileDownload openHandler ");
            }
    
            function progressHandler(event:ProgressEvent):void 
            {
                //trace("mobileDownload progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
            }
    
            function securityErrorHandler(event:SecurityErrorEvent):void
            {
                trace("mobileDownload securityErrorHandler: " + event);
            }
    
            function httpStatusHandler(event:HTTPStatusEvent):void
            {
                trace("mobileDownload httpStatusHandler: " + event.status);
            }
    
            function ioErrorHandler(event:IOErrorEvent):void 
            {
                trace("mobileDownload ioErrorHandler: " + event);
            }            
        }         
        
    }
}