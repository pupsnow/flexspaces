package org.integratedsemantics.flexspaces.model.repo
{
    /**
     * Interface for a repository node
     * 
     */
    public interface IRepoNode
    {
        function getId():String;
        function setId(id:String):void;
        
        function getName():String;
        function setName(name:String):void;
        
        function getPath():String;
        function setPath(path:String):void;
        
        function getNodeRef():String;
        function setNodeRef(nodeRef:String):void;
        
        function getStoreProtocol():String;
        function setStoreProtocol(storeProtocol:String):void;
        
        function getStoreId():String;
        function setStoreId(storeId:String):void;
        
        function getType():String;
        function setType(type:String):void;
        
        function getIsFolder():Boolean;
        function setIsFolder(isFolder:Boolean):void;
    }
}