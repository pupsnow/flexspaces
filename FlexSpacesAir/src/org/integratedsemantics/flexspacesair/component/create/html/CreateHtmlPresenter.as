package org.integratedsemantics.flexspacesair.component.create.html
{
    import flash.filesystem.File;
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;


    /**
     *  Create HTML Content dialog presenter
     *  
     *  Presenter/Controller of CreateHtmlViewBase views
     * 
     */
    public class CreateHtmlPresenter extends DialogPresenter
    {
        protected var onComplete:Function;

        
        /**
         * Constructor
         *  
         * @param createHtmlView view to control
         * @param onComplete handler to continue process after UI
         * 
         */
        public function CreateHtmlPresenter(createHtmlView:CreateHtmlViewBase, onComplete:Function)
        {
            super(createHtmlView);
            
            this.onComplete = onComplete;
        }
                
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get createHtmlView():CreateHtmlViewBase
        {
            return this.view as CreateHtmlViewBase;            
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
            
            createHtmlView.htmlControl.location =  File.applicationDirectory.resolvePath("web/create-html.html").nativePath;
            // need to add missing file protocol on mac needed on mac, leave alone on windows and linux
            if (createHtmlView.htmlControl.location.indexOf(":") == -1)
            {
                createHtmlView.htmlControl.location = "file://" + createHtmlView.htmlControl.location;
            }
            trace("htmlControl.location: " + createHtmlView.htmlControl.location);
        }     
        
        /**
         * Set content of html control
         * 
         * @param content string to set content with
         * 
         */
        public function setContent(content:String):void
        {
            var content:String = createHtmlView.htmlControl.htmlLoader.window.setContent(content);                       
        }
        
        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {            
            // from actionscript call javascript function
            var content:String = createHtmlView.htmlControl.htmlLoader.window.getEditedContent();
            
            var filename:String = createHtmlView.nodename.text;
                        
            PopUpManager.removePopUp(createHtmlView);

            this.onComplete(filename, content);                
        }        

    }
    
}