<?xml version="1.0" encoding="UTF-8"?>
<avmStores>
   <#list avm.stores as store>
   <store>
      <id>${store.id}</id>
      <name>${store.name}</name>
      <creator>${store.creator}</creator>
      <createdDate>${store.createdDate?datetime}</createdDate>
   </store>   
   </#list>
</avmStores>
