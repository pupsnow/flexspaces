package org.integratedsemantics.flexspaces.component.search.searchpanel
{
    import mx.containers.HDividedBox;
    
    import org.integratedsemantics.flexspaces.component.categories.tree.CategoryTreeViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.search.basic.SearchViewBase;
    import org.integratedsemantics.flexspaces.component.tags.tagcloud.TagCloudViewBase;

    public class SearchPanelBase extends HDividedBox
    {
        public var searchView2:SearchViewBase;
        public var tagCloudView:TagCloudViewBase;
        public var categoriesTreeView:CategoryTreeViewBase;
        public var searchResultsView:FolderViewBase;
        
        public function SearchPanelBase()
        {
            super();
        }
                
    }
}