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
       public var nodeCollection:ArrayCollection;     
       
       // if using server side paging
       public var totalSize:int = 0;
       public var pageSize:int = 10;
       public var pageNum:int = 0;    

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
        public function getThumbnailUrl(node:Node):String
        {
            // 3.0 only
            var model:AppModelLocator = AppModelLocator.getInstance();
            var url:String = model.ecmServerConfig.urlPrefix + "/api/node/" + node.storeProtocol + "/" + node.storeId + "/" + node.id;
            url += "/content/thumbnails/" + model.thumbnailConfig.thumbnailName + "?qc=true&ph=true" + "&alf_ticket=" + model.userInfo.loginTicket;
            return url;
        }
                                       
    }
}
