package org.integratedsemantics.flexspaces.component.error
{
    import mx.controls.Label;
    import mx.controls.TextArea;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;

    public class ErrorDialogViewBase extends DialogViewBase
    {
        public var message:Label;
        public var stack:TextArea;
        
        
        public function ErrorDialogViewBase()
        {
            super();
        }
        
    }
}