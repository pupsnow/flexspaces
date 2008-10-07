package org.integratedsemantics.flexspaces.component.logout
{
    import mx.containers.Box;
    import mx.controls.LinkButton;
    
        
    /**
     * Base class for logout views  
     * 
     */
    public class LogoutViewBase extends Box
    {
        public var logoutBtn:LinkButton
        
        /**
         * Constructor 
         */
        public function LogoutViewBase()
        {
            super();
        }        
    }
}