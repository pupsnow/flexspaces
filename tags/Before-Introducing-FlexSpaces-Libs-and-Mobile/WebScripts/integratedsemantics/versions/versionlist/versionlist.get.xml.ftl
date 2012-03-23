<?xml version="1.0" encoding="UTF-8"?>
<versionlist>

<#if hasAspect(node, "cm:versionable") == 1 && node.properties.versionLabel?exists>
<#list node.versionHistory?sort_by("versionLabel") as c>
   
   <#assign isFolder="false">
   <#assign type="Document">
   <#assign size=c.size/1024 + " KB">
   <#assign viewurl= "${absurl(url.serviceContext)}/api/node/content/${c.nodeRef.storeRef.protocol}/${c.nodeRef.storeRef.identifier}/${c.nodeRef.id}/${c.name?url}" >
   <#assign isLocked = "false" >
   <#assign isWorkingCopy = "false" >
   <#assign readPermission = "${ node.hasPermission('Read')?string('true', 'false') }">
   <#assign writePermission = "${ node.hasPermission('Write')?string('true', 'false') }">
   <#assign deletePermission = "${ node.hasPermission('Delete')?string('true', 'false') }">
   <#assign createChildrenPermission = "false">

   <node>

      <name>${c.name}</name>      

      <noderef>${c.nodeRef}</noderef>
      
      <storeProtocol>${c.nodeRef.storeRef.protocol}</storeProtocol>
      <storeId>${c.nodeRef.storeRef.identifier}</storeId>
      <id>${c.id}</id>      

      <versionLabel>${c.versionLabel}</versionLabel>
      <creator>${c.creator}</creator>

      <parentPath>${c.displayPath}</parentPath>
      <path>${c.displayPath}/${c.name}</path>

      <icon16>${c.icon16}</icon16>
      <icon32>${c.icon32}</icon32>
      <icon64>${c.icon64}</icon64>

      <isFolder>${isFolder}</isFolder>
      <type>${type}</type>

      <desc>${c.properties.description!}</desc>

      <size>${size}</size>

      <created>${c.properties.created?datetime}</created>
      <modified>${c.properties.modified?datetime}</modified>

      <viewurl>${viewurl}</viewurl>
      
      <islocked>${isLocked}</islocked>
      <isWorkingCopy>${isWorkingCopy}</isWorkingCopy>
      
      <readPermission>${readPermission}</readPermission>      
      <writePermission>${writePermission}</writePermission>
      <deletePermission>${deletePermission}</deletePermission>
      <createChildrenPermission>${createChildrenPermission}</createChildrenPermission>

   </node>

</#list>
</#if>

</versionlist>