package org.integratedsemantics.flexspacesairmobile.view.filebrowse
{
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    
    import mx.collections.ArrayCollection;
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    import mx.events.FlexEvent;
    import mx.managers.CursorManager;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    
    import spark.components.Label;
    import spark.components.List;


    public class FileBrowseViewBase extends DialogViewBase
    {                
        public var onComplete:Function;

        public var fileList:List;
        public var dirLabel:Label;

        [Bindable] protected var currentDirectory:File;
        [Bindable] protected var files:ArrayCollection;
        

        private var selectedFiles:Vector.<File>;
        
        
        /**
         * Constructor
         * 
         * @param onComplete handler to call after done
         * 
         */
        public function FileBrowseViewBase()
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
                else
                { 
                    finish();
                }
            }            
        }
        
        private function finish():void
        {
            if (fileList.selectedItems != null)
            {                
                var selectedItems:Vector.<Object> = fileList.selectedItems;

                selectedFiles = new Vector.<File>();
                for (var i:uint = 0; i < selectedItems.length; i++) 
                {
                    var file:File = selectedItems[i] as File;
                    if (file.isDirectory == false)
                    {
                        selectedFiles.push(file);
                    }
                }                                
                
                if (selectedFiles.length > 0)
                {    
                    PopUpManager.removePopUp(this);                        
                    
                    if (onComplete != null)
                    {
                        onComplete(selectedFiles);
                    }
                }
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
                return new ClassFactory(CheckableFileItemRenderer);
        }        
                
    }
}