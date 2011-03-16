<?xml version="1.0" encoding="UTF-8"?>
<#if args.taskid?exists>
   <#assign taskid = args.taskid>
   <#if taskid != "">
      <#assign task = workflow.getTaskById(taskid)>
   </#if>
</#if>

<tasktransitions>
<#if task?exists>
   
   <#list task.transitions as wt>
   <transition>
      <id>${wt.id}</id>
      <label>${wt.label}</label>
   </transition>      
   </#list>
   
</#if>
</tasktransitions>

