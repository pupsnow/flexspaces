package org.integratedsemantics.flexspaces.presmodel.error
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;


	[Bindable]
    public class ErrorDialogPresModel extends PresModel
    {
        public var message:String;
        public var stack:String;
        
        
        /**
         * Constructor 
         * 
         * @param message error message
         * @param stack error stack
         * 
         */
        public function ErrorDialogPresModel(message:String, stack:String)
        {
            super();
            
            this.message = message;
            this.stack = stack;
        }
                
    }
}