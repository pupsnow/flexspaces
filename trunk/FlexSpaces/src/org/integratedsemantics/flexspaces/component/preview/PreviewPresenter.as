package org.integratedsemantics.flexspaces.component.preview
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.events.SliderEvent;
    import mx.printing.*;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.preview.GetPreviewEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Displays view with flash preview of doc with zoom, paging, etc. controls
     * 
     *  Presenter/Controller of passive PreviewViewBase views 
     */      
    public class PreviewPresenter extends Presenter
    {
        protected var repoNode:IRepoNode;
        
        protected var havePreview:Boolean = false;
             

        /**
         * Constructor
         *  
         * @param previewView preview view being controlled
         * @param repoNode  doc node to preview
         * 
         */
        public function PreviewPresenter(previewView:PreviewViewBase, repoNode:IRepoNode)
        {
            super(previewView);
            
            this.repoNode = repoNode;
            
            if (previewView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(previewView, onCreationComplete);            
            }            
        }
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get previewView():PreviewViewBase
        {
            return this.view as PreviewViewBase;            
        }       

        /**
         * Handle initialization after view has its creation complete
         *  
         * @param event create complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            previewView.swfLoader.addEventListener(Event.INIT, onLoadSwfComplete);
            previewView.swfLoader.addEventListener(Event.COMPLETE, onLoadSwfComplete);

            observeButtonClick(previewView.printBtn, onPrint);
            observeButtonClick(previewView.previousPageBtn, onPreviousPageClick);
            observeButtonClick(previewView.nextPageBtn, onNextPageClick);
            observeButtonClick(previewView.zoomInButton, onZoomIn);
            observeButtonClick(previewView.zoomOutButton, onZoomOut);

            previewView.zoomSlider.addEventListener(SliderEvent.CHANGE, onZoomSliderChange);  
                      
            var responder:Responder = new Responder(onResultGetPreview, onFaultGetPreview);
            var getPreviewEvent:GetPreviewEvent = new GetPreviewEvent(GetPreviewEvent.GET_PREVIEW, responder, repoNode);
            getPreviewEvent.dispatch();                    
        }                 
        
        /**
         * Handle print button click
         *  
         * @param event click event
         * 
         */
        protected function onPrint(event:MouseEvent):void 
        {
            if (this.havePreview == true)
            {
                // Create an instance of the FlexPrintJob class.
                var printJob:FlexPrintJob = new FlexPrintJob();
    
                // Start the print job.
                if (printJob.start() != true) return;
    
                // Add the object to print. Scale it to match the width.
                printJob.addObject(previewView.contentPanel, FlexPrintJobScaleType.MATCH_WIDTH);
                
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
            previewView.swfLoader.scaleX = previewView.zoomSlider.value;
            previewView.swfLoader.scaleY = previewView.zoomSlider.value;
        }
        
        /**
         * Handles click on previous page button
         * 
         * @param event click event
         */
        protected function onPreviousPageClick(event:MouseEvent):void
        {
            if ((previewView.swfLoader.content != null) && (previewView.swfLoader.content is MovieClip))
            {
                var docMovie:MovieClip = previewView.swfLoader.content as MovieClip
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
            if ((previewView.swfLoader.content != null) && (previewView.swfLoader.content is MovieClip))
            {
                var docMovie:MovieClip = previewView.swfLoader.content as MovieClip;
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
            previewView.swfLoader.scaleX = previewView.swfLoader.scaleX * 2;
            previewView.swfLoader.scaleY = previewView.swfLoader.scaleY * 2;
        }

        /**
         * Handles click on zoom out button 
         * 
         * @param event click event
         * 
         */
        protected function onZoomOut(event:MouseEvent):void
        {
            previewView.swfLoader.scaleX = previewView.swfLoader.scaleX / 2;
            previewView.swfLoader.scaleY = previewView.swfLoader.scaleY / 2;
        }

        /**
         * Handles return of result from server on getting preview id
         *  
         * @param data preview id, url data
         * 
         */
        protected function onResultGetPreview(data:Object):void
        {
            var result:XML = data as XML;
            var previewId:String = result.previewid;
            var previewURL:String = result.previewurl;

            if (previewId != null && previewId != "")
            {                
                var model : AppModelLocator = AppModelLocator.getInstance();                
                var urlFlash:String = previewURL + "?alf_ticket=" + model.loginTicket;                  
                previewView.swfLoader.source = urlFlash;        
                previewView.contentPanel.title = repoNode.getPath();
                this.havePreview = true;                              
            }
            else
            {   
                trace("onGetPreviewComplete no preview");
            }
        }  
        
        /**
         * Handles return of fault from server on getting preview id
         *   
         * @param info
         * 
         */
        protected function onFaultGetPreview(info:Object):void
        {
            trace("onFaultGetPreview " + info);     
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
            if ((previewView.swfLoader.content != null) && (previewView.swfLoader.content is MovieClip))
            {
                var docMovie:MovieClip = previewView.swfLoader.content as MovieClip;
                docMovie.stop();
                docMovie.gotoAndStop(1);
            }
        }        
    
    }
        
}