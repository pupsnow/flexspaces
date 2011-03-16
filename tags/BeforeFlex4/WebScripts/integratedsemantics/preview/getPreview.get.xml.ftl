<getPreview>

<node>
   <name>${node.name}</name>
   <id>${node.id}</id>
   <path>${node.displayPath}/${node.name}</path>
</node>

<#if preview??>

<previewid>${preview.id}</previewid>

<#assign viewurl= "${absurl(url.serviceContext)}/api/node/content/${preview.nodeRef.storeRef.protocol}/${preview.nodeRef.storeRef.identifier}/${preview.nodeRef.id}/${preview.name?url}">
<previewurl>${viewurl}</previewurl>

<#else>

<previewid></previewid>
<previewurl></previewurl>

</#if>

</getPreview>
