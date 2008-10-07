package org.integratedsemantics.flexspacesair.component.create.text
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;


    /**
     *  Create Text Content dialog presenter
     *  
     *  Presenter/Controller of CreateTextViewBase views
     * 
     */
    public class CreateTextPresenter extends DialogPresenter
    {
        protected var onComplete:Function;

        
        /**
         * Constructor
         *  
         * @param createTextView view to control
         * @param onComplete handler to continue process after UI
         * 
         */
        public function CreateTextPresenter(createTextView:CreateTextViewBase, onComplete:Function)
        {
            super(createTextView);
            
            this.onComplete = onComplete;
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get createTextView():CreateTextViewBase
        {
            return this.view as CreateTextViewBase;            
        }       

        /**
         * Handle view creation complete
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
        }                

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            PopUpManager.removePopUp(createTextView);

            this.onComplete(createTextView.nodename.text, createTextView.textarea.text);                
        }
        
    }
}