<?xml version="1.0" encoding="UTF-8"?>
<tree>
<folder>
   
   <name>${node.name}</name>
   
   <noderef>${node.nodeRef}</noderef>

   <storeProtocol>${node.nodeRef.storeRef.protocol}</storeProtocol>
   <storeId>${node.nodeRef.storeRef.identifier}</storeId>
   <id>${node.id}</id>
   
   <parentPath>${node.displayPath}</parentPath>
   <path>${node.displayPath}/${node.name}</path>
   <qnamePath>${node.qnamePath}</qnamePath>
   
   <readPermission>${ node.hasPermission("Read")?string("true", "false") }</readPermission>      
   <writePermission>${ node.hasPermission("Write")?string("true", "false") }</writePermission>
   <deletePermission>${ node.hasPermission("Delete")?string("true", "false") }</deletePermission>
   <createChildrenPermission>${ node.hasPermission("CreateChildren")?string("true", "false") }</createChildrenPermission>
   
   <children>
      <#list node.children as child>
      <#if child.isContainer>
      <folder>
         
         <name>${child.name}</name>
         
         <noderef>${child.nodeRef}</noderef>
         
         <storeProtocol>${child.nodeRef.storeRef.protocol}</storeProtocol>
         <storeId>${child.nodeRef.storeRef.identifier}</storeId>
         <id>${child.id}</id>
         
         <parentPath>${child.displayPath}</parentPath>
         <path>${child.displayPath}/${child.name}</path>
         <qnamePath>${child.qnamePath}</qnamePath>
         
         <readPermission>${ child.hasPermission("Read")?string("true", "false") }</readPermission>      
         <writePermission>${ child.hasPermission("Write")?string("true", "false") }</writePermission>
         <deletePermission>${ child.hasPermission("Delete")?string("true", "false") }</deletePermission>
         <createChildrenPermission>${ child.hasPermission("CreateChildren")?string("true", "false") }</createChildrenPermission>
         
      </folder>
      </#if>
      </#list>
   </children>
   
   
</folder>
</tree>
