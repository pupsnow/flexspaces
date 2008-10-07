<properties>
   <node>
      <name>${node.properties.name!""}</name>
      <title>${node.properties.title!""}</title>
      <description>${node.properties.description!""}</description>
      <#if node.isDocument>
         <author>${node.properties.author!""}</author>
      </#if>
   </node>
</properties>