package org.integratedsemantics.flexspaces.util
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.controls.LinkButton;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    
    import spark.components.Button;
    import spark.components.TextInput;


    /**
     * Utility functions for Observing 
     * 
     */
    public class ObserveUtil
    {
        /**
         * Hook up event listener for a button click
         *  
         * @param button  button to add click listener for
         * @param handler event listener handler to hook up
         * 
         */
        public static function observeButtonClick(button:spark.components.Button, handler:Function):void
        {
            button.addEventListener(MouseEvent.CLICK, handler);
        }    

        public static function observeMxButtonClick(button:mx.controls.Button, handler:Function):void
        {
            button.addEventListener(MouseEvent.CLICK, handler);
        }    
        
        /**
         * Hook up event listener for a button click
         *  
         * @param button  button to add click listener for
         * @param handler event listener handler to hook up
         * 
         */
        public static function observeLinkButtonClick(button:LinkButton, handler:Function):void
        {
            button.addEventListener(MouseEvent.CLICK, handler);
        }    
        
        
        /**
         * Hook up event listener for a text input field change
         *  
         * @param textInput text input control
         * @param handler event listener handler to hook up
         * 
         */
        public static function observeTextInputChange(textInput:TextInput, handler:Function):void
        {
            textInput.addEventListener(Event.CHANGE, handler);
        }  
        
        /**
         * Hook up event listener for creation complete
         *  
         * @param uiComponent  component to observe creation complete on
         * @param handler event listener handler to hook up
         * 
         */
        public static function observeCreation(uiComponent:UIComponent, handler:Function):void
        {
            uiComponent.addEventListener(FlexEvent.CREATION_COMPLETE, handler);
        }                               
        
    }
}