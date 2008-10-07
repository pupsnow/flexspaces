package org.integratedsemantics.flexspacesair.util
{
    import flash.html.HTMLLoader;
    import flash.html.HTMLPDFCapability;
    
    /**
     * Utility functions related to Webkit (html browser in AIR)
     * such as supported formats, etc.
     * 
     */
    public class WebkitUtil
    {        
        /**
         * Can WebKit view format (AIR builtin web browser)
         *   
         * @param ext flex/air platform independent file extension
         * @return true if format can be viewed with webkit
         * 
         * TODO: have this configurable in external xml file
         */
        public static function isWebKitViewableFormat(ext:String):Boolean
        {
            var isWebKitViewable:Boolean=false; 
            switch (ext)
            {
                case "pdf":
                    if (HTMLLoader.pdfCapability == HTMLPDFCapability.STATUS_OK)
                    {
                        isWebKitViewable = true;
                    }
                    break;
                case "htm":
                case "html":
                case "xhtml":
                case "css":
                case "xml":
                case "xsl":
                case "xsd":
                case "swf":
                case "mp3":
                case "mpeg":
                case "mp4":
                case "gif":
                case "png":
                case "img":
                case "txt":
                case "properties":
                case "as":
                //case "js":
                //case "ftl":
                case "java":
                case "jsp":
                    isWebKitViewable = true;
                    break;
                default:
                    break;
            }
            return isWebKitViewable;
        }        
        
    }
}