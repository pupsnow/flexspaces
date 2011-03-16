<tasks>

<#list workflow.assignedTasks as t>
   
   <taskitem>
   
   <description>${t.description!""}</description>
   <type>${t.type}</type>
   <taskid>${t.id}</taskid>
   <startdate>${t.startDate}</startdate>
   <priority>${t.properties["bpm:priority"]}</priority>
   <status>${t.properties["bpm:status"]}</status>
   <percentcomplete>${t.properties["bpm:percentComplete"]}</percentcomplete>
      
   <#assign hasDue=t.properties["bpm:dueDate"]?exists>
   
   <#if hasDue>

      <#assign due=t.properties["bpm:dueDate"]>

      <#-- items due today? -->
      <#if (dateCompare(date?date, due?date, 0, "==") == 1)>
         <duetoday>true</duetoday>
      <#else>
         <duetoday>false</duetoday>
      </#if>   
      
      <#-- items overdue? -->
      <#if (dateCompare(date?date, due?date) == 1)>
         <overdue>true</overdue>
      <#else>
         <overdue>false</overdue>
      </#if>   

      <duedate>${due?date}</duedate>

   <#else>
      <duetoday>false</duetoday>
      <overdue>false</overdue>
      <duedate>none</duedate>
   </#if>
            
   </taskitem>
   
</#list>

</tasks>
