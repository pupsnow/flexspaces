package org.integratedsemantics.flexspaces.component.tasks.startworkflow
{
    import mx.controls.ComboBox;
    import mx.controls.DateField;
    import mx.controls.TextArea;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for start workflow views  
     * 
     */
    public class StartWorkflowViewBase extends DialogViewBase
    {
        public var workflowTypeCombo:ComboBox;
        
        public var assignToTextInput:TextInput;
        
        public var dueDateField:DateField;

        public var descTextArea:TextArea;
        
        /**
         * Constructor 
         */
        public function StartWorkflowViewBase()
        {
            super();
        }        
    }
}