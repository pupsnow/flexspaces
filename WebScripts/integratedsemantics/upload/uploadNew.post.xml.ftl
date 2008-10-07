<upload>
<server>Alfresco ${server.edition} v${server.version}</server>
<folder>
   <name>${folder.name}</name>
   <id>${folder.id}</id>
   <path>${folder.displayPath}/${folder.name}</path>
</folder>
<node>
   <name>${upload.properties.name}</name>
   <id>${upload.id}</id>
   <path>${upload.displayPath}/${upload.name}</path>
   <title>${upload.properties.title!}</title>
   <description>${upload.properties.description!}</description>
   <#if upload.isDocument>
      <author>${upload.properties.author!}</author>
      <size>${upload.properties.content.size}</size>
   </#if>
</node>
</upload>
