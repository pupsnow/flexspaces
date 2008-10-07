<?xml version="1.0" encoding="UTF-8"?>
<properties>
   <node>
   <name>${node.name}</name>
   <id>${node.id}</id>
   <path>${node.displayPath}/${node.name}</path>

   <#if node.isContainer>
       <#assign isFolder="true">
       <#assign size="">
       <#assign encoding="">
       <#assign mimetype="">
   <#else>
       <#assign isFolder="false">
       <#assign size=node.size/1024 + " KB">
       <#assign encoding=node.properties.content.encoding!>
       <#assign mimetype=node.properties.content.mimetype!>
   </#if>

   <icon16>${node.icon16}</icon16>
   <icon32>${node.icon32}</icon32>
   <isFolder>${isFolder}</isFolder>
   <title>${node.properties.title!}</title>
   <description>${node.properties.description!}</description>
   <author>${node.properties.author!}</author>
   <size>${size}</size>
   <creator>${node.properties.creator}</creator>
   <created>${node.properties.created?datetime}</created>
   <modifier>${node.properties.modifier}</modifier>
   <modified>${node.properties.modified?datetime}</modified>
   <editinline>${node.properties.editInline!}</editinline>
   <emailid>${emailid}</emailid>
   <encoding>${encoding}</encoding>
   <mimetype>${mimetype}</mimetype>
   </node>   
</properties>
