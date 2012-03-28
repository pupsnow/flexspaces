package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.PreviewDelegate;
    import org.integratedsemantics.flexspaces.control.event.preview.GetPreviewEvent;
    import org.integratedsemantics.flexspaces.control.event.preview.MakePreviewEvent;

    
    /**
     * Preview command provides operations to make flash previews of documents 
     * and to lookup existing flash previews
     * 
     */
    public class PreviewCommand extends Command
    {
        /**
         * Constructor
         */        
        public function PreviewCommand()
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
                case MakePreviewEvent.MAKE_PREVIEW:
                    makeFlashPreview(event as MakePreviewEvent);  
                    break;
                case GetPreviewEvent.GET_PREVIEW:
                    getPreview(event as GetPreviewEvent);  
                    break;
            }
        }       

        /**
         * Get preview (if it has already been created) for doc
         * 
         * @param event get preview event
         */
        public function getPreview(event:GetPreviewEvent):void
        {
            var handlers:Callbacks = new Callbacks(onGetPreviewSuccess, onFault);
            var delegate:PreviewDelegate = new PreviewDelegate(handlers);
            delegate.getPreview(event.repoNode);                  
        }

        /**
         * onGetPreviewSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetPreviewSuccess(event:*):void
        {            
	        this.result(event.result);                
        }
        
        /**
         * Make flash preview rendition
         * 
         * @param event make preview event
         */
        public function makeFlashPreview(event:MakePreviewEvent):void
        {
            var handlers:Callbacks = new Callbacks(onMakePreviewRenditionSuccess, onFault);
            var delegate:PreviewDelegate = new PreviewDelegate(handlers);
            delegate.makeFlashPreview(event.repoNode, event.parentNode);                  
        }

        /**
         * onMakePreviewRenditionSuccess event handler
         * 
         * @param event success event
         */
        protected function onMakePreviewRenditionSuccess(event:*):void
        {
            trace("onMakePreviewRenditionSuccess");
            this.result(event.result);                            
        }
                           
    }
}