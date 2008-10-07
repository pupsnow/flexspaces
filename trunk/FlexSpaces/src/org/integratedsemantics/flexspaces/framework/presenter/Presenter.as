package org.integratedsemantics.flexspaces.framework.presenter
{
    import mx.controls.Button;
    import mx.controls.TextInput;
    import mx.core.UIComponent;
    
    import org.integratedsemantics.flexspaces.util.ObserveUtil;


    /**
     * Base Implementation for Presenters 
     *  1. Supervising Presenter/Controller for views with model binding (View)
     *  2. Presenter/Controller for views without model binding (Passive View)  
     * 
     */
    public class Presenter implements IPresenter
    {
        protected var view:Object;
        
        /**
         * Constructor
         *  
         * @param viewComponent view to control
         * 
         */
        public function Presenter(view:Object)
        {
           this.view = view;
        }

        /**
         * Get view under control
         *  
         * @return the view 
         * 
         */
        public function getView():Object
        {
            return view;
        }
        
        /**
         * Set the view under control
         *  
         * @param view the view
         * 
         */
        public function setView(view:Object):void
        {
            this.view = view;
        }

        /**
         * Hook up event listener for a button click
         *  
         * @param button  button to add click listener for
         * @param handler event listener handler to hook up
         * 
         */
        protected function observeButtonClick(button:Button, handler:Function):void
        {
            ObserveUtil.observeButtonClick(button, handler);
        }       

        /**
         * Hook up event listener for a text input field change
         *  
         * @param textInput text input control
         * @param handler event listener handler to hook up
         * 
         */
        protected function observeTextInputChange(textInput:TextInput, handler:Function):void
        {
            ObserveUtil.observeTextInputChange(textInput, handler);
        } 
                
        /**
         * Hook up event listener for creation complete
         *  
         * @param uiComponent  component to observe creation complete on
         * @param handler event listener handler to hook up
         * 
         */
        protected function observeCreation(uiComponent:UIComponent, handler:Function):void
        {
            ObserveUtil.observeCreation(uiComponent, handler);
        }                               
                        
    }
}