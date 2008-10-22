10/21/08
Steve Reiner
integratedsemantics.org
integratedsemantics.com

Integration of Alfresco Share application into a new tab in FlexSpaces+AIR


Also see 0.6 readme and release notes for webscripts, flexspaces+browser, and regular flexspaces+air

Notes:

1. To get the share tab in FlexSpaces+Air to fully work inside air (Not get "Page Update Failed" on blog and wiki saves, etc.)
you need
1. Alfresco Labs 3.0 C  
(final fix for air in share was on 10/2/08 <install dir>/tomcat/webapps/share/js/alfresco.js )
http://forums.alfresco.com/en/viewtopic.php?f=36&t=14025


2. tab was added after 0.6 flexspaces release (src code for tab in  http://code.google.com/p/flexspaces/ svn)

3. Share login will be skipped using user/pw from flexspaces+air login using the share login servlet call

4. url for share is based on the protocol, host, port from flexspaces+air alfresco-config.xml and assumed
to be at 
<protocol>://<host>:<port>/share/

5. you don't need to type a url into the browser url textfield in the share tab, but if you do note that
you need to type in full url with protocol (for example http://www.google.com not www.google.com) and hit the go button

6. The share tab will only be shown if the alfresco version logged into is 3.0 or greater

7. No support for native drag/drop or native clipboard into the share tab

8. No support for internal copy/paste between Share tab and flex based tabs 
(not in flexspaces+air+share, or with flexspaces site components inside share in browser)


