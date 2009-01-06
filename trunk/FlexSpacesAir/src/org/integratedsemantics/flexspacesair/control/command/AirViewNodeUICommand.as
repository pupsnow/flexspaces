package org.integratedsemantics.flexspacesair.control.command
{
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
    
    import mx.containers.VBox;
    import mx.containers.ViewStack;
    import mx.controls.HTML;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspacesair.control.event.AirViewNodeUIEvent;
    import org.integratedsemantics.flexspacesair.util.AirOfflineUtil;
    import org.integratedsemantics.flexspacesair.util.WebkitUtil;
    

    /**
     * Command for viewing a document/file node with special
     * air features:
     * 
     *  1. Automaticly doing a make available offline
     *  2. Display in webkit html tab if formated supported,
     *     otherwise launches in a separate window
     * 
     */
    public class AirViewNodeUICommand extends Command
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();
        protected var container:ViewStack;
        

        /**
         * Constructor
         */
        public function AirViewNodeUICommand()
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
                case AirViewNodeUIEvent.AIR_VIEW_NODE:
                    airViewNode(event as AirViewNodeUIEvent);  
                    break;
            }
        }       

        /**
         * Air View Node
         * 
         * @param event air view node event
         */
        public function airViewNode(event:AirViewNodeUIEvent):void
        {            
            var selectedItem:Object = event.selectedItem;
            this.container = event.container;

            if (selectedItem != null && selectedItem.isFolder == false)
            {    
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
                    
                    trace("airViewNode completeHandler ");
                    
                    var filename:String = selectedItem.name;
 
                    var offlinePath:String = AirOfflineUtil.offlineFolderPathForNode(selectedItem, model.flexSpacesPresModel.wcmMode);
                    
                    // download within Viewed directory to protect main make available offline area
                    offlinePath = "/Viewed" + offlinePath;

                    var localDir:File = AirOfflineUtil.makeOfflineDirForPath(offlinePath);
                    var file:File = localDir.resolvePath(filename);
                    var stream:FileStream = new FileStream();
                    stream.open(file, FileMode.WRITE);
                    stream.writeBytes(loader.data, 0, loader.bytesTotal);
                    stream.close();
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
                        var request:URLRequest = new URLRequest(file.url);
                        navigateToURL(request);
                    }
                }
                catch (e:Error)
                {
                    // todo
                    trace("airViewNode completeHandler exception");
                }
            }
    
            function openHandler(event:Event):void
            {
                trace("airViewNode openHandler ");
            }
    
            function progressHandler(event:ProgressEvent):void 
            {
                //trace("airViewNode progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
            }
    
            function securityErrorHandler(event:SecurityErrorEvent):void
            {
                trace("airViewNode securityErrorHandler: " + event);
            }
    
            function httpStatusHandler(event:HTTPStatusEvent):void
            {
                trace("airViewNode httpStatusHandler ");
            }
    
            function ioErrorHandler(event:IOErrorEvent):void 
            {
                trace("airViewNode ioErrorHandler: " + event);
            }            
        }
        
    }
}