package org.integratedsemantics.flexspaces.presmodel.upload
{
    import mx.formatters.NumberFormatter;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;


    /**
     * Presentation model for view that provides status on multiple file uploads with multiple progress bars
     * 
     */
    [Bindable] 
    public class UploadStatusPresModel extends PresModel
    {
        public var fileReferences:Array;
        
        /**
         * Constructor
         *  
         * @param fileRefList files being uploaded
         */
        public function UploadStatusPresModel(fileReferences:Array)
        {
            super();
            
            this.fileReferences = fileReferences;                 
        }
                        
        /**
         * Convert bytes to kb display number
         *  
         * @param bytes number in bytes
         * @return number in kilobytes with kb label
         * 
         */
        public function bytesToKiloBytesDisplay(bytes:Number):String 
        {
            var display:String;
            
            if (bytes < 1024)
            {
                display = bytes + " bytes";    
            }
            else if (bytes < 1048576)
            { 
                var formatter:NumberFormatter = new NumberFormatter();
                formatter.precision = 1;
                display = formatter.format(bytes / 1024) + ' KB';
            }
            else
            {
                formatter = new NumberFormatter();
                formatter.precision = 2;
                display = formatter.format(bytes / 1048576) + ' MB';                
            }
            
            return display;
        }
                
    }
}