4/30/09
Steve Reiner


Additional instructions for using FlexSpaces+Browser, FlexSpaces+Air, webscripts
with Adobe LiveCycle Content Services ES instead of regular Alfresco
(instructions based on livecycle jboss for windows turnkey express install)

Note: currently FlexSpaces as built will run (after config) only on LiveCycle on localhost:8080
To run on a different host:port, you need to have flexspaces+browser or flexspaces+air recompiled (using available
source and flex builder) after changing the 2 urls in services-config.xml in the source


1. Install flexspaces webscripts the same as for regular alfresco  (see readmeWebScripts.txt)
(web scripts home page is different http://localhost:8080/contentspace/service/ )


2. FlexSpacesConfgi.xml needs to be setup differently (see readmeFlexSpacesForBrowser.txt and readmeFlexSpacesForAIR.txt)
with contentspace/service instead of alfresco/service and  livecycle=true, and 2.1 (version of alfresco code embedded in 
livecycle, not livecycle version)

        <property name="alfrescoUrlPart" value="/contentspace/servicee" />

        <property name="isLiveCycleContentServices" value="true"/>

        <property name="serverVersion" value="2.1"/>        


3. Add a <dynamic-url> for contentspace/service to livecycle's services-config.xml  remoting config file
a. stop "JBoss for Adobe LiveCycle ES service in windows services util
b. open C:\Adobe\LiveCycle8.2\jboss\server\all\deploy\adobe-livecycle-jboss.ear (I use 7-zip open archive)
c. open adobe-remoting-provider.war inside it

d. edit adobe-remoting-provider.war\WEB-INF\flex\services-config.xml
e. In  <service id="proxy-service" section within   <destination id="DefaultHTTP"> section add a dynamic-url for content services web scripts
            <destination id="DefaultHTTP">
                <properties>
                    <!-- <dynamic-url>http://{server.name}:*/dev/remote/*</dynamic-url> -->
                    <dynamic-url>http://localhost:8080/contentspace/service/*</dynamic-url>
                </properties>
            </destination>
f. ok save changes to services-config.xml and to adobe-remoting-provider.war
g. restart JBoss for Adobe LiveCycle ES service
h. takes a long time for livecycle  to deploy and restart ( wait for http://localhost:8080/contentspace/index.jsp to work)



4. For optional "Make Flash Preview" / view Preview features
(Note this is optional, only for flash previews. If you  get errors in your alfresco startup console, undo the add of custom-transform-context.xml)

a. Use livecycle-pdf2swf-transform-context.xml instead of openoffice based custom-transform-context.xml
(This uses LiveCycle to generate pdf then uses pdf2swf to then generate swf/flash

b. Install newest development snapshot of swftools (newer than 8.1 release) from www.swftools.org (avail for windows and linux)
for pdf2swf (The development shapshot can generate the needed flash 9 format files, 8.1 swftools can't)

c. Add swftools install dir to system path so pdf2swf can be run

d. Copy the included livecycle-pdf2swf-transform-context.xml config file to content services extension area 
d1. stop "JBoss for Adobe LiveCycle ES service in windows services util
d2. open C:\Adobe\LiveCycle8.2\jboss\server\all\deploy\adobe-contentservices.ear (I use 7-zip open archive)
d3. open contentservices.war inside it
d4. copy into livecycle-pdf2swf-transform-context.xml contentservices.war\WEB-INF\classes\alfresco\extension\
d5. ok save changes to contentservices.war
d6. restart JBoss for Adobe LiveCycle ES service
d7. takes a long time for livecycle to deploy and restart ( wait for http://localhost:8080/contentspace/index.jsp to work)
   

