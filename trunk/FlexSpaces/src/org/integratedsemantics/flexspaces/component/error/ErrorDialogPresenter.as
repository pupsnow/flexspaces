package org.integratedsemantics.flexspaces.component.error
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;

    public class ErrorDialogPresenter extends DialogPresenter
    {
        protected var message:String;
        protected var stack:String;
        
        
        /**
         * Constructor 
         * 
         * @param errorDialogView  view for to control
         * @param message error message
         * @param stack error stack
         * 
         */
        public function ErrorDialogPresenter(errorDialogView:ErrorDialogViewBase, message:String, stack:String)
        {
            super(errorDialogView);
            
            this.message = message;
            this.stack = stack;
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get errorDialogView():ErrorDialogViewBase
        {
            return this.view as ErrorDialogViewBase;            
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

            errorDialogView.message.text = message;
            errorDialogView.stack.text = stack;
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
            PopUpManager.removePopUp(errorDialogView);
        }
        
    }
}