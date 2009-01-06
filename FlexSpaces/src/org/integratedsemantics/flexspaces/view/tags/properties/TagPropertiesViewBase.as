package org.integratedsemantics.flexspaces.view.tags.properties
{
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.controls.List;
    import mx.controls.TextInput;
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.FormBase;
    import org.integratedsemantics.flexspaces.model.vo.TagVO;
    import org.integratedsemantics.flexspaces.presmodel.tags.properties.TagPropertiesPresModel;


    /**
     * Base class for tags view/edit views  
     * 
     */
    public class TagPropertiesViewBase extends FormBase
    {
        public var tagList:List;
        public var removeTagBtn:Button;        
        
        public var tagName:TextInput;
        public var addNewTagBtn:Button;

        public var allTagsList:List;
        public var addExistingTagBtn:Button;

        [Bindable]
        public var tagPropertiesPresModel:TagPropertiesPresModel;

              
        /**
         * Constructor 
         */
        public function TagPropertiesViewBase()
        {
            super();
        }     
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {            
            if (tagPropertiesPresModel != null)
            {
	            observeButtonClick(addNewTagBtn, onAddNewTagBtn);
	            observeButtonClick(addExistingTagBtn, onAddExistingTagBtn);
	            observeButtonClick(removeTagBtn, onRemoveTagBtn);
	
	            // get tags on node            
	            tagPropertiesPresModel.getNodeTags();
	            
	            // get all tags
	            tagPropertiesPresModel.getAllTags();
            }                  
        }
        
        /**
         * Handle add new tag buttion click
         * 
         * @param click event
         * 
         */
        public function onAddNewTagBtn(event:MouseEvent):void 
        {     
        	tagPropertiesPresModel.addNewTag();
        }

        /**
         * Handle add existing tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddExistingTagBtn(event:MouseEvent):void 
        {           
	        tagPropertiesPresModel.addExistingTag();
        }
        
        /**
         * Handle remove tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveTagBtn(event:MouseEvent):void 
        {            
	        tagPropertiesPresModel.removeTag();
        }
        
        protected function onChangeTagList(event:Event):void
        {
        	if (tagPropertiesPresModel != null)
			{
				tagPropertiesPresModel.selectedNodeTag = tagList.selectedItem as TagVO;				
			}
        }
        
        protected function onChangeAllTagsList(event:Event):void
        {
        	if (tagPropertiesPresModel != null)
			{
				tagPropertiesPresModel.selectedExistingTag = allTagsList.selectedItem as TagVO;     		
			}
        }

        protected function onChangeNewTagText(event:Event):void
        {
        	if (tagPropertiesPresModel != null)
			{
				tagPropertiesPresModel.newTagText = tagName.text;       					
			}
        }
           
    }
}