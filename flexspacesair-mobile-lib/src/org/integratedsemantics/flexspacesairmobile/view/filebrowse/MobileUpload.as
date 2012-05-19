package org.integratedsemantics.flexspacesairmobile.view.filebrowse
{
    import flash.display.DisplayObject;
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.filesystem.File;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.command.IUploadHandlers;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.util.FormatUtil;


    public class MobileUpload
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();
        protected var onComplete:Function;
        protected var statusHandlers:IUploadHandlers;
        protected var parentNode:IRepoNode;
		protected var existingNode:IRepoNode = null;		
		

        /**
         * Constructor 
         * 
         * @param statusHandlers upload status methods to call
         * 
         */
        public function MobileUpload(statusHandlers:IUploadHandlers=null)
        {
            this.statusHandlers = statusHandlers;
        }
        
        public function uploadBrowse(parent:DisplayObject, parentNode:IRepoNode, onComplete:Function=null):void
        {
            this.onComplete = onComplete;
            this.parentNode = parentNode;
            
            var fileBrowseView:FileBrowseView = FileBrowseView(PopUpManager.createPopUp(parent, FileBrowseView, false));    
            fileBrowseView.onComplete = browseComplete;            
        }
		
		public function updateBrowse(parent:DisplayObject, parentNode:IRepoNode, repoNode:IRepoNode, onComplete:Function=null):void
		{
			this.onComplete = onComplete;
			this.parentNode = parentNode;
			this.existingNode = repoNode;
			
			var fileBrowseView:FileBrowseView = FileBrowseView(PopUpManager.createPopUp(parent, FileBrowseView, false));    
			fileBrowseView.onComplete = browseComplete;            
		}		
        
        private function browseComplete(files:Vector.<File>):void
        {
            for (var i:uint = 0; i < files.length; i++) 
            {
                trace(files[i].nativePath);                
                uploadAir(files[i], this.parentNode, this.onComplete, existingNode);   
            }            
        }
        
        /**
         * Upload a file without browse dialog (AIR only)
         * 
         * @param fileRef file reference
         * @param parentNode target folder to upload to
         * @parm onComplete function to call on complete
         * @param existingNode optional existing node item to update content, 
         *        otherwise creates new node with uploaded file                   
         * @param checkin should node be checked in also
         * 
         */
        private function uploadAir(fileRef:File, parentNode:IRepoNode, onComplete:Function=null, 
                                  existingNode:IRepoNode=null, checkin:Boolean=false):void
        {
            this.onComplete = onComplete;
            
            fileRef.addEventListener(Event.OPEN, openHandler);
            fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);                
            fileRef.addEventListener(Event.COMPLETE, completeHandler);
            fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
            fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            fileRef.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);           

            if (statusHandlers != null)
            {
                fileRef.addEventListener(Event.OPEN, statusHandlers.openHandler);
                fileRef.addEventListener(ProgressEvent.PROGRESS, statusHandlers.progressHandler);
                fileRef.addEventListener(Event.COMPLETE, statusHandlers.completeHandler);
                fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, statusHandlers.uploadCompleteDataHandler);
                fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusHandlers.httpStatusHandler);                                                    
                fileRef.addEventListener(IOErrorEvent.IO_ERROR, statusHandlers.ioErrorHandler);
                fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, statusHandlers.securityErrorHandler);
            }
            
            var url:String = null;
            var model : AppModelLocator = AppModelLocator.getInstance();                            
            if (existingNode == null)
            {
                if (model.ecmServerConfig.isLiveCycleContentServices == true)
                {
                    url = model.ecmServerConfig.urlPrefix + "/flexspaces/uploadNew"  + "?ticket=" + model.userInfo.loginTicket;
                }
                else
                {
                    url = model.ecmServerConfig.urlPrefix + "/flexspaces/uploadNew"  + "?alf_ticket=" + model.userInfo.loginTicket;
                }
            }
            else
            {
                if (model.ecmServerConfig.isLiveCycleContentServices == true)
                {
                    url = model.ecmServerConfig.urlPrefix + "/flexspaces/uploadExisting"  + "?ticket=" + model.userInfo.loginTicket;
                }
                else
                {
                    url = model.ecmServerConfig.urlPrefix + "/flexspaces/uploadExisting" + "?alf_ticket=" + model.userInfo.loginTicket;                 
                }
            }
            
            var request:URLRequest = new URLRequest(url);
            var params:URLVariables = new URLVariables();

            if (existingNode != null)
            {
                if (model.flexSpacesPresModel.wcmMode == false)
                {
                    params.nodeid = existingNode.getId();
                    params.checkin = checkin.toString().toLowerCase();
                }
                else
                {
                    params.storeid = existingNode.getStoreId();
                    params.path = existingNode.getPath();              
                }
            }
            else
            {
                if (model.flexSpacesPresModel.wcmMode == false)
                {
                    params.path = parentNode.getPath();         
                }
                else
                {
                    params.storeid = parentNode.getStoreId();
                    params.path = parentNode.getPath();
                }                                        
            }

            params.mimetype = FormatUtil.getMimeType(fileRef);
                        
            request.method = URLRequestMethod.POST;
            request.data = params;
            
            try 
            {
                fileRef.upload(request, "file");
            } 
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }

            function openHandler(event:Event):void 
            {
                var file:FileReference = FileReference(event.target);
                trace("mobileUpload openHandler: name=" + file.name);
            }

            function progressHandler(event:ProgressEvent):void
            {
                var file:FileReference = FileReference(event.target);
                trace("mobileUpload progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
            }

            function completeHandler(event:Event):void 
            {
                var file:FileReference = FileReference(event.target);
                trace("mobileUpload completeHandler: name=" + file.name);
                if (onComplete != null)
                {
                    onComplete();
                }
            }       

            function uploadCompleteDataHandler(event:DataEvent):void 
            {
                var file:FileReference = FileReference(event.target);
                trace("mobileUpload uploadCompleteDataHandler: name=" + file.name);
            }

            function httpStatusHandler(event:HTTPStatusEvent):void
            {
                var file:FileReference = FileReference(event.target);
                trace( "mobileUpload httpStatusHandler: name= " + file.name + ", status: " + event.status);
            }                                  

            function ioErrorHandler(event:IOErrorEvent):void
            {
                var file:FileReference = FileReference(event.target);
                trace("mobileUpload ioErrorHandler: name= " + file.name + ", error text: " + event.text);
            }
         
            function securityErrorHandler(event:SecurityErrorEvent):void
            {
                var file:FileReference = FileReference(event.target);
                trace("mobileUpload securityErrorHandler: name= " + file.name + ", error text: " + event.text);
            }                    
            
        }

    }
}