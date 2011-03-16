<?xml version="1.0" encoding="UTF-8"?>
<searchResults>
   <totalSize>${totalSize}</totalSize>
   <pageSize>${pageSize}</pageSize>
   <pageNum>${pageNum}</pageNum>
   <query>${query}</query>

<#list results as node>
   <#if node.isContainer>
       <#assign isFolder="true">
       <#assign type="Folder">
       <#assign size="">
       <#assign viewurl="">
       <#assign isLocked = "false">
       <#assign isWorkingCopy = "false">
       <#assign createChildrenPermission = "${ node.hasPermission('CreateChildren')?string('true', 'false') }" >
       <#assign mimetype="">
   <#else>
       <#assign isFolder="false">
       <#assign type="Document">
       <#assign size=node.size/1024 + " KB">
       <#assign viewurl= "${absurl(url.serviceContext)}/api/node/content/${node.nodeRef.storeRef.protocol}/${node.nodeRef.storeRef.identifier}/${node.nodeRef.id}/${node.name?url}" >
       <#assign isLocked = "${ node.isLocked?string('true', 'false') }" >
       <#assign isWorkingCopy = "${ node.hasAspect('cm:workingcopy')?string('true', 'false') }" >
       <#assign createChildrenPermission = "false">
       <#assign mimetype=node.properties.content.mimetype!>
   </#if>

   <node>
      
      <name>${node.name}</name>
      
      <noderef>${node.nodeRef}</noderef>      
      
      <storeProtocol>${node.nodeRef.storeRef.protocol}</storeProtocol>
      <storeId>${node.nodeRef.storeRef.identifier}</storeId>
      <id>${node.id}</id>
      
      <parentPath>${node.displayPath}</parentPath>
      <path>${node.displayPath}/${node.name}</path>
      
      <icon16>${node.icon16}</icon16>
      <icon32>${node.icon32}</icon32>
      <icon64>${node.icon64}</icon64>
      
      <isFolder>${isFolder}</isFolder>
      <type>${type}</type>
      <mimetype>${mimetype}</mimetype>
      
      <desc>${node.properties.description!}</desc>
      
      <size>${size}</size>
      
      <created>${node.properties.created?datetime}</created>
      <modified>${node.properties.modified?datetime}</modified>
      
      <viewurl>${viewurl}</viewurl>
      
      <islocked>${isLocked}</islocked>
      <isWorkingCopy>${isWorkingCopy}</isWorkingCopy>
      
      <readPermission>${ node.hasPermission("Read")?string("true", "false") }</readPermission>      
      <writePermission>${ node.hasPermission("Write")?string("true", "false") }</writePermission>
      <deletePermission>${ node.hasPermission("Delete")?string("true", "false") }</deletePermission>
      <createChildrenPermission>${createChildrenPermission}</createChildrenPermission>
      

   </node>
</#list>

</searchResults>
