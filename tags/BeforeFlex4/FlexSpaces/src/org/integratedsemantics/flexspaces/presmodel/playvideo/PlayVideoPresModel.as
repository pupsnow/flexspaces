package org.integratedsemantics.flexspaces.presmodel.playvideo
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;


    /**
     * Presentation model for for playing video views
     * 
     */  
    [Bindable]     
    public class PlayVideoPresModel extends PresModel
    {
        public var repoNode:Node;
        public var url:String = "";
                    
        /**
         * Constructor
         *  
         * @param playVideoView view being controlled
         * @param repoNode  doc node to play
         * 
         */
        public function PlayVideoPresModel(repoNode:Node)
        {
            super();
            
            this.repoNode = repoNode;
            
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            // livecycle and cmis both no ticket, basic auth
            if (model.appConfig.cmisMode == true)
            {
                url = repoNode.viewurl;
            }  
            else if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                url = repoNode.viewurl + "?ticket=" + model.userInfo.loginTicket;                
            } 
            else
            {         
                url = repoNode.viewurl + "?alf_ticket=" + model.userInfo.loginTicket;
            }                                    
        }
        
    }        
}