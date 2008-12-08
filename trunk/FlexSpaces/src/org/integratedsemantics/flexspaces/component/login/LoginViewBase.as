package org.integratedsemantics.flexspaces.component.login
{
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.Text;
    import mx.controls.TextInput;
    import mx.core.Container;
    
        
    /**
     * Base class for login views  
     * 
     */
    public class LoginViewBase  extends VBox implements ILoginView
    {
    	// ILoginView
        [Bindable] public var errorMessage:Text;
        [Bindable] public var username:TextInput;
        [Bindable] public var password:TextInput;
        [Bindable] public var loginBtn:Button;
        
        /**
         * Constructor 
         */
        public function LoginViewBase()
        {
            super();
        }   
            
		/**
		 * getter of view for ILoginView
		 * 
		 * @return the view
		 * 
		 */
		public function get view():Container
		{
			return this;
		}                  				    			             
    }
}