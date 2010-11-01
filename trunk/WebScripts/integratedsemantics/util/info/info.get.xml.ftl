<?xml version="1.0" encoding="UTF-8"?>

<info>

   <serverEdition>${server.edition}</serverEdition>
   <serverVersion>${server.version}</serverVersion>

<#if companyHomeReadPerm>
   <companyHome>
      <name>${companyHome.name}</name>      
      <noderef>${companyHome.nodeRef}</noderef>      
      <storeProtocol>${companyHome.nodeRef.storeRef.protocol}</storeProtocol>
      <storeId>${companyHome.nodeRef.storeRef.identifier}</storeId>
      <id>${companyHome.id}</id>      
      <path>${companyHome.displayPath}/${companyHome.name}</path>   
   </companyHome>
<#else>
   <companyHome>
      <name></name>      
      <noderef></noderef>      
      <storeProtocol></storeProtocol>
      <storeId></storeId>
      <id></id>      
      <path></path>   
   </companyHome>
</#if>

   <userName>${userName}</userName>
   <firstName>${firstName}</firstName>
   <lastName>${lastName}</lastName>

   <userHome>
      <name>${userHome.name}</name>      
      <noderef>${userHome.nodeRef}</noderef>      
      <storeProtocol>${userHome.nodeRef.storeRef.protocol}</storeProtocol>
      <storeId>${userHome.nodeRef.storeRef.identifier}</storeId>
      <id>${userHome.id}</id>      
      <path>${userHome.displayPath}/${userHome.name}</path>   
   </userHome>

</info>