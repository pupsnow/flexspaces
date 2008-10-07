<?xml version="1.0" encoding="UTF-8"?>
<categories>

   <#list nodes as category>
   <category>
      <name>${category.name}</name>
      <id>${category.id}</id>
      <noderef>${category.nodeRef}</noderef>
      <qnamePath>${category.qnamePath}</qnamePath>      
   </category>
   </#list>

</categories>