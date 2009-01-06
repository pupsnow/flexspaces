package org.integratedsemantics.flexspaces.model.repo
{
    /**
     * Repository Node Model
     * 
     */
    [Bindable]
    public class RepoNode extends Object implements IRepoNode 
    {
        public var name:String;

        public var nodeRef:String;

        public var storeProtocol:String;
        public var storeId:String;
        public var id:String;

        public var parentPath:String;     
        public var path:String;
        public var qnamePath:String;
        
        public var type:String;
        public var isFolder:Boolean;

        public var readPermission:Boolean;
        public var writePermission:Boolean;
        public var deletePermission:Boolean;
        public var createChildrenPermission:Boolean;
        
        public var versionLabel:String;
        public var creator:String;

		public var createdDate:String;
		
		
        public function RepoNode()
        {
        }
        
        public function getId():String
        {
            return this.id;
        }        

        public function setId(id:String):void
        {
            this.id = id;
        }
        
        public function getName():String
        {
            return this.name;
        }
        
        public function setName(name:String):void
        {
            this.name = name;
        }
        
        public function getPath():String
        {
            return this.path;
        }
        
        public function setPath(path:String):void
        {
            this.path = path;
        }
        
        public function getNodeRef():String
        {
            return this.nodeRef;
        }
        
        public function setNodeRef(nodeRef:String):void
        {
            this.nodeRef = nodeRef;
        }
        
        public function getStoreProtocol():String
        {
            return this.storeProtocol;    
        }
        
        public function setStoreProtocol(storeProtocol:String):void
        {
            this.storeProtocol = storeProtocol;
        }
        
        public function getStoreId():String
        {
            return this.storeId;
        }
        
        public function setStoreId(storeId:String):void
        {
            this.storeId = storeId;
        }
        
        public function getType():String
        {
            return this.type;
        }
        
        public function setType(type:String):void
        {
            this.type = type;
        }
        
        public function getIsFolder():Boolean
        {
            return this.isFolder;
        }
        
        public function setIsFolder(isFolder:Boolean):void
        {
            this.isFolder = isFolder;    
        }

    }
}