package org.integratedsemantics.flexspaces.component.playvideo
{
    import flash.events.Event;
    
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;


    /**
     * Displays view for playing video
     * 
     *  Presenter/Controller of passive PlayVideoViewBase views 
     */      
    public class PlayVideoPresenter extends Presenter
    {
        protected var repoNode:Node;
                    

        /**
         * Constructor
         *  
         * @param playVideoView view being controlled
         * @param repoNode  doc node to play
         * 
         */
        public function PlayVideoPresenter(playVideoView:PlayVideoViewBase, repoNode:Node)
        {
            super(playVideoView);
            
            this.repoNode = repoNode;
            
            if (playVideoView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(playVideoView, onCreationComplete);            
            }            
        }
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get playVideoView():PlayVideoViewBase
        {
            return this.view as PlayVideoViewBase;            
        }       

        /**
         * Handle initialization after view has its creation complete
         *  
         * @param event create complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            var model:AppModelLocator = AppModelLocator.getInstance();
            if (model.isLiveCycleContentServices == true)
			{
                var url:String = repoNode.viewurl;				
			}   
			else
			{         
                url = repoNode.viewurl + "?alf_ticket=" + model.loginTicket;
            }            
            playVideoView.videoDisplay.source = url;    
        }                 
                                                   
    }        
}