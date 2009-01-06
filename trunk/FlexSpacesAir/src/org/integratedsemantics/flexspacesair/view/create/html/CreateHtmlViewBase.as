package org.integratedsemantics.flexspacesair.view.create.html
{
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    
    import mx.controls.HTML;
    import mx.controls.TextInput;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspacesair.presmodel.create.CreateHtmlPresModel;


    /**
     * Base class for create html views  
     * 
     */
    public class CreateHtmlViewBase extends DialogViewBase
    {
        public var nodename:TextInput;
        public var htmlControl:HTML;
        
        public var onComplete:Function = null;
        
        [Bindable]
        public var presModel:CreateHtmlPresModel;
        

        /**
         * Constructor
         * 
         */
        public function CreateHtmlViewBase()
        {
            super();
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
            
            htmlControl.location =  File.applicationDirectory.resolvePath("web/create-html.html").nativePath;
            // need to add missing file protocol on mac needed on mac, leave alone on windows and linux
            if (htmlControl.location.indexOf(":") == -1)
            {
                htmlControl.location = "file://" + htmlControl.location;
            }
            trace("htmlControl.location: " + htmlControl.location);
        }     
        
        /**
         * Set content of html control
         * 
         * @param content string to set content with
         * 
         */
        public function setContent(content:String):void
        {
            var content:String = htmlControl.htmlLoader.window.setContent(content);                       
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
            var content:String = htmlControl.htmlLoader.window.getEditedContent();
            
            var filename:String = nodename.text;
                        
            PopUpManager.removePopUp(this);

            if (onComplete != null)
            {
            	this.onComplete(filename, content);
            }
        }        
          
    }
}