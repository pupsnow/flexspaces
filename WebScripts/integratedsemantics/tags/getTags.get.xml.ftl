<?xml version="1.0" encoding="UTF-8"?>
<tagQuery>

   <countMin>${tagQuery.countMin}</countMin>
   <countMax>${tagQuery.countMax}</countMax>

   <tags>
   <#list tagQuery.tags as tag>
      <tag>
         <name>${tag.name}</name>
         <count>${tag.count}</count>
      </tag>
   </#list>
   </tags>

</tagQuery>