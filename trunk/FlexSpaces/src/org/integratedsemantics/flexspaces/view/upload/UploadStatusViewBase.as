package org.integratedsemantics.flexspaces.view.upload
{
    import flash.net.FileReference;
    
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.FileReference;
    
    import mx.containers.VBox;
    import mx.events.FlexEvent;
    import mx.formatters.NumberFormatter;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.command.IUploadHandlers;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.upload.UploadStatusPresModel;


    public class UploadStatusViewBase extends DialogViewBase implements IUploadHandlers
    {
        public var progressBarsArea:VBox;

        public var uploadProgressBars:Array;

        [Bindable]
        public var uploadStatusPresModel:UploadStatusPresModel;
        
                
        public function UploadStatusViewBase()
        {
            super();
            
            uploadProgressBars = new Array();                        
        }
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {           
            super.onCreationComplete(event);

            for each (var file:FileReference in uploadStatusPresModel.fileReferences)
            {
                var uploadProgressBar:UploadProgressBarBase = new UploadProgressBar();
                uploadProgressBars.push(uploadProgressBar);
                progressBarsArea.addChild(uploadProgressBar);
                // todo i18n
                uploadProgressBar.filenameLabel.text = file.name + ",  Uploading";
                uploadProgressBar.progressBar.maximum = file.size;
                uploadProgressBar.progressBar.setProgress(0, file.size);
            }            
        }

        /**
         * Handle close buttion click
         * (not for X close in title area)
         * 
         * @param click event
         * 
         */
        override protected function onCloseBtn(event:MouseEvent):void 
        {            
            PopUpManager.removePopUp(this);
        }

        /**
         * File open event
         * 
         * @param event open event
         * 
         */
        public function openHandler(event:Event):void 
        {
            var file:FileReference = FileReference(event.target);
        }
     
        /**
         * File upload progress event handler
         *  
         * @param event
         * 
         */
        public function progressHandler(event:ProgressEvent):void
        {
            var file:FileReference = FileReference(event.target);
            
            var uploadProgressBar:UploadProgressBarBase = getUploadProgressBarForFile(file);
            
            if (uploadProgressBar != null)
            {
                uploadProgressBar.progressBar.setProgress(event.bytesLoaded, event.bytesTotal);    
                uploadProgressBar.progressBar.label = uploadStatusPresModel.bytesToKiloBytesDisplay(event.bytesLoaded) + " of " 
                                                      + uploadStatusPresModel.bytesToKiloBytesDisplay(event.bytesTotal) + ", %3%%";  
                // update text if retry after io error
                // todo i18n
                uploadProgressBar.filenameLabel.text = file.name + ",  Uploading";                                                                
            }   
        }
     
        /**
         * File upload complete handler
         *  
         * @param event complete event
         * 
         */
        public function completeHandler(event:Event):void
        {
            var file:FileReference = FileReference(event.target);

            var uploadProgressBar:UploadProgressBarBase = getUploadProgressBarForFile(file);
            
            if (uploadProgressBar != null)
            {
                uploadProgressBar.progressBar.setProgress(file.size, file.size);                
                uploadProgressBar.progressBar.label = uploadStatusPresModel.bytesToKiloBytesDisplay(file.size) + " of " 
                                                      + uploadStatusPresModel.bytesToKiloBytesDisplay(file.size) + ", %3%%";            
                uploadProgressBar.filenameLabel.text = file.name + ",  Completed";                
            }   
        }
     
        public function complete(target:Object):void
        {
            var file:FileReference = FileReference(target);

            // todo share code with completeHandler in a method
            var uploadProgressBar:UploadProgressBarBase = getUploadProgressBarForFile(file);
            
            if (uploadProgressBar != null)
            {
                uploadProgressBar.progressBar.setProgress(file.size, file.size);                
                uploadProgressBar.progressBar.label = uploadStatusPresModel.bytesToKiloBytesDisplay(file.size) + " of " 
                                                      + uploadStatusPresModel.bytesToKiloBytesDisplay(file.size) + ", %3%%";            
                uploadProgressBar.filenameLabel.text = file.name + ",  Completed";                
            }   
        }
               
        /**
         * File uploaded and data returned event handler
         *  
         * @param event upload data complete event
         * 
         */
        public function uploadCompleteDataHandler(event:DataEvent):void 
        {
            var file:FileReference = FileReference(event.target);
        }

        /**
         * file i/o error handler
         *  
         * @param event io error event
         * 
         */
        public function ioErrorHandler(event:IOErrorEvent):void
        {
            var file:FileReference = FileReference(event.target);

            var uploadProgressBar:UploadProgressBarBase = getUploadProgressBarForFile(file);
            
            if (uploadProgressBar != null)
            {
                uploadProgressBar.filenameLabel.text = file.name + ",  io error: " +  event.text;              
            }               
        }
     
        /**
         * Security error handler
         *  
         * @param event security error event
         * 
         */
        public function securityErrorHandler(event:SecurityErrorEvent):void
        {
            var file:FileReference = FileReference(event.target);

            var uploadProgressBar:UploadProgressBarBase = getUploadProgressBarForFile(file);

            if (uploadProgressBar != null)
            {
                uploadProgressBar.filenameLabel.text = file.name + ",  security error: " +  event.text;              
            }               
        }                 
        
        /**
         * HTTP status handler 
         * @param event http status event
         * 
         */
        public function httpStatusHandler(event:HTTPStatusEvent):void
        {
            var file:FileReference = FileReference(event.target);
            
            // note: will get a ioError event next, so ioErrorHandler() will also handle
            var uploadProgressBar:UploadProgressBarBase = getUploadProgressBarForFile(file);            
            if (uploadProgressBar != null)
            {
                uploadProgressBar.filenameLabel.text = file.name + ",  failure, http status: " +  event.status;              
            }               
        }      
        
        /**
         * Get the upload progress bar component for a file
         * 
         * @param file file reference for file
         * @return upload progress bar
         * 
         */
        protected function getUploadProgressBarForFile(file:FileReference):UploadProgressBarBase
        {
            var uploadProgressBar:UploadProgressBarBase = null;
            
            for (var i:uint = 0; i <uploadStatusPresModel.fileReferences.length; i++)
            {
                if ( file == FileReference(uploadStatusPresModel.fileReferences[i]) )
                {
                    if (uploadProgressBars.length > i)
                    {
                        uploadProgressBar = this.uploadProgressBars[i];
                    }      
                    break;
                }
            }  
            return uploadProgressBar;          
        } 
                
    }
}