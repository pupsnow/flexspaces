package org.integratedsemantics.flexspacesair.view.create.xml
{
    import flash.events.MouseEvent;
    
    import mx.controls.TextArea;
    import mx.controls.TextInput;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspacesair.presmodel.create.CreateXmlPresModel;


    /**
     * Base class for create xml views  
     * 
     */
    public class CreateXmlViewBase extends DialogViewBase
    {
        public var nodename:TextInput;
        public var textarea:TextArea;
        
        public var onComplete:Function = null;

        [Bindable]
        public var presModel:CreateXmlPresModel;
        
        
        /**
         * Constructor 
         */
        public function CreateXmlViewBase()
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