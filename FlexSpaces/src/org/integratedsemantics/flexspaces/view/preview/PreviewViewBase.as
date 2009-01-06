package org.integratedsemantics.flexspaces.view.preview
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.containers.Panel;
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.HSlider;
    import mx.controls.LinkButton;
    import mx.controls.SWFLoader;
    import mx.events.SliderEvent;
    import mx.printing.FlexPrintJob;
    import mx.printing.FlexPrintJobScaleType;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.presmodel.preview.PreviewPresModel;
    import org.integratedsemantics.flexspaces.util.ObserveUtil;
    
        
    /**
     * Base class for preview views  
     * 
     */
    public class PreviewViewBase extends VBox
    {
        public var printBtn:LinkButton;
        
        public var zoomSlider:HSlider;
        
        public var previousPageBtn:Button
        public var nextPageBtn:Button;
        
        public var zoomOutButton:Button
        public var zoomInButton:Button;
        
        public var contentPanel:Panel;
        public var swfLoader:SWFLoader;
                
        [Bindable]
        public var previewPresModel:PreviewPresModel;
                
        /**
         * Constructor 
         */
        public function PreviewViewBase()
        {
            super();
        }     
        
        /**
         * Handle initialization after view has its creation complete
         *  
         * @param event create complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            swfLoader.addEventListener(Event.INIT, onLoadSwfComplete);
            swfLoader.addEventListener(Event.COMPLETE, onLoadSwfComplete);

            ObserveUtil.observeButtonClick(printBtn, onPrint);
            ObserveUtil.observeButtonClick(previousPageBtn, onPreviousPageClick);
            ObserveUtil.observeButtonClick(nextPageBtn, onNextPageClick);
            ObserveUtil.observeButtonClick(zoomInButton, onZoomIn);
            ObserveUtil.observeButtonClick(zoomOutButton, onZoomOut);

            zoomSlider.addEventListener(SliderEvent.CHANGE, onZoomSliderChange);  
                
            var responder:Responder = new Responder(onResultGetPreview, onFaultGetPreview);
            previewPresModel.getPreview(responder);          
        }                 
        
        /**
         * Handle print button click
         *  
         * @param event click event
         * 
         */
        protected function onPrint(event:MouseEvent):void 
        {
            if (previewPresModel.havePreview == true)
            {
                // Create an instance of the FlexPrintJob class.
                var printJob:FlexPrintJob = new FlexPrintJob();
    
                // Start the print job.
                if (printJob.start() != true)
                {
                	return;	
                }
    
                // Add the object to print. Scale it to match the width.
                printJob.addObject(contentPanel, FlexPrintJobScaleType.MATCH_WIDTH);
                
                // Send the job to the printer.
                printJob.send();
            }
        }
                                           
        /**
         * Zoom preview when zoom level slider changes
         * 
         * @param event slider change event
         * 
         */        
        protected function onZoomSliderChange(event:SliderEvent):void
        {
            swfLoader.scaleX = zoomSlider.value;
            swfLoader.scaleY = zoomSlider.value;
        }
        
        /**
         * Handles click on previous page button
         * 
         * @param event click event
         */
        protected function onPreviousPageClick(event:MouseEvent):void
        {
            if ((swfLoader.content != null) && (swfLoader.content is MovieClip))
            {
                var docMovie:MovieClip = swfLoader.content as MovieClip
                var curFrame:int = docMovie.currentFrame;
                if (curFrame > 1)
                {
                    docMovie.prevFrame();                        
                }       
            }                 
        }
        
        /**
         * Handles click on next page button
         *  
         * @param event click event
         * 
         */
        protected function onNextPageClick(event:MouseEvent):void
        {
            if ((swfLoader.content != null) && (swfLoader.content is MovieClip))
            {
                var docMovie:MovieClip = swfLoader.content as MovieClip;
                var curFrame:int = docMovie.currentFrame;
                var numFrames:int = docMovie.totalFrames;
                if (curFrame < numFrames)
                {
                    docMovie.nextFrame();
                }
            }                        
        }
        
        /**
         * Handles click on zoom in button 
         * 
         * @param event click event
         * 
         */
        protected function onZoomIn(event:MouseEvent):void
        {
            swfLoader.scaleX = swfLoader.scaleX * 2;
            swfLoader.scaleY = swfLoader.scaleY * 2;
        }

        /**
         * Handles click on zoom out button 
         * 
         * @param event click event
         * 
         */
        protected function onZoomOut(event:MouseEvent):void
        {
            swfLoader.scaleX = swfLoader.scaleX / 2;
            swfLoader.scaleY = swfLoader.scaleY / 2;
        }

        /**
         * Handles return of result from pres model
         *  
         * @param data preview id, url data
         * 
         */
        protected function onResultGetPreview(data:Object):void
        {
            if (previewPresModel.havePreview == true)
            {                
                swfLoader.source = previewPresModel.urlFlash;        
                contentPanel.title = previewPresModel.repoNode.getPath();
            }
        }  
        
        /**
         * Handles return of fault from pres model
         *   
         * @param info
         * 
         */
        protected function onFaultGetPreview(info:Object):void
        {
        }

        /**
         * Handles stopping flash swf from auto-advancing
         *   
         * @param event load complete evnet
         * 
         */
        protected function onLoadSwfComplete(event:Event):void
        {
            // stop wild auto advancing
            if ((swfLoader.content != null) && (swfLoader.content is MovieClip))
            {
                var docMovie:MovieClip = swfLoader.content as MovieClip;
                docMovie.stop();
                docMovie.gotoAndStop(1);
            }
        }        
            
    }
}