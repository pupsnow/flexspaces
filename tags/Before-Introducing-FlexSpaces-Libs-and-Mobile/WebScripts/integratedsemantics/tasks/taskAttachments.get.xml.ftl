<?xml version="1.0" encoding="UTF-8"?>
<#if args.taskid?exists>
   <#assign taskid = args.taskid>
   <#if taskid != "">
      <#assign task = workflow.getTaskById(taskid)>
   </#if>
</#if>

<taskattachments>
<#if task?exists>
   <#list task.packageResources as res>
      
      <#if res.isContainer>
          <#assign isFolder="true">
          <#assign type="Folder">
          <#assign size="">
          <#assign viewurl="">
          <#assign isLocked="false">
          <#assign isWorkingCopy="false">
          <#assign createChildrenPermission = "${ res.hasPermission('CreateChildren')?string('true', 'false') }" >
          
      <#else>
          <#assign isFolder="false">
          <#assign type="Document">
          <#assign size=res.size/1024 + " KB">
          <#assign viewurl= "${absurl(url.serviceContext)}/api/node/content/${res.nodeRef.storeRef.protocol}/${res.nodeRef.storeRef.identifier}/${res.nodeRef.id}/${res.name?url}" >
          <#assign isLocked = "${ res.isLocked?string('true', 'false') }" >
          <#assign isWorkingCopy = "${ res.hasAspect('cm:workingcopy')?string('true', 'false') }" >
          <#assign createChildrenPermission = "false">
       </#if>
   
      <node>
         
         <name>${res.name}</name>
         
         
         <noderef>${res.nodeRef}</noderef>
         
         <storeProtocol>${res.nodeRef.storeRef.protocol}</storeProtocol>
         <storeId>${res.nodeRef.storeRef.identifier}</storeId>
         <id>${res.id}</id>

         <parentPath>${res.displayPath}</parentPath>
         <path>${res.displayPath}/${res.name}</path>
         
         <icon16>${res.icon16}</icon16>
         <icon32>${res.icon32}</icon32>
         <icon64>${res.icon64}</icon64>
         
         <isFolder>${isFolder}</isFolder>
         <type>${type}</type>
         
         <desc>${res.properties.description!}</desc>
         
         <size>${size}</size>
         
         <created>${res.properties.created?datetime}</created>
         <modified>${res.properties.modified?datetime}</modified>
         
         <viewurl>${viewurl}</viewurl>
         
         <locked>${isLocked}</locked>
         <workingcopy>${isWorkingCopy}</workingcopy>
         
         <readPermission>${ res.hasPermission("Read")?string("true", "false") }</readPermission>      
         <writePermission>${ res.hasPermission("Write")?string("true", "false") }</writePermission>
         <deletePermission>${ res.hasPermission("Delete")?string("true", "false") }</deletePermission>
         <createChildrenPermission>${createChildrenPermission}</createChildrenPermission>         
      
      </node>
            
   </#list>
   
</#if>
</taskattachments>

