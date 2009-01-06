package org.integratedsemantics.flexspacesair.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
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
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspacesair.control.event.AirMakeAvailOfflineUIEvent;
    import org.integratedsemantics.flexspacesair.util.AirOfflineUtil;


    /**
     * Event to request making multiple selection of files and folders available offline
     * 
     * Nodes are made available offline by downloading them without a download dialog
     * to the flexpaces area in the user's documents folder within folders mirroring the
     * repository folder. 
     * 
     * Note: currently, selected folders themselves are made offline, not their contents
     * 
     */
    public class AirMakeAvailOfflineUICommand extends Command
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();        
        
        protected var selectedItems:Array;

        /** Icon used in the confirmation dialog */
        protected var confirmIcon:Class;
        
        
        /**
         * Constructor
         */
        public function AirMakeAvailOfflineUICommand()
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
                case AirMakeAvailOfflineUIEvent.AIR_MAKE_AVAIL_OFFLINE:
                    airMakeAvailOffline(event as AirMakeAvailOfflineUIEvent);  
                    break;
            }
        }       

        /**
         * Air Make Available Offline
         * 
         * @param event air make available offline event
         */
        public function airMakeAvailOffline(event:AirMakeAvailOfflineUIEvent):void
        {
            this.selectedItems = event.selectedItems;  
            
            // confirm with user
            if ((selectedItems.length > 0) && selectedItems[0] != null)
            {
                var offlinePath:String = AirOfflineUtil.offlineFolderPathForNode(selectedItems[0], model.flexSpacesPresModel.wcmMode);
                var localDir:File = AirOfflineUtil.makeOfflineDirForPath(offlinePath);
                var msg:String = "Ok to download selected files and possibly overwrite files with same names within " + localDir.nativePath + " ?";
                var a:Alert = Alert.show(msg, "Confirmation",  Alert.YES|Alert.NO, event.parent as Sprite, onConfirm, confirmIcon, Alert.NO);                                
            }
        }
        
        /**
         * Handle completion of confirm dialog with yes or no result 
         * 
         * @param close event
         * 
         */
        protected function onConfirm(event:CloseEvent):void 
        {
            if (event.detail == Alert.YES) 
            {
                for each (var selectedItem:Object in selectedItems)
                {
                    if (selectedItem != null)
                    {
                        var offlinePath:String = AirOfflineUtil.offlineFolderPathForNode(selectedItem, model.flexSpacesPresModel.wcmMode);
                        
                        if (selectedItem.isFolder == true)
                        {
                            // for now just offline the subfolder without its children
                            AirOfflineUtil.makeOfflineDirForPath(offlinePath);
                            // todo: support deep folder offlining 
                        }  
                        else
                        {
                            makeNodeAvailOffline(selectedItem, offlinePath); 
                        }
                    }
                }           
            }
        }

        /**
         * Make a node available offline by downloading it without a download dialog
         * to the flexpaces area in documents folder within folders mirroring the
         * repository folder location 
         * 
         * @param selectedItem selected node to make available offline
         * @param offlinePath relative offline path to use for offlining
         * 
         */
        protected function makeNodeAvailOffline(selectedItem:Object, offlinePath:String):void
        {
            if (selectedItem != null && selectedItem.isFolder == false)
            {                
                var model : AppModelLocator = AppModelLocator.getInstance();                            
                if (model.ecmServerConfig.isLiveCycleContentServices == true)
                {
                    var url:String = selectedItem.viewurl;
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
                    trace("makeNodeAvailOffline completeHandler " );
                    var filename:String = selectedItem.name;
                    var localDir:File = AirOfflineUtil.makeOfflineDirForPath(offlinePath);
                    var file:File = localDir.resolvePath(filename);
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
                trace("makeNodeAvailOffline openHandler ");
            }
    
            function progressHandler(event:ProgressEvent):void 
            {
                //trace("makeNodeAvailOffline progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
            }
    
            function securityErrorHandler(event:SecurityErrorEvent):void
            {
                trace("makeNodeAvailOffline securityErrorHandler: " + event);
            }
    
            function httpStatusHandler(event:HTTPStatusEvent):void
            {
                trace("makeNodeAvailOffline httpStatusHandler: " + event.status);
            }
    
            function ioErrorHandler(event:IOErrorEvent):void 
            {
                trace("makeNodeAvailOffline ioErrorHandler: " + event);
            }            
        }         
        
    }
}