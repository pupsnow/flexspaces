package org.integratedsemantics.flexspacesair.util
{
    import flash.filesystem.File;
    

    /**
     * 
     * Utilities for Air Offline Files support
     * 
     */
    public class AirOfflineUtil
    {
        
        /**
         * Make a folder path in flexspaces area in documents folder
         * mirroring the repository path passed in
         *  
         * @param folder path relative to flexspaces offline docs folder
         * @return File for folder made (or existing)
         * 
         */
        public static function makeOfflineDirForPath(path:String):File  
        {
            // create FlexSpaces dir in user Documents dir if doesn't already exist
            var flexspacesDocDir:File = File.documentsDirectory.resolvePath("FlexSpaces");
            flexspacesDocDir.createDirectory();
            
            // create dir within Documents / FlexSpaces dir for mirroring repo path
            // if it doesn't already exist
            var pathDir:File = flexspacesDocDir.resolvePath(path.substr(1));
            pathDir.createDirectory();
            
            return pathDir; 
        }         

        /**
         * Get the offline folder path relative to flexspaces offline docs folder 
         * for a repository node
         * 
         * @param node node
         * @return relative path
         * 
         */
        public static function offlineFolderPathForNode(node:Object, wcmMode:Boolean):String
        {        
            if (wcmMode == false)
            {
                var offlinePath:String = node.parentPath;
            }
            else
            {
                offlinePath = "/AVM/" + node.storeId + node.parentPath;                 
            }
            return offlinePath
        }
        
    }
}