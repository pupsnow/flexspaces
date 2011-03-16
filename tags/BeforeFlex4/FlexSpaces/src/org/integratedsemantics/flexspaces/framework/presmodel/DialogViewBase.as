package org.integratedsemantics.flexspaces.framework.presmodel
{
    import flash.events.MouseEvent;
    
    import mx.containers.TitleWindow;
    import mx.controls.Button;
    import mx.controls.TextInput;
    import mx.core.UIComponent;
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.util.ObserveUtil;


    /**
     * Base View class for dialog views 
     * 
     */
    public class DialogViewBase extends TitleWindow
    {
        public var okBtn:Button;
        public var cancelBtn:Button;
        public var closeBtn:Button;
        
        /**
         * Constructor 
         */
        public function DialogViewBase()
        {
            super();

            observeCreation(this, onCreationComplete);
            
            addEventListener(CloseEvent.CLOSE, onXCloseBtn);            
        }
        
        /**
         * Handle view creation complete
         * 
         * @param creation complete event 
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            PopUpManager.centerPopUp(this);
            
            if (okBtn != null)
            {
                observeButtonClick(okBtn, onOkBtn);
            }
            
            if (cancelBtn != null)
            {
                observeButtonClick(cancelBtn, onCancelBtn);
            }                                    

            if (closeBtn != null)
            {
                observeButtonClick(closeBtn, onCloseBtn);
            }                                    
        }    

        /**
         * Handle dialog window close button click
         * (for X button in upper right of window)
         * 
         * @param close event
         * 
         */
        protected function onXCloseBtn(event:CloseEvent):void 
        {
            PopUpManager.removePopUp(this);
        }
        
        /**
         * Handle close buttion click
         * (for close button on in dialog not for X button)
         * 
         * @param click event
         * 
         */
        protected function onCloseBtn(event:MouseEvent):void 
        {
            // place holder to allow event listen hookup    
        }

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        protected function onOkBtn(event:MouseEvent):void 
        {
            // place holder to allow event listen hookup    
        }
        
        /**
         * Handle cancel button click
         * 
         * @param event click event
         * 
         */
        protected function onCancelBtn(event:MouseEvent):void
        {
            PopUpManager.removePopUp(this);            
        }                       
        
        /**
         * Hook up event listener for a button click
         *  
         * @param button  button to add click listener for
         * @param handler event listener handler to hook up
         * 
         */
        protected function observeButtonClick(button:Button, handler:Function):void
        {
            ObserveUtil.observeButtonClick(button, handler);
        }       

        /**
         * Hook up event listener for a text input field change
         *  
         * @param textInput text input control
         * @param handler event listener handler to hook up
         * 
         */
        protected function observeTextInputChange(textInput:TextInput, handler:Function):void
        {
            ObserveUtil.observeTextInputChange(textInput, handler);
        } 
                
        /**
         * Hook up event listener for creation complete
         *  
         * @param uiComponent  component to observe creation complete on
         * @param handler event listener handler to hook up
         * 
         */
        protected function observeCreation(uiComponent:UIComponent, handler:Function):void
        {
            ObserveUtil.observeCreation(uiComponent, handler);
        }                               
        
    }
}