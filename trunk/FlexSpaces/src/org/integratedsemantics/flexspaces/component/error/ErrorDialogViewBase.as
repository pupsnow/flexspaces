package org.integratedsemantics.flexspaces.component.error
{
    import mx.controls.Text;
    import mx.controls.TextArea;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;

    public class ErrorDialogViewBase extends DialogViewBase
    {
        public var message:Text;
        public var stack:TextArea;
        
        
        public function ErrorDialogViewBase()
        {
            super();
        }
        
    }
}