package org.integratedsemantics.flexspaces.framework.presenter
{
    /**
     * Interface for Presenters 
     *  1. Supervising Presenter/Controller for views with model binding (View)
     *  2. Presenter/Controller for views without model binding (Passive View)  
     * 
     */
    public interface IPresenter
    {
        /**
         * Get the view under control
         *  
         * @return the view 
         * 
         */
        function getView():Object;
        
        /**
         * Set the view under control
         *  
         * @param view the view
         * 
         */
        function setView(view:Object):void;
    }
}