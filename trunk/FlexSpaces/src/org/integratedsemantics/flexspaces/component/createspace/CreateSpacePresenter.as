package org.integratedsemantics.flexspaces.component.createspace
{
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.FolderEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;


    /**
     *  Create Space Dialog Presenter which creates a space/folder
     *  
     *  Supervising Presenter/Controller of databoud view CreateSpaceViewBase views 
     * 
     */
    public class CreateSpacePresenter extends DialogPresenter
    {
        protected var parentNode:IRepoNode;
        protected var onComplete:Function;
        
        protected var model : AppModelLocator = AppModelLocator.getInstance();
                
        // space icons     
        private var iconConfig:XMLList =        
          <>
             <icon name="space-icon-default" iconPath="images/icons/space-icon-default.gif" />
             <icon name="space-icon-star" iconPath="images/icons/space-icon-star.gif" />
             <icon name="space-icon-doc" iconPath="images/icons/space-icon-doc.gif" />
             <icon name="space-icon-pen" iconPath="images/icons/space-icon-pen.gif" />
             <icon name="space-icon-cd" iconPath="images/icons/space-icon-cd.gif" />
             <icon name="space-icon-image" iconPath="images/icons/space-icon-image.gif" />
             <icon name="project-icon-blog" iconPath="images/icons/project-icon-blog.gif" />
             <icon name="project-icon-calendar" iconPath="images/icons/project-icon-calendar.gif" />
             <icon name="project-icon-doclibrary" iconPath="images/icons/project-icon-doclibrary.gif" />
             <icon name="project-icon-emailarchive" iconPath="images/icons/project-icon-emailarchive.gif" />
             <icon name="project-icon-forums" iconPath="images/icons/project-icon-forums.gif" />
             <icon name="project-icon-gallery" iconPath="images/icons/project-icon-gallery.gif" />
             <icon name="project-icon-wiki" iconPath="images/icons/project-icon-wiki.gif" />
             <icon name="project" iconPath="images/icons/project.gif" />
          </>;
          //<icon name="forums" iconPath="images/icons/forums.gif" />

        
        /**
         * Constructor
         *  
         * @param createSpaceView view to control
         * @param parentNode parent folder node to create space in
         * @param onComplete handler to call after creating space/folder
         * 
         */
        public function CreateSpacePresenter(createSpaceView:CreateSpaceViewBase, parentNode:IRepoNode, onComplete:Function=null)        
        {
            super(createSpaceView);
            
            this.parentNode = parentNode;
            this.onComplete = onComplete;
            
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            createSpaceView.icons = new ArrayCollection();
            var xmlConfig:XMLListCollection = new XMLListCollection(iconConfig);
            for each (var xmlSpaceIcon:XML in xmlConfig)
            {
                var spaceIcon:SpaceIcon = new SpaceIcon();
                spaceIcon.name = xmlSpaceIcon.@name;
                spaceIcon.iconPath = model.srcPath + xmlSpaceIcon.@iconPath;
                createSpaceView.icons.addItem(spaceIcon);
            }
            
            
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get createSpaceView():CreateSpaceViewBase
        {
            return this.view as CreateSpaceViewBase;            
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
            
            createSpaceView.iconlist.selectedIndex = 0;

            var responder:Responder = new Responder(onResultSpaceTemplates, onFaultSpaceTemplates);
            var folderEvent:FolderEvent = new FolderEvent(FolderEvent.SPACE_TEMPLATES, responder);
            folderEvent.dispatch();
        }
                
        /**
         * Handler called when get space templates successfully completed
         * 
         * @parm data space template data
         */
        protected function onResultSpaceTemplates(data:Object):void
        {
            var result:XML = data as XML;
            
            createSpaceView.templates = new XMLListCollection();
            createSpaceView.templates.source = result.template;
        }

        /**
         * Handle fault from get space templates
         *  
         * @param info fault info
         * 
         */
        protected function onFaultSpaceTemplates(info:Object):void
        {
            trace("onFaultSpaceTemplates" + info);            
        }

        /**
         * Handler called when create space server call successfully completed
         * 
         * @info info result info
         */
        protected function onResultCreateSpace(info:Object):void
        {
            // notify repo browser to update the tree
            var parentPath:String = parentNode.getPath();
            var path:String = parentPath + "/" + createSpaceView.foldername.text;
            var addedFolderEvent:AddedFolderEvent = new AddedFolderEvent(AddedFolderEvent.ADDED_FOLDER, parentPath, path);
            createSpaceView.parentApplication.dispatchEvent(addedFolderEvent);            

            PopUpManager.removePopUp(createSpaceView);                        
            
            if (onComplete != null)
            {
                onComplete();
            }
        }
        
        /**
         * Handle fault from create space server call
         *  
         * @param info
         * 
         */
        protected function onFaultCreateSpace(info:Object):void
        {
            trace("onFaultCreateSpace" + info);
            PopUpManager.removePopUp(createSpaceView);
        }

        /**
         * Handle ok buttion click by requesting create space server operation
         * 
         * @param click event
         * 
         */
        override protected function onOkBtn(event:MouseEvent):void 
        {
            var responder:Responder = new Responder(onResultCreateSpace, onFaultCreateSpace);
            var templateNode:IRepoNode = new RepoNode();
            templateNode.setId(createSpaceView.templatecombo.selectedItem.id);
            var folderEvent:FolderEvent = new FolderEvent(FolderEvent.CREATE_SPACE, responder, parentNode, createSpaceView.foldername.text, 
                                                          createSpaceView.nodetitle.text, createSpaceView.description.text, 
                                                          templateNode, createSpaceView.iconlist.selectedItem.name);
            folderEvent.dispatch();                     
        }
        
    }
}
