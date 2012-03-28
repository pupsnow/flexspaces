package org.integratedsemantics.flexspacesairmobile.view.create.html
{
    import com.flexcapacitor.controls.WebView;
    
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    
    import mx.events.FlexEvent;
    import mx.managers.CursorManager;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.view.rte.RichTextEdit;
    import org.integratedsemantics.flexspacesair.presmodel.create.CreateHtmlPresModel;
    
    import spark.components.TextInput;


    /**
     * Base class for create html views  
     * 
     */
    public class CreateHtmlViewBase extends DialogViewBase
    {
        public var nodename:TextInput;
        public var rteControl:RichTextEdit;
        
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
        }     
        
        /**
         * Set content of html control
         * 
         * @param content string to set content with
         * 
         */
        public function setContent(content:String):void
        {
            var content:String = rteControl.htmlText= content;                       
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
            // var content:String = htmlControl.htmlLoader.window.getEditedContent();
            var content:String = rteControl.htmlText;
            
            var filename:String = nodename.text;
                        
            PopUpManager.removePopUp(this);

            if (onComplete != null)
            {
            	this.onComplete(filename, content);
            }
        }        
          
    }
}