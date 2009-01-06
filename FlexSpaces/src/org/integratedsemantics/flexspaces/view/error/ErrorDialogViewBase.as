package org.integratedsemantics.flexspaces.view.error
{
    import flash.events.MouseEvent;
    
    import mx.controls.Text;
    import mx.controls.TextArea;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.error.ErrorDialogPresModel;


    public class ErrorDialogViewBase extends DialogViewBase
    {
        public var message:Text;
        public var stack:TextArea;

        [Bindable]
        public var errorDialogPresModel:ErrorDialogPresModel;
                
        
        public function ErrorDialogViewBase()
        {
            super();
        }
        
        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);

            message.text = errorDialogPresModel.message;
            stack.text = errorDialogPresModel.stack;
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
        
        
    }
}