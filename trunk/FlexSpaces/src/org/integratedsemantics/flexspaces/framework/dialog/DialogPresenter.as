package org.integratedsemantics.flexspaces.framework.dialog
{
    import flash.events.MouseEvent;
    
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
        
    
    /**
     *  Base Presenter functionality for dialogs
     *  
     *  Presenter/Controller for DialogViewBase views
     * 
     */
    public class DialogPresenter extends Presenter
    {
        /**
         * Constructor  
         * 
         * @param dialogView dialog view
         * 
         */
        public function DialogPresenter(dialogView:DialogViewBase)
        {
            super(dialogView);
             
            observeCreation(dialogView, onCreationComplete);
            
            dialogView.addEventListener(CloseEvent.CLOSE, onXCloseBtn);
        }
        
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get dialogView():DialogViewBase
        {
            return this.view as DialogViewBase;            
        }       

        /**
         * Handle view creation complete
         * 
         * @param creation complete event 
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            PopUpManager.centerPopUp(dialogView);
            
            if (dialogView.okBtn != null)
            {
                observeButtonClick(dialogView.okBtn, onOkBtn);
            }
            
            if (dialogView.cancelBtn != null)
            {
                observeButtonClick(dialogView.cancelBtn, onCancelBtn);
            }                                    

            if (dialogView.closeBtn != null)
            {
                observeButtonClick(dialogView.closeBtn, onCloseBtn);
            }                                    
        }    

        /**
         * Handle dialog window close button click
         * (for X button in upper right of window)
         * 
         * @param close event
         * 
         */
        protected function onXCloseBtn(event:CloseEvent):void 
        {
            PopUpManager.removePopUp(dialogView);
        }
        
        /**
         * Handle close buttion click
         * (for close button on in dialog not for X button)
         * 
         * @param click event
         * 
         */
        protected function onCloseBtn(event:MouseEvent):void 
        {
            // place holder to allow event listen hookup    
        }

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        protected function onOkBtn(event:MouseEvent):void 
        {
            // place holder to allow event listen hookup    
        }
        
        /**
         * Handle cancel button click
         * 
         * @param event click event
         * 
         */
        protected function onCancelBtn(event:MouseEvent):void
        {
            PopUpManager.removePopUp(dialogView);            
        }                       

    }
}