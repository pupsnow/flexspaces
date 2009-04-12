package org.integratedsemantics.flexspaces.model.folder
{
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;

    
    /**
     * Document or folder node model used in node collection model
     *  
     */
    [Bindable]
    public class Node extends RepoNode
    {        
        public var icon16:String;
        public var icon32:String;
        public var icon64:String;
        
        public var desc:String;
        public var size:String;
        
        public var created:String;
        public var modified:String;
        
        public var viewurl:String; 
        public var displayPath:String; 

        public var isLocked:Boolean; 
        public var isWorkingCopy:Boolean;
        
        public var thumbnailUrl:String;               

        public var showThumbnail:Boolean = false;
  
        public var mimetype:String;
        
        // cmis
        public var cmisChildren:String;
        public var cmisSelf:String;
        public var cmisObj:Object;
        public var cmisAllVersions:String;
        public var cmisType:String;
              
        
        /**
         * Constructor 
         */
        public function Node()
        {
            super();
        }
        
    }
}