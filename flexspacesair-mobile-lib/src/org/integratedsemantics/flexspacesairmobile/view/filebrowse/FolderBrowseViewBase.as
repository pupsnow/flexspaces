package org.integratedsemantics.flexspacesairmobile.view.filebrowse
{
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    
    import mx.collections.ArrayCollection;
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    
    import spark.components.Label;
    import spark.components.List;


    public class FolderBrowseViewBase extends DialogViewBase
    {                
        public var onComplete:Function;

        public var fileList:List;
        public var dirLabel:Label;

        [Bindable] protected var currentDirectory:File;
        [Bindable] protected var files:ArrayCollection;
        

        private var selectedFolder:File;
        
        
        /**
         * Constructor
         * 
         * @param onComplete handler to call after done
         * 
         */
        public function FolderBrowseViewBase()
        {
            super();       
        }        
        
        /**
         * Handle view creation complete by requesting space template data
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            init();            
        }

        /**
         * Handle ok buttion click
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            finish();    
        }
                        
        private function init():void
        { 
            changeDir (File.documentsDirectory);
        }
        
        private function changeDir(file:File):void
        {
            if (file.isDirectory)
            {
                var parent:File = file.parent;
                
                currentDirectory = file;
                
                files = new ArrayCollection( currentDirectory.getDirectoryListing().sort(fileSort) );
                
                dirLabel.text = currentDirectory.nativePath;
            }
        }
        
        private function fileSort(file1:File, file2:File):int
        {
            if (file1.isDirectory && !file2.isDirectory)
                return -1;
            else if (!file1.isDirectory && file2.isDirectory)
                return 1; 
            else
                return file1.name.localeCompare( file2.name );
        }
        
        protected function doubleClick():void
        {
            if (fileList.selectedItem != null)
            {                
                var selectedFile:File = fileList.selectedItem as File;
                
                if (selectedFile.isDirectory)
                {
                    changeDir(selectedFile);
                }
            }            
        }
        
        private function finish():void
        {
            selectedFolder = this.currentDirectory;

            PopUpManager.removePopUp(this);                        
                
            if (onComplete != null)
            {
                onComplete(selectedFolder);
            }
        }
        
        protected function up():void
        {
            changeDir (currentDirectory.parent);
        } 

        
        protected function rendererFunction(item:*):IFactory
        {
            if (item.isDirectory)
                return new ClassFactory(FolderItemRenderer);
            else
                return new ClassFactory(FileItemRenderer);
        }        
                
    }
}