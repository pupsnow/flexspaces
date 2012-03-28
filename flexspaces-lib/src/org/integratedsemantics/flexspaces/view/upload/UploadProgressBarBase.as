package org.integratedsemantics.flexspaces.view.upload
{
    import mx.controls.ProgressBar;
    
    import spark.components.Label;
    import spark.components.VGroup;


    public class UploadProgressBarBase extends VGroup
    {
        public var progressBar:ProgressBar;
        public var filenameLabel:Label;
        
                        
        public function UploadProgressBarBase()
        {
            super();
        }
        
    }
}