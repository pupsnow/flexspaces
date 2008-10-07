package org.integratedsemantics.flexspaces.component.upload
{
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.FileReference;
    
    import mx.events.FlexEvent;
    import mx.formatters.NumberFormatter;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.command.IUploadHandlers;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;


    /**
     * Provides status on multiple file uploads with multiple progress bars
     * 
     * Presenter/Controller of UploadStatusViewBase views
     *  
     */
    public class UploadStatusPresenter extends DialogPresenter implements IUploadHandlers
    {
        protected var fileReferences:Array;
        protected var uploadProgressBars:Array;
        
        /**
         * Constructor
         *  
         * @param uploadStatusView
         * @param fileRefList files being uploaded
         */
        public function UploadStatusPresenter(uploadStatusView:UploadStatusViewBase, fileReferences:Array)
        {
            super(uploadStatusView);
            
            this.fileReferences = fileReferences;     
            
            uploadProgressBars = new Array();            
        }
        
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get uploadStatusView():UploadStatusViewBase
        {
            return this.view as UploadStatusViewBase;            
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

            for each (var file:FileReference in fileReferences)
            {
                var uploadProgressBar:UploadProgressBarBase = new UploadProgressBar();
                uploadProgressBars.push(uploadProgressBar);
                uploadStatusView.progressBarsArea.addChild(uploadProgressBar);
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
            PopUpManager.removePopUp(uploadStatusView);
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
                uploadProgressBar.progressBar.label = bytesToKiloBytesDisplay(event.bytesLoaded) + " of " 
                                                      + bytesToKiloBytesDisplay(event.bytesTotal) + ", %3%%";  
                // update text if retry after io error
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
                uploadProgressBar.progressBar.label = bytesToKiloBytesDisplay(file.size) + " of " 
                                                      + bytesToKiloBytesDisplay(file.size) + ", %3%%";            
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
            
            for (var i:uint = 0; i < fileReferences.length; i++)
            {
                if ( file == FileReference(fileReferences[i]) )
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
        
        /**
         * Convert bytes to kb display number
         *  
         * @param bytes number in bytes
         * @return number in kilobytes with kb label
         * 
         */
        protected function bytesToKiloBytesDisplay(bytes:Number):String 
        {
            var display:String;
            
            if (bytes < 1024)
            {
                display = bytes + " bytes";    
            }
            else if (bytes < 1048576)
            { 
                var formatter:NumberFormatter = new NumberFormatter();
                formatter.precision = 1;
                display = formatter.format(bytes / 1024) + ' KB';
            }
            else
            {
                formatter = new NumberFormatter();
                formatter.precision = 2;
                display = formatter.format(bytes / 1048576) + ' MB';                
            }
            
            return display;
        }
                
    }
}