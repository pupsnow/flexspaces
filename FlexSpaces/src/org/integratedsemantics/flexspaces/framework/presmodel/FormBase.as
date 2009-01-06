package org.integratedsemantics.flexspaces.framework.presmodel
{
	import mx.containers.Form;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	import org.integratedsemantics.flexspaces.util.ObserveUtil;

	public class FormBase extends Form
	{
		public function FormBase()
		{
			super();
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