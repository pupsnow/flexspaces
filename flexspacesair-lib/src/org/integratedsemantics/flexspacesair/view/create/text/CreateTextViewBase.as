package org.integratedsemantics.flexspacesair.view.create.text
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspacesair.presmodel.create.CreateTextPresModel;
    
    import spark.components.TextArea;
    import spark.components.TextInput;


    /**
     * Base class for create text views  
     * 
     */
    public class CreateTextViewBase extends DialogViewBase
    {
        public var nodename:TextInput;
        public var textarea:TextArea;

        public var onComplete:Function = null;
        
        [Bindable]
        public var presModel:CreateTextPresModel;
        
        
        /**
         * Constructor 
         */
        public function CreateTextViewBase()
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
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            PopUpManager.removePopUp(this);

            if (onComplete != null)
            {
	            this.onComplete(nodename.text, textarea.text);      
            }                      
        }
              
    }
}