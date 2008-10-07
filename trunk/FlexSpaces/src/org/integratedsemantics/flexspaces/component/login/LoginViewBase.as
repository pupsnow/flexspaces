package org.integratedsemantics.flexspaces.component.login
{
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.Text;
    import mx.controls.TextInput;
    
        
    /**
     * Base class for login views  
     * 
     */
    public class LoginViewBase extends VBox
    {
        public var errorMessage:Text;
        public var username:TextInput;
        public var password:TextInput;
        public var loginBtn:Button;
        
        /**
         * Constructor 
         */
        public function LoginViewBase()
        {
            super();
        }        
    }
}