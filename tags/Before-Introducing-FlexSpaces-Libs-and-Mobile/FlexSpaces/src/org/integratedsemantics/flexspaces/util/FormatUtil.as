package org.integratedsemantics.flexspaces.util
{
    import flash.net.FileReference;

    
    /**
     * File Format and extension utility functions 
     * 
     */
    public class FormatUtil
    {

        /**
         * Get the mimetype for the given flex platform independent extension
         *  
         * @param file file reference with extension
         * @return  mimetype string
         * 
         * TODO: need to put into external config file or lookup from server
         */
        public static function getMimeType(file:FileReference):String
        {
            var name:String = file.name;
            var index:int = name.lastIndexOf(".");
            var mimetype:String = "text/plain";
            if (index != -1 && (name.length - 1 > index))
            {
                var ext:String = file.name.substring(index+1);
                switch (ext)
                {
                    case "doc":
                    case "docx":
                        mimetype = "application/msword";
                        break;
                    case "xls":
                    case "xlsx":
                        mimetype = "application/excel";
                        break;
                    case "ppt":
                    case "pptx":
                        mimetype = "application/powerpoint";
                        break;
                   case "pdf":
                        mimetype = "application/pdf";
                        break;
                   case "rtf":
                        mimetype = "application/rtf";
                        break;
                    case "htm":
                    case "html":
                        mimetype = "text/html";
                        break;
                    case "css":
                        mimetype = "text/css";
                        break;
                    case "xml":
                        mimetype = "text/xml";
                        break;
                    case "swf":
                        mimetype = "application/x-shockwave-flash";
                        break;
                    case "mp3":
                        mimetype = "audio/mpeg3";
                        break;
                    case "gif":
                        mimetype = "image/gif";
                        break;
                    case "png":
                        mimetype = "image/png";
                        break;
                    case "jpg":
                        mimetype = "image/jpeg";
                        break;                    
                    default:
                        break;
                } 
            }
            return mimetype;
        }    
                        
    }
}