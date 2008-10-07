<?xml version="1.0" encoding="UTF-8"?>
<categoryProperties>

   <name>${node.name}</name>
   <id>${node.id}</id>
   <noderef>${node.nodeRef}</noderef>

   <categories>

   <#if node.properties.categories?exists>
      <#list node.properties.categories as category>
      <category>
         <name>${category.name}</name>
         <id>${category.id}</id>
         <noderef>${category.nodeRef}</noderef>         
      </category>
      </#list>
   </#if>

   </categories>

</categoryProperties>
