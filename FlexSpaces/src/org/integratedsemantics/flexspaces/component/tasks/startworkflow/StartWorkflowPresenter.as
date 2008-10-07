package org.integratedsemantics.flexspaces.component.tasks.startworkflow
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.formatters.DateFormatter;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.task.StartWorkflowEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     *  Start Workflow dialog presenter for starting workflow on documents
     *  
     *  Presenter/Controller of StartWorkflowView views 
     * 
     */
    public class StartWorkflowPresenter extends DialogPresenter
    {
        protected var repoNode:IRepoNode;
        protected var onComplete:Function;
        
                
        /**
         * Constructor
         *  
         * @param startWorkflowView view to control
         * @param nodeId node id of doc to start worklow on
         * @param onComplete handler to call after worklow is started
         * 
         */
        public function StartWorkflowPresenter(startWorkflowView:StartWorkflowViewBase, repoNode:IRepoNode, onComplete:Function=null)
        {
            super(startWorkflowView);
            
            this.repoNode = repoNode;
            this.onComplete = onComplete;            
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get startWorkflowView():StartWorkflowViewBase
        {
            return this.view as StartWorkflowViewBase;            
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
        }
                
        /**
         * Handle successful start workflow result 
         * 
         * @param info result info
         * 
         */
        protected function onResultStartWorkflow(info:Object):void
        {
            PopUpManager.removePopUp(startWorkflowView);
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
            trace("onFaultStartWorkflow" + info);            
            PopUpManager.removePopUp(startWorkflowView);
        }

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            var workflowType:String = startWorkflowView.workflowTypeCombo.selectedItem.workflowType;
            var assignTo:String = startWorkflowView.assignToTextInput.text;            
            var desc:String = startWorkflowView.descTextArea.text;
            var dueDate:String = startWorkflowView.dueDateField.text;
            var dateFormatted:String = null;
            if (dueDate != "")
            {
                var dateFormatter:DateFormatter = new DateFormatter();
                dateFormatter.formatString = "DD MMMM YYYY";
                dateFormatted = dateFormatter.format(dueDate);
            }

            var responder:Responder = new Responder(onResultStartWorkflow, onFaultStartWorkflow);
            var startWorkflowEvent:StartWorkflowEvent = new StartWorkflowEvent(StartWorkflowEvent.START_WORKFLOW, responder, 
                                                                repoNode, workflowType, assignTo, desc, dateFormatted);
            startWorkflowEvent.dispatch();            
        }
        
    }
}