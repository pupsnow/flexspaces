package org.integratedsemantics.flexspaces.component.search.advanced
{
        
    import mx.collections.ArrayCollection;
    import mx.controls.Button;
    import mx.controls.CheckBox;
    import mx.controls.ComboBox;
    import mx.controls.DateField;
    import mx.controls.List;
    import mx.controls.TextInput;
    
    import org.integratedsemantics.flexspaces.component.categories.tree.CategoryTreeViewBase;
    import org.integratedsemantics.flexspaces.component.tree.TreeViewBase;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;

    /**
     * Base class for advanced search views  
     * 
     */
    public class AdvancedSearchViewBase extends DialogViewBase
    {
        public var searchText:TextInput;
        public var resultsForCombo:ComboBox;        
        public var locationCombo:ComboBox;        
        
        public var treeView:TreeViewBase;
        public var includeChildSpacesCheckbox:CheckBox;
        
        public var folderTypeCombo:ComboBox;        
        public var contentTypeCombo:ComboBox;        
        public var formatCombo:ComboBox;        
        
        [Bindable] public var categories:ArrayCollection;
        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        public var addExistingCategoryBtn:Button;        
        public var categoriesTreeView:CategoryTreeViewBase;
        public var includeSubCategoriesCheckbox:CheckBox;

        public var titleText:TextInput;
        public var descriptionText:TextInput;
        public var authorText:TextInput;
        
        public var modifiedDateCheckBox:CheckBox;
        public var modifiedFromDate:DateField;
        public var modifiedToDate:DateField;

        public var createdDateCheckBox:CheckBox;
        public var createdFromDate:DateField;
        public var createdToDate:DateField;
        
        
        /**
         * Constructor 
         */
        public function AdvancedSearchViewBase()
        {
            super();
        }        
    }
}