package org.integratedsemantics.flexspaces.presmodel.createspace
{
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.FolderEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.vo.TemplateVO;


    /**
     *  Presentation model for create space/folder dialogs
     *  
     */
    [Bindable] 
    public class CreateSpacePresModel extends PresModel
    {
        public var parentNode:IRepoNode;
        
        public var templates:ArrayCollection;  
        
        public var icons:ArrayCollection;

        public var folderName:String = "";
        public var title:String = "";
        public var description:String = "";
		
		public var selectedTemplateItem:TemplateVO;
		
		public var selectedIcon:Object;

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
         * @param parentNode parent folder node to create space in
         * 
         */
        public function CreateSpacePresModel(parentNode:IRepoNode)        
        {
            super();
            
            this.parentNode = parentNode;
            
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            icons = new ArrayCollection();
            var xmlConfig:XMLListCollection = new XMLListCollection(iconConfig);
            for each (var xmlSpaceIcon:XML in xmlConfig)
            {
                var spaceIcon:SpaceIcon = new SpaceIcon();
                spaceIcon.name = xmlSpaceIcon.@name;
                spaceIcon.iconPath = model.appConfig.srcPath + xmlSpaceIcon.@iconPath;
                icons.addItem(spaceIcon);
            }
        }
        
        /**
         * Get space templates
         * 
         */
        public function getSpaceTemplates():void
        {
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
            var result:ArrayCollection = data as ArrayCollection;            
            templates = result;
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
         * Request create space server operation
         * 
         */
        public function createSpace(responder:Responder):void 
        {
            var templateNode:IRepoNode = new RepoNode();
            // cmis no templates
            if (selectedTemplateItem != null)
            {
                templateNode.setId(selectedTemplateItem.id);
            }
            var folderEvent:FolderEvent = new FolderEvent(FolderEvent.CREATE_SPACE, responder, parentNode, folderName, 
                                                          title, description, templateNode, selectedIcon.name);
            folderEvent.dispatch();                     
        }
        
        public function updateFolderName(newName:String):void
        {
        	this.folderName = newName;	
        }

        public function updateTitle(newTitle:String):void
        {
        	this.title = newTitle;	
        }

        public function updateDescription(newDesc:String):void
        {
        	this.description = newDesc;	
        }

        public function changeSelectedTemplate(item:Object):void
        {
        	this.selectedTemplateItem = item as TemplateVO;	
        }

        public function changeSelectedIcon(icon:Object):void
        {
        	this.selectedIcon = icon;	
        }
        
    }
}
