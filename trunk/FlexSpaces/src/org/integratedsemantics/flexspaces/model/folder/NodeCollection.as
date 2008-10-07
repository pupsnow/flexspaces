package org.integratedsemantics.flexspaces.model.folder
{
    import mx.collections.ArrayCollection;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;    

    
    /**
     * Collection of nodes, model for node list views
     * 
     */
    [Bindable] 
    public class NodeCollection extends ArrayCollection
    {              
       // nodes
       protected var nodeCollection:ArrayCollection;         

        /**
         * Constructor
         * 
         */
        public function NodeCollection()
        {
            super();
        }
        
        /**
         * Gets webscript url for node thumbnail
         *  
         * @param node node to get thumbnail url for
         * @return  thumbnail webscript url
         * 
         */
        protected function getThumbnailUrl(node:Node):String
        {
            // 3.0 only
            var model:AppModelLocator = AppModelLocator.getInstance();
            var url:String = model.urlPrefix + "/api/node/" + node.storeProtocol + "/" + node.storeId + "/" + node.id;
            url += "/content/thumbnails/" + model.thumbnailName + "?qc=true&ph=true" + "&alf_ticket=" + model.loginTicket;
            return url;
        }
                                       
    }
}
