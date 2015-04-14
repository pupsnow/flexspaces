To work with the combination of IE + SSL + Flex/Flash,  web scripts need in their description xml files:

```
   <cache>
      <never>false</never>
   </cache>   
```

The webscripts in the flexspaces googlecode svn now have this (10/31/2010)

FlexSpaces also uses some built-in Alfresco webscripts for login, validate ticket and logout:

So in your alfresco install

<alfresco install dir>\tomcat\webapps\alfresco\WEB-INF\classes\alfresco\templates\webscripts\org\alfresco\repository

> you need to add the
```
   <cache>
      <never>false</never>
   </cache> 
</webscript> 
```

in the following web script description xml files:
  * login.get.desc.xml
  * loginticket.delete.desc.xml
  * loginticket.get.desc.xml


