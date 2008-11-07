<#import "../alfresco/import/alfresco-template.ftl" as template />
<@template.header>
   <style type="text/css">
      .flexspaces
      {
         height: 100%;
         width:  100%;
      }
   </style>
</@>

<@template.body>
   <div id="hd">
      <@region id="header" scope="global" protected=true />
      <@region id="title" scope="template" protected=true />
      <@region id="navigation" scope="template" protected=true />
   </div>
   <div id="bd" class="flexspaces">
      <@region id="flex" class="flexspaces" scope="template" protected=true />
   </div>
   <p>&nbsp;</p>
   <p>&nbsp;</p>
</@>

<@template.footer>
   <div id="ft">
      <@region id="footer" scope="global" protected=true />
   </div>
</@>