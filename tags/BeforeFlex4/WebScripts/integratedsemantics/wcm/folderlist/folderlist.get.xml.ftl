<?xml version="1.0" encoding="UTF-8"?>
<folder>
   
   <name>${node.name}</name>   
   
   <noderef>${node.nodeRef}</noderef>
   
   <storeProtocol>${node.nodeRef.storeRef.protocol}</storeProtocol>
   <storeId>${node.nodeRef.storeRef.identifier}</storeId>
   <id>${node.id}</id>

   <parentPath>${node.displayPath}</parentPath>
   <path>${node.displayPath}/${node.name}</path>   
   
   <readPermission>${ node.hasPermission("Read")?string("true", "false") }</readPermission>      
   <writePermission>${ node.hasPermission("Write")?string("true", "false") }</writePermission>
   <deletePermission>${ node.hasPermission("Delete")?string("true", "false") }</deletePermission>
   <createChildrenPermission>${ node.hasPermission("CreateChildren")?string("true", "false") }</createChildrenPermission>
   

<#list node.children as c>
   <#if c.isContainer>
       <#assign isFolder="true">
       <#assign type="Folder">
       <#assign size="">
       <#assign viewurl="">
       <#assign createChildrenPermission = "${ c.hasPermission('CreateChildren')?string('true', 'false') }" >       
   <#else>
       <#assign isFolder="false">
       <#assign type="Document">
       <#assign size=c.size/1024 + " KB">
       <#assign viewurl= "${absurl(url.serviceContext)}/api/node/content/${c.nodeRef.storeRef.protocol}/${c.nodeRef.storeRef.identifier}/${c.nodeRef.id}/${c.name?url}" >
       <#assign createChildrenPermission = "false">
   </#if>

   <node>
   
      <name>${c.name}</name>
      
      <noderef>${c.nodeRef}</noderef>

      <storeProtocol>${c.nodeRef.storeRef.protocol}</storeProtocol>
      <storeId>${c.nodeRef.storeRef.identifier}</storeId>
      <id>${c.id}</id>
            
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
      
      <readPermission>${ c.hasPermission("Read")?string("true", "false") }</readPermission>      
      <writePermission>${ c.hasPermission("Write")?string("true", "false") }</writePermission>
      <deletePermission>${ c.hasPermission("Delete")?string("true", "false") }</deletePermission>
      <createChildrenPermission>${createChildrenPermission}</createChildrenPermission>
      
   </node>
</#list>

</folder>
