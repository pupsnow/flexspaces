package org.integratedsemantics.flexspaces.component.login
{
    import mx.controls.Button;
    import mx.controls.Text;
    import mx.controls.TextInput;
    import mx.core.Container;
    
        
    public interface ILoginView 
    {
		function get view():Container;
		
        function get errorMessage():Text;
        
        function get username():TextInput;
        
        function get password():TextInput;
        
        function get loginBtn():Button;        
    }
}