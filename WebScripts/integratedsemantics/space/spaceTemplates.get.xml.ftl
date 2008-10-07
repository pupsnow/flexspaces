<?xml version="1.0" encoding="UTF-8"?>
<#assign xpath="app:dictionary/app:space_templates/*">
<#assign templates = companyhome.childrenByXPath[xpath]>
<spaceTemplates>
   <template>
      <name>None</name>
      <id></id>
   </template>
<#list templates as template>
   <template>
      <name>${template.name}</name>
      <id>${template.id}</id>
   </template>
</#list>
</spaceTemplates>
