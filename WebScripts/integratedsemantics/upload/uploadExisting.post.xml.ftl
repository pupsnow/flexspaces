<upload>
<server>Alfresco ${server.edition} v${server.version}</server>
<node>
   <name>${node.properties.name}</name>
   <id>${node.id}</id>
   <path>${node.displayPath}/${node.name}</path>
   <title>${node.properties.title!}</title>
   <description>${node.properties.description!}</description>
   <#if node.isDocument>
      <author>${node.properties.author!}</author>
      <size>${node.properties.content.size}</size>
   </#if>
</node>
</upload>
