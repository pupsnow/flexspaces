package org.integratedsemantics.flexspacesair.component.create.xml
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;


    /**
     *  Create XML Content dialog presenter
     *  
     *  Presenter/Controller of CreateXmlViewBase views 
     * 
     */
    public class CreateXmlPresenter extends DialogPresenter
    {
        protected var onComplete:Function;

        
        /**
         * Constructor
         *  
         * @param createXmlView view to control
         * @param onComplete handler to continue process after UI
         * 
         */
        public function CreateXmlPresenter(createXmlView:CreateXmlViewBase, onComplete:Function)
        {
            super(createXmlView);
            
            this.onComplete = onComplete;
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get createXmlView():CreateXmlViewBase
        {
            return this.view as CreateXmlViewBase;            
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
            PopUpManager.removePopUp(createXmlView);

            this.onComplete(createXmlView.nodename.text, createXmlView.textarea.text);                
        }
        
    }
}