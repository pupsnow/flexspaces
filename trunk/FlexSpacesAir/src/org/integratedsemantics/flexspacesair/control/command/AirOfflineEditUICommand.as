package org.integratedsemantics.flexspacesair.control.command
{
    import com.adobe.air.filesystem.FileMonitor;
    import com.adobe.air.filesystem.events.FileMonitorEvent;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
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
    import flash.net.navigateToURL;
    
    import mx.containers.ViewStack;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspacesair.control.event.AirOfflineEditUIEvent;
    import org.integratedsemantics.flexspacesair.control.event.AirOfflineUploadUIEvent;
    import org.integratedsemantics.flexspacesair.util.AirOfflineUtil;

    public class AirOfflineEditUICommand extends Command
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();        
        
        protected var selectedItem:Object;
        
        protected var container:ViewStack;
        
        private var offlinePath:String;
        
        
        /**
         * Constructor
         */
        public function AirOfflineEditUICommand()
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
                case AirOfflineEditUIEvent.AIR_OFFLINE_EDIT:
                    airOfflineEdit(event as AirOfflineEditUIEvent);  
                    break;
            }
        }       

        /**
         * Air Edit Offline
         * 
         * @param event air edit offline event
         */
        public function airOfflineEdit(event:AirOfflineEditUIEvent):void
        {
            this.selectedItem = event.selectedItem;  
            this.container = event.container;
            
            if (selectedItem != null)
            {
                offlinePath = AirOfflineUtil.offlineFolderPathForNode(selectedItem, model.flexSpacesPresModel.wcmMode);
                
                if (selectedItem.isFolder == true)
                {
                    // for now just offline the subfolder without its children
                    AirOfflineUtil.makeOfflineDirForPath(offlinePath);
                    // todo: support deep folder offlining 
                }  
                else
                {
                    makeNodeAvailOffline(selectedItem); 
                }
            }                        
        }
        

        private var urlLoader:URLLoader;
        
        /**
         * Make a node available offline by downloading it without a download dialog
         * to the flexpaces area in documents folder within folders mirroring the
         * repository folder location 
         * 
         * @param selectedItem selected node to make available offline
         * 
         */
        protected function makeNodeAvailOffline(selectedItem:Object):void
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
                urlLoader = new URLLoader();
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
        }   
            
        private function configureListeners(dispatcher:IEventDispatcher):void
        {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function removeListeners():void
        {
            urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
            urlLoader.removeEventListener(Event.OPEN, openHandler);
            urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void
        {
            trace("makeNodeAvailOffline completeHandler ");
            try
            {
                var loader:URLLoader = URLLoader(event.target);
                var filename:String = selectedItem.name;
                var localDir:File = AirOfflineUtil.makeOfflineDirForPath(offlinePath);
                var file:File = localDir.resolvePath(filename);
                var stream:FileStream = new FileStream();
                stream.open(file, FileMode.WRITE);
                stream.writeBytes(loader.data, 0, loader.bytesTotal);
                stream.close();

                if (model.appConfig.autoUpdateOnlineOnAppSave == true)
                {
                    // monitor file for doing auto update (local to repo) 
                    var node:Object = model.fileToNodeLookup[file.url];
                    if (node == null)
                    {        
                        var monitor:FileMonitor  = new FileMonitor();
                        model.fileMonitors.addItem(monitor);
                        monitor.addEventListener(FileMonitorEvent.CHANGE, onFileChange);
                        monitor.addEventListener(FileMonitorEvent.MOVE, onFileMove);
                        monitor.file = file;
                        monitor.watch();  
                        model.fileToNodeLookup[file.url] = selectedItem;
                    }              
                }
                this.airViewNode(file.url);
                removeListeners();
            }
            catch (e:Error)
            {
                trace("completeHandler error " + e.toString() );
            }            
        }

        private function openHandler(event:Event):void
        {
            trace("makeNodeAvailOffline openHandler ");
        }

        private function progressHandler(event:ProgressEvent):void 
        {
            //trace("makeNodeAvailOffline progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void
        {
            trace("makeNodeAvailOffline securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void
        {
            trace("makeNodeAvailOffline httpStatusHandler: " + event.status);
        }

        private function ioErrorHandler(event:IOErrorEvent):void 
        {
            trace("makeNodeAvailOffline ioErrorHandler: " + event);
        }            
      
     
        /**
         * Air View Node
         * 
         * @param event air view node event
         */
        public function airViewNode(url:String):void
        {            
            if (selectedItem != null && selectedItem.isFolder == false)
            {    
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
                dispatcher.addEventListener(Event.COMPLETE, completeHandler2);
                dispatcher.addEventListener(Event.OPEN, openHandler2);
                dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler2);
                dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler2);
                dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler2);
                dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler2);
            }
    
            function completeHandler2(event:Event):void
            {
                try
                {
                    var loader:URLLoader = URLLoader(event.target);
                    
                    trace("airViewNode completeHandler ");
                    
                    var filename:String = selectedItem.name;
 
                    var offlinePath:String = AirOfflineUtil.offlineFolderPathForNode(selectedItem, model.flexSpacesPresModel.wcmMode);
                    
                    var localDir:File = AirOfflineUtil.makeOfflineDirForPath(offlinePath);
                    var file:File = localDir.resolvePath(filename);
                    /*
                    var stream:FileStream = new FileStream();
                    stream.open(file, FileMode.WRITE);
                    stream.writeBytes(loader.data, 0, loader.bytesTotal);
                    stream.close();
                    */
                    /*
                    if ( WebkitUtil.isWebKitViewableFormat(file.extension) == true )
                    {
                        // add tab for file
                        var count:int = container.numChildren;
                        var tab:VBox = new VBox();
                        tab.percentHeight = 100;
                        tab.percentWidth = 100;
                        tab.label = filename;
                        tab.id = filename;
                        tab.setStyle("backgroundColor", 0x000000);
                        container.addChild(tab);                       
                        container.selectedIndex = count;            
                                
                        // setup tab to display file with webkit html control
                        var htmlControl:HTML = new HTML();
                        htmlControl.percentWidth = 100;
                        htmlControl.percentHeight = 100;
                        htmlControl.location = file.url;
                        tab.addChild(htmlControl);                        
                    }
                    else
                    {
                    */
                        var request:URLRequest = new URLRequest(file.url);
                        navigateToURL(request);
                    //}
                }
                catch (e:Error)
                {
                    // todo
                    trace("airViewNode completeHandler exception");
                }
            }
    
            function openHandler2(event:Event):void
            {
                trace("airViewNode openHandler ");
            }
    
            function progressHandler2(event:ProgressEvent):void 
            {
                //trace("airViewNode progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
            }
    
            function securityErrorHandler2(event:SecurityErrorEvent):void
            {
                trace("airViewNode securityErrorHandler: " + event);
            }
    
            function httpStatusHandler2(event:HTTPStatusEvent):void
            {
                trace("airViewNode httpStatusHandler ");
            }
    
            function ioErrorHandler2(event:IOErrorEvent):void 
            {
                trace("airViewNode ioErrorHandler: " + event);
            }            
        }
     

        private static function onFileChange(e:FileMonitorEvent):void
        {
            trace("file was changed");
            var file:File = e.file;
            var model:AppModelLocator = AppModelLocator.getInstance();        
            var node:Object = model.fileToNodeLookup[file.url];
            if (node != null)
            {
                var event:AirOfflineUploadUIEvent = new AirOfflineUploadUIEvent(AirOfflineUploadUIEvent.AIR_OFFLINE_UPLOAD, null, node, false, null, null, false);
                event.dispatch();                                                                    
            }
            
        }
        
        private static function onFileMove(e:FileMonitorEvent):void
        {
            trace("file was moved or deleted");
        }
                
    }
}