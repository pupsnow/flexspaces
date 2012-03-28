package org.integratedsemantics.flexspaces.view.tasks.startworkflow
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.controls.DateField;
    import mx.events.FlexEvent;
    import mx.managers.CursorManager;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.tasks.startworkflow.StartWorkflowPresModel;
    
    import spark.components.DropDownList;
    import spark.components.FormItem;
    import spark.components.TextArea;
    import spark.components.TextInput;


    /**
     * Base class for start workflow views  
     * 
     */
    public class StartWorkflowViewBase extends DialogViewBase
    {
        public var onComplete:Function;

        public var workflowTypeCombo:DropDownList;
        
        public var assignToTextInput:TextInput;
        
        public var dueDateField:DateField;

        public var descTextArea:TextArea;
        
        public var dueOnFormItem:FormItem;
        
		[Bindable]
        public var startWorkflowPresModel:StartWorkflowPresModel;         
        
        /**
         * Constructor 
         * 
         * @param onComplete handler to call after worklow is started
         * 
         */
        public function StartWorkflowViewBase(onComplete:Function=null)
        {
            super();

            this.onComplete = onComplete;                 
        }        
        
        /**
         * Handle view creation complete event
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);

            // save initial state of workflow type to pres model
            startWorkflowPresModel.workflowTypeSelection = workflowTypeCombo.selectedItem;                               
        }
        
        /**
         * Handle successful start workflow result 
         * 
         * @param info result info
         * 
         */
        protected function onResultStartWorkflow(info:Object):void
        {
            CursorManager.removeBusyCursor();

            PopUpManager.removePopUp(this);
            if (onComplete != null)
            {
                this.onComplete();
            }                
        }

        /**
         * Handle fault returned from start workflow call
         * 
         * @param info fault info
         * 
         */
        protected function onFaultStartWorkflow(info:Object):void
        {
            CursorManager.removeBusyCursor();

            trace("onFaultStartWorkflow" + info);            
            PopUpManager.removePopUp(this);
        }

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            CursorManager.setBusyCursor();

            var responder:Responder = new Responder(onResultStartWorkflow, onFaultStartWorkflow);
            
            startWorkflowPresModel.startWorkflow(responder);
        }

		protected function onChangeWorkflowType(event:Event):void
		{
	    	startWorkflowPresModel.workflowTypeSelection = workflowTypeCombo.selectedItem;    
	    }
	    
		protected function onChangeAssignToText(event:Event):void
		{
	    	startWorkflowPresModel.assignToText = assignToTextInput.text;    
	    }
	
		protected function onChangedDueDate(event:Event):void
		{
	    	startWorkflowPresModel.dueDate = dueDateField.text;    
	    }
		
		protected function onChangeDescText(event:Event):void
		{
	    	startWorkflowPresModel.descText =  descTextArea.text;    
	    }
    
    }    
}