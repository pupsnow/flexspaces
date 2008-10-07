<?xml version="1.0" encoding="UTF-8"?>
<result>
    <status>${resultString}</status>
    <code>${resultCode?string}</code>
    <workingCopy>
        <#if workingCopy?exists>
              
        <name>${workingCopy.name}</name>      

        <noderef>${workingCopy.nodeRef}</noderef>
      
        <storeProtocol>${workingCopy.nodeRef.storeRef.protocol}</storeProtocol>
        <storeId>${workingCopy.nodeRef.storeRef.identifier}</storeId>
        <id>${workingCopy.id}</id>      
       
        <#assign viewurl= "${absurl(url.serviceContext)}/api/node/content/${workingCopy.nodeRef.storeRef.protocol}/${workingCopy.nodeRef.storeRef.identifier}/${workingCopy.nodeRef.id}/${workingCopy.name?url}" >
        <viewurl>${viewurl}</viewurl>
       
        </#if>
    </workingCopy>     
</result>