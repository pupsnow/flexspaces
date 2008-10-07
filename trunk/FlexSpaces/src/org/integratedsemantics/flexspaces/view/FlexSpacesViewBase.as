package org.integratedsemantics.flexspaces.view
{
    import flexlib.containers.DockableToolBar;
    import flexlib.containers.Docker;
    import flexlib.containers.SuperTabNavigator;
    
    import mx.containers.Box;
    import mx.containers.HBox;
    import mx.containers.VBox;
    import mx.containers.VDividedBox;
    import mx.containers.ViewStack;
    import mx.controls.Button;
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.component.browser.RepoBrowserViewBase;
    import org.integratedsemantics.flexspaces.component.login.LoginViewBase;
    import org.integratedsemantics.flexspaces.component.logout.LogoutViewBase;
    import org.integratedsemantics.flexspaces.component.menu.menubar.ConfigurableMenuBar;
    import org.integratedsemantics.flexspaces.component.search.basic.SearchViewBase;
    import org.integratedsemantics.flexspaces.component.search.searchpanel.SearchPanelBase;
    import org.integratedsemantics.flexspaces.component.tasks.taskspanel.TasksPanelViewBase;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.view.event.LoginViewCreatedEvent;
    import org.integratedsemantics.flexspaces.view.event.RepoBrowserCreatedEvent;


    /**
     * Base view class for flexspaces view 
     * 
     */
    public class FlexSpacesViewBase extends VDividedBox
    {
        public var flexspacesviews:VBox;
        
        public var loginPage:VBox;
        public var header:HBox;
        
        public var searchView:SearchViewBase;
        public var logoutView:LogoutViewBase;
        
        public var mainMenu:ConfigurableMenuBar;
        
        public var viewStack:ViewStack;
        
        public var loginPanel:Box;
        public var loginView:LoginViewBase;
        
        public var tabNav:SuperTabNavigator;
        
        public var browserTab:VBox;
        public var browserView:RepoBrowserViewBase;
        
        public var searchTab:VBox;
        public var searchPanel:SearchPanelBase;
        
        public var tasksTab:VBox;
        public var tasksPanelView:TasksPanelViewBase;
        
        public var wcmTab:VBox;
        public var wcmBrowserView:RepoBrowserViewBase;
        
        public var docker:Docker;
        public var menuToolbar:DockableToolBar;
        public var toolbar1:DockableToolBar;
        
        public var cutBtn:Button;
        public var copyBtn:Button;
        public var pasteBtn:Button;
        public var deleteBtn:Button;
        public var createSpaceBtn:Button;
        public var uploadFileBtn:Button;
        public var tagsBtn:Button;
                
        [Bindable] protected var model : AppModelLocator = AppModelLocator.getInstance();
        
                
        /**
         * Constructor 
         * 
         */
        public function FlexSpacesViewBase()
        {
            super();
        }
        
        /**
         * Handle create complete on repo browser by sending event 
         * letting rest of UI know its created
         *  
         * @param event create complete view
         * 
         */
        protected function onRepoBrowserCreated(event:FlexEvent):void
        {
            var repoBrowserCreatedEvent:RepoBrowserCreatedEvent = new RepoBrowserCreatedEvent();
            var dispatched:Boolean = dispatchEvent(repoBrowserCreatedEvent);    
        }
        
        /**
         * Handle create complete login view by sending event 
         * letting rest of UI know its created
         *  
         * @param event create complete view
         * 
         */
        protected function onLoginViewCreated(event:FlexEvent):void
        {
            var loginViewCreatedEvent:LoginViewCreatedEvent = new LoginViewCreatedEvent();
            var dispatched:Boolean = dispatchEvent(loginViewCreatedEvent);    
        }

    }
}