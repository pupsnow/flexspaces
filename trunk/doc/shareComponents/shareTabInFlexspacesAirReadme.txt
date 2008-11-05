11/04/08
Steve Reiner
integratedsemantics.org
integratedsemantics.com

Integration of Alfresco Share application into a new tab in FlexSpaces+AIR

FlexSpacesAir 0.7 has added browser tab running Share (can also be used for running other web page)
Previously this feature was a separate experimental download
(note: for blog/wiki saving  needs share in air final fix in alfreso 3.0 enterprise
or labs 3.0 with checkin from from 10/2/08, in alfresco labs 3c)

Also see 0.7 readme and release notes for webscripts, flexspaces+browser, and regular flexspaces+air

Notes:

1. To get the share tab in FlexSpaces+Air to fully work inside air (Not get "Page Update Failed" on blog and wiki saves, etc.)
you need
a. Alfresco 3.0 Enterprise
b. Alfresco Labs 3.0 C  
(final fix for air in share was on 10/2/08 <install dir>/tomcat/webapps/share/js/alfresco.js )
http://forums.alfresco.com/en/viewtopic.php?f=36&t=14025


2. Share login will be skipped using user/pw from flexspaces+air login using the share login servlet call

3. url for share is based on the protocol, host, port from flexspaces+air alfresco-config.xml and assumed
to be at 
<protocol>://<host>:<port>/share/

4. you don't need to type a url into the browser url textfield in the share tab, but if you do note that
you need to type in full url with protocol (for example http://www.google.com not www.google.com) and hit the go button

5. The share tab will only be shown if the alfresco version logged into is 3.0 or greater

6. No support for native drag/drop or native clipboard into the share tab

7. No support for internal copy/paste between Share tab and flex based tabs 
(not in flexspaces+air+share, or with flexspaces site components inside share in browser)


