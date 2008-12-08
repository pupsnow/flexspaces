package org.integratedsemantics.flexspaces.control.command.search
{
    import com.ericfeminella.collections.StringTokenizer;
    
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.utils.StringUtil;
    import org.integratedsemantics.flexspaces.model.repo.RepoQName;
    
    
    public class QueryBuilder
    {
        // Search mode constants
        public static const SEARCH_ALL:int = 0;
        public static const SEARCH_FILE_NAMES_CONTENTS:int = 1;
        public static const SEARCH_FILE_NAMES:int = 2;
        public static const SEARCH_SPACE_NAMES:int = 3;
        
        // advanced search term operators
        protected static const OP_WILDCARD:String = "*";
        protected static const OP_AND:String = "+";
        protected static const OP_NOT:String = "-";
        protected static const STR_OP_WILDCARD:String = "" + OP_WILDCARD;
        
        protected static const CONTENT_MODEL_1_0_URI:String = "http://www.alfresco.org/model/content/1.0";
        protected static const PROP_CONTENT:RepoQName = new RepoQName(CONTENT_MODEL_1_0_URI, "content");
        
        // the search text string
        protected var text:String = "";
           
        // mode for the search
        protected var mode:int = SEARCH_ALL;
           
        // folder XPath location for the search
        protected var location:String = null;
           
        // categories to add to the search
        protected var categories:Array = new Array(0);
           
        // folder type to restrict search against
        protected var folderType:String = null;
           
        // content type to restrict search against
        protected var contentType:String = null;
           
        // content mimetype to restrict search against
        protected var mimeType:String = null;
          
        // any extra simple query attributes to add to the search (RepoQName list)
        protected var simpleSearchAdditionalAttrs:ArrayCollection = new ArrayCollection();
           
        // any extra query attributes to add to the search (RepoQName to String map)
        protected var queryAttributes:Dictionary = new Dictionary()
           
        // any additional range attribute to add to the search (RepoQName to RangeProperties map)
        protected var rangeAttributes:Dictionary = new Dictionary();
           
        // any additional fixed value attributes to add to the search, such as boolean or noderef
        protected var queryFixedValues:Dictionary = new Dictionary();
           
        // set true to force the use of AND between text terms
        protected var forceAndTerms:Boolean = false;


        /**
         * Constructur 
         */
        public function QueryBuilder()
        {
        }
            
        /**
         * Build the search query string based on the current search context members.
         * 
         * @param minimum       small possible textual string used for a match
         *                      this does not effect fixed values searches (e.g. boolean, int values) or date ranges
         * 
         * @return prepared search query string
         */
        public function buildQuery(minimum:int):String
        {
          var query:String;
          var validQuery:Boolean = false;
          
          // the RepoQName for the well known "name" attribute
          var nameAttr:String = escapeQName(new RepoQName(CONTENT_MODEL_1_0_URI, "name"));
          
          // match against content text
          var text:String =  StringUtil.trim(this.text);
          
          var fullTextBuf:String = new String();
          var nameAttrBuf:String = new String();
          var additionalAttrsBuf:String = new String();
          
          if (text.length != 0 && text.length >= minimum)
          {
             if (text.indexOf(' ') == -1 && text.charAt(0) != '"')
             {
                // check for existance of a special operator
                var operatorAND:Boolean = (text.charAt(0) == OP_AND);
                var operatorNOT:Boolean = (text.charAt(0) == OP_NOT);
                // strip operator from term if one was found
                if (operatorAND || operatorNOT)
                {
                   text = text.substring(1);
                }
                
                if (text.length != 0)
                {
                   // prepend NOT operator if supplied
                   if (operatorNOT)
                   {
                      fullTextBuf = fullTextBuf + OP_NOT;
                      nameAttrBuf = nameAttrBuf + OP_NOT;
                   }
                   
                   fullTextBuf = processSearchText(text, fullTextBuf);
                   nameAttrBuf = processSearchTextAttribute(nameAttr, text, nameAttrBuf);

                   for (var qname:* in this.simpleSearchAdditionalAttrs)
                   {
                      additionalAttrsBuf = processSearchAttribute(qname, text, additionalAttrsBuf, false, operatorNOT);
                   }
                }
             }
             else
             {
                // multiple word search
                if (text.charAt(0) == '"' && text.charAt(text.length - 1) == '"')
                {
                   // as a single quoted phrase
                   var quotedSafeText:String = '"' + text.substring(1, text.length - 1) + '"';
                   fullTextBuf = fullTextBuf + "TEXT:" + quotedSafeText;
                   nameAttrBuf = nameAttrBuf + "@" + nameAttr + ":" + quotedSafeText ;
                   for (qname in this.simpleSearchAdditionalAttrs)
                   {
                      additionalAttrsBuf = additionalAttrsBuf + " @" + escapeQName(qname) + ":" + quotedSafeText;
                   }
                }
                else
                {
                   // as individual search terms
                   var t:StringTokenizer = new StringTokenizer(text, " ");
                                                         
                   fullTextBuf = fullTextBuf + '(';
                   nameAttrBuf = nameAttrBuf + '(';
                   additionalAttrsBuf = additionalAttrsBuf + '(';
                   
                   var termCount:int = 0;
                   var tokenCount:int = t.countTokens();
                   for (var i:int = 0; i<tokenCount; i++)
                   {
                      var term:String = t.nextToken();
                      
                      // check for existance of a special operator
                      operatorAND = (term.charAt(0) == OP_AND);
                      operatorNOT = (term.charAt(0) == OP_NOT);
                      // strip operator from term if one was found
                      if (operatorAND || operatorNOT)
                      {
                         term = term.substring(1);
                      }
                      
                      // special case for AND all terms if set (apply after operator character removed)
                      // note that we can't force AND if NOT operator has been set
                      if (operatorNOT == false)
                      {
                         operatorAND = operatorAND || this.forceAndTerms;
                      }
                      
                      if (term.length != 0)
                      {
                         // prepend NOT operator if supplied
                         if (operatorNOT)
                         {
                            fullTextBuf = fullTextBuf + OP_NOT;
                            nameAttrBuf = nameAttrBuf + OP_NOT;
                         }
                         
                         // prepend AND operator if supplied
                         if (operatorAND)
                         {
                            fullTextBuf = fullTextBuf + OP_AND;
                            nameAttrBuf = nameAttrBuf + OP_AND;
                         }
                         
                         fullTextBuf = processSearchText(term, fullTextBuf);
                         nameAttrBuf = processSearchTextAttribute(nameAttr, term, nameAttrBuf);
                         
                         for (qname in this.simpleSearchAdditionalAttrs)
                         {
                            additionalAttrsBuf = processSearchAttribute(qname, term, additionalAttrsBuf, operatorAND, operatorNOT);
                         }
                         
                         fullTextBuf = fullTextBuf + ' ';
                         nameAttrBuf = nameAttrBuf + ' ';
                         additionalAttrsBuf = additionalAttrsBuf + ' ';
                         
                         termCount++;
                      }
                   }
                   fullTextBuf = fullTextBuf + ')';
                   nameAttrBuf = nameAttrBuf + ')';
                   additionalAttrsBuf = additionalAttrsBuf + ')';
                }
             }
             
             validQuery = true;
          }
          
          // match a specific PATH for space location or categories
          var pathQuery:String = null;
          if (location != null || (categories != null && categories.length !=0))
          {
             pathQuery = new String();
             if (location != null)
             {
                pathQuery = pathQuery + " PATH:\"" + location + "\" ";
                if (categories != null && categories.length != 0)
                {
                   pathQuery = pathQuery + "AND (";
                }
             }
             if (categories != null && categories.length != 0)
             {
                for (i = 0; i<categories.length; i++)
                {
                   pathQuery = pathQuery + " PATH:\"" + categories[i] + "\" ";
                }
                if (location != null)
                {
                   pathQuery = pathQuery + ") ";
                }
             }
          }
          
          // match any extra query attribute values specified
          var attributeQuery:String = null;
          if (assocArrayLength(queryAttributes) != 0)
          {
             attributeQuery = new String();
             for (qname in queryAttributes)
             {
                var value:String = queryAttributes[qname] as String;
                value = StringUtil.trim(value);
                if (value.length >= minimum)
                {
                   attributeQuery = processSearchAttribute(qname, value, attributeQuery);
                }
             }
             
             // handle the case where we did not add any attributes due to minimum length restrictions
             if (attributeQuery.length == 0)
             {
                attributeQuery = null;
             }
          }
          
          // match any extra fixed value attributes specified
          if (assocArrayLength(queryFixedValues) != 0)
          {
             if (attributeQuery == null)
             {
                attributeQuery = new String();
             }
             for (qname in queryFixedValues)
             {
                var escapedName:String = escapeQName(qname);
                value = queryFixedValues[qname];
                attributeQuery = attributeQuery + " +@" + escapedName + ":\"" + value + '"';
             }
          }
          
          // range attributes are a special case also
          if (assocArrayLength(rangeAttributes) != 0)
          {
             if (attributeQuery == null)
             {
                attributeQuery = new String();
             }
             for each (var rp:RangeProperties in rangeAttributes)
             {
                escapedName = escapeQName(rp.qname);
                var value1:String = luceneQueryParserEscape(rp.lower);
                var value2:String = luceneQueryParserEscape(rp.upper);
                attributeQuery = attributeQuery + " +@" + escapedName +
                               ":" + ( rp.inclusive ? "[" : "{") + value1
                               + " TO " + value2  + (rp.inclusive ? "]" : "}");
             }
          }
          
          // mimetype is a special case - it is indexed as a special attribute it comes from the combined
          // ContentData attribute of cm:content - ContentData string cannot be searched directly
          if (mimeType != null && mimeType.length != 0)
          {
             if (attributeQuery == null)
             {
                attributeQuery = new String();
             }
             escapedName = escapeQName( new RepoQName(CONTENT_MODEL_1_0_URI, "content.mimetype"));
             attributeQuery = attributeQuery + " +@" + escapedName + ":" + mimeType;
          }
          
          // match against appropriate content type
          var fileTypeQuery:String;
          if (contentType != null)
          {
             fileTypeQuery = " TYPE:\"" + contentType + "\" ";
          }
          else
          {
             // default to cm:content
             fileTypeQuery = " TYPE:\"{" + CONTENT_MODEL_1_0_URI + "}content\" ";
          }
          
          // match against appropriate folder type
          var folderTypeQuery:String;
          if (folderType != null)
          {
             folderTypeQuery = " TYPE:\"" + folderType + "\" ";
          }
          else
          {
             folderTypeQuery = " TYPE:\"{" + CONTENT_MODEL_1_0_URI + "}folder\" ";
          }
          
          var fullTextQuery:String = fullTextBuf;
          var nameAttrQuery:String = nameAttrBuf;
          var additionalAttrsQuery:String =
             (this.simpleSearchAdditionalAttrs.length != 0) ? additionalAttrsBuf : "";
          
          if (text.length != 0 && text.length >= minimum)
          {
             // text query for name and/or full text specified
             switch (mode)
             {
                case SEARCH_ALL:
                   query = '(' + fileTypeQuery + " AND " + '(' + nameAttrQuery + ' ' + additionalAttrsQuery + ' ' + fullTextQuery + ')' + ')' +
                           ' ' +
                           '(' + folderTypeQuery + " AND " + '(' + nameAttrQuery + ' ' + additionalAttrsQuery + "))";
                   break;
                
                case SEARCH_FILE_NAMES:
                   query = fileTypeQuery + " AND " + nameAttrQuery;
                   break;
                
                case SEARCH_FILE_NAMES_CONTENTS:
                   query = fileTypeQuery + " AND " + '(' + nameAttrQuery + ' ' + fullTextQuery + ')';
                   break;
                
                case SEARCH_SPACE_NAMES:
                   query = folderTypeQuery + " AND " + nameAttrQuery;
                   break;
                
                default:
                   throw new Error("Unknown search mode specified: " + mode);
             }
          }
          else
          {
             // no text query specified - must be an attribute/value query only
             switch (mode)
             {
                case SEARCH_ALL:
                   query = '(' + fileTypeQuery + ' ' + folderTypeQuery + ')';
                   break;
                
                case SEARCH_FILE_NAMES:
                case SEARCH_FILE_NAMES_CONTENTS:
                   query = fileTypeQuery;
                   break;
                
                case SEARCH_SPACE_NAMES:
                   query = folderTypeQuery;
                   break;
                
                default:
                    throw new Error("Unknown search mode specified: " + mode);
             }
          }
          
          // match entire query against any additional attributes specified
          if (attributeQuery != null)
          {
             query = attributeQuery + " AND (" + query + ')';
          }
          
          // match entire query against any specified paths
          if (pathQuery != null)
          {
             query = "(" + pathQuery + ") AND (" + query + ')';
          }
          
          // check that we have a query worth executing - if we have no attributes, paths or text/name search
          // then we'll only have a search against files/type TYPE which does nothing by itself!
          validQuery = validQuery || (attributeQuery != null) || (pathQuery != null);
          if (validQuery == false)
          {
             query = null;
          }
          
          // trace("Query: " + query);
          
          return query;
        }
        
        /**
         * Build the lucene search terms required for the specified attribute and append to a buffer.
         * Supports text values with a wildcard '*' character as the prefix and/or the suffix. 
         * 
         * @param qname      RepoQName of the attribute
         * @param value      Non-null value of the attribute
         * @param buf        Buffer to append lucene terms to (pass by value)
         * @param andOp      If true apply the '+' AND operator as the prefix to the attribute term
         * @param notOp      If true apply the '-' NOT operator as the prefix to the attribute term
         * @return           built query part
         */
        protected static function processSearchAttribute(qname:RepoQName, value:String, buf:String, andOp:Boolean=true,  notOp:Boolean=false):String
        {
            if (andOp)
            {
                buf = buf + '+';
            }
            else if (notOp) 
            {
                buf = buf + '-';
            }
            buf = buf + '@' + escapeQName(qname) + ":\"" + value + "\" ";
            
            return buf;
        }
   
        /**
         * Build the lucene search terms required for the specified attribute and append to multiple buffers.
         * Supports text values with a wildcard '*' character as the prefix and/or the suffix. 
         * 
         * @param value      Non-null value of the attribute
         * @param textBuf    Text search buffer to append lucene terms to (pass by value)
         * @return           built query part
         */
        protected static function processSearchText(value:String, textBuf:String):String
        {
            textBuf = textBuf + "TEXT:\"" + value  + '"';
            
            return textBuf;
        }
   
        /**
         * Build the lucene search terms required for the specified attribute and append to multiple buffers.
         * Supports text values with a wildcard '*' character as the prefix and/or the suffix. 
         * 
         * @param qname      qualNameToStr(RepoQName) of the attribute
         * @param value      Non-null value of the attribute
         * @param attrBuf    Attribute search buffer to append lucene terms to (pass by value)
         * @return           built query part
         */
        protected static function processSearchTextAttribute(qname:String, value:String, attrBuf:String):String
        {
            attrBuf = attrBuf + '@' + qname + ":\"" + value + '"';
            
            return attrBuf;
        }

        /**
         * @return returns categories to use for the search
         */
        public function getCategories():Array
        {
            return this.categories;
        }
        
        /**
         * @param categories categories to set as a list of search XPATHs
         */
        public function setCategories(categories:Array):void
        {
            if (categories != null)
            {
                this.categories = categories;
            }
        }
        
        /**
         * @return returns the node XPath to search in or null for all.
         */
        public function getLocation():String
        {
            return this.location;            
        }
        
        /**
         * @param location the node XPATH to search from or null for all..
         */
        public function setLocation(location:String):void
        {
            this.location = location;
        }
        
        /**
         * @return returns the mode to use during the search (see constants)
         */
        public function getMode():int
        {
            return this.mode;
        }
        
        /**
         * @param mode the mode to use during the search (see constants)
         */
        public function setMode(mode:int):void
        {
            this.mode = mode;
        }
        
        /**
         * @return returns the search text string.
         */
        public function getText():String
        {
            return this.text;
        }
        
        /**
         * @param text the search text string.
         */
        public function setText(text:String):void
        {
            this.text = text;
        }
    
        /**
         * @return returns the contentType.
         */
        public function getContentType():String
        {
            return this.contentType;
        }
    
        /**
         * @param contentType the content type to restrict attribute search against.
         */
        public function setContentType(contentType:String):void
        {
            this.contentType = contentType;
        }
        
        /**
         * @return returns the folderType.
         */
        public function getFolderType():String
        {
            return this.folderType;
        }
    
        /**
         * @param folderType the folder type to restrict attribute search against.
         */
        public function setFolderType(folderType:String):void
        {
            this.folderType = folderType;
        }
        
        /**
         * @return returns the mimeType.
         */
        public function getMimeType():String
        {
           return this.mimeType;
        }
        
        /**
         * @param mimeType the mimeType to set.
         */
        public function setMimeType(mimeType:String):void
        {
            this.mimeType = mimeType;
        }
        
        /**
         * Add an additional attribute to search against for simple searches
         * 
         * @param qname      RepoQName of the attribute to search against
         * @param value      Value of the attribute to use
         */
        public function addSimpleAttributeQuery(qname:RepoQName):void
        {
            this.simpleSearchAdditionalAttrs.addItem(qname);
        }
   
        /**
         * Sets the additional attribute to search against for simple searches.
         * 
         * @param attrs      The list of attributes to search against (RepoQName List)
         */
        public function setSimpleSearchAdditionalAttributes(attrs:ArrayCollection):void
        {
           if (attrs != null)
           {
               this.simpleSearchAdditionalAttrs = attrs;
           }
        }
        
        /**
         * Add an additional attribute to search against
         * 
         * @param qname      RepoQName of the attribute to search against
         * @param value      value of the attribute to use
         */
        public function addAttributeQuery(qname:RepoQName, value:String):void
        {
            this.queryAttributes[qname] = value;
        }
        
        public function getAttributeQuery(qname:RepoQName):String
        {
            return this.queryAttributes[qname];
        }
    
        /**
         * Add an additional range attribute to search against
         * 
         * @param qname      RepoQName of the attribute to search against
         * @param lower      lower value for range
         * @param upper      upper value for range
         * @param inclusive  true for inclusive within the range, false otherwise
         */
        public function addRangeQuery(qname:RepoQName, lower:String, upper:String, inclusive:Boolean):void
        {
            this.rangeAttributes[qname] = new RangeProperties(qname, lower, upper, inclusive);
        }
                
        /**
         * Get range property
         *  
         * @param qname RepoQName 
         * @return  range property
         * 
         */
        public function getRangeProperty(qname:RepoQName):RangeProperties
        {
            return this.rangeAttributes[qname];
        }
                
        /**
         * Add an additional fixed value attribute to search against
         * 
         * @param qname      RepoQName of the attribute to search against
         * @param value      fixed value of the attribute to use
         */
        public function addFixedValueQuery(qname:RepoQName, value:String):void
        {
            this.queryFixedValues[qname] = value;
        }
        
        /**
         *  Get fixed value query
         * 
         * @param qname     RepoQName of the attribute to search against
         * @return          fixed value query
         * 
         */
        public function getFixedValueQuery(qname:RepoQName):String
        {
            return this.queryFixedValues[qname];
        }
    
        /**
         * Get force AND terms setting
         * 
         * @return  returns if AND is forced between text terms. False (OR terms) is the default.
         */
        public function getForceAndTerms():Boolean
        {
            return this.forceAndTerms;
        }
    
        /**
         * Set force AND terms setting
         * 
         * @param forceAndTerms     set true to force AND between text terms. Otherwise OR is the default.
         */
        public function setForceAndTerms(forceAndTerms:Boolean):void
        {
            this.forceAndTerms = forceAndTerms;
        }   
        
        
        /**
         * Escape a RepoQName value so it can be used in lucene search strings
         * 
         * @param qName      RepoQName to escape
         * 
         * @return escaped value
         */
        protected static function escapeQName(qName:RepoQName):String
        {
            var string:String = qName.toString();
            var buf:String = new String();
            for (var i:int = 0; i < string.length; i++)
            {
                var c:String = string.charAt(i);
                if ((c == '{') || (c == '}') || (c == ':') || (c == '-'))
                {
                   buf = buf + '\\';
                }
               
                buf = buf + c;
            }
            return buf;
        }                     
        
        /**
         * Returns a String where those characters that QueryParser
         * expects to be escaped are escaped by a preceding <code>\</code>.
         * 
         * @param s  string to escape
         * @return   escaped string
         * 
         */
        public static function luceneQueryParserEscape(s:String):String
        {
            var sb:String = new String();
            for (var i:int = 0; i < s.length; i++)
            {
                var c:String = s.charAt(i);
                // NOTE: keep this in sync with _ESCAPED_CHAR below!
                if (c == '\\' || c == '+' || c == '-' || c == '!' || c == '(' || c == ')' || c == ':'
                    || c == '^' || c == '[' || c == ']' || c == '\"' || c == '{' || c == '}' || c == '~'
                    || c == '*' || c == '?')
                {
                    sb = sb + '\\';
                }
                sb = sb + c;
            }
            return sb;
       }
       
       
        /**
         * Count number of associative array elements
         *  
         * @param assocArray object being used as an associative array
         * @return  number of elements
         * 
         */
        protected static function assocArrayLength(assocArray:Object):int
        {
            var len:int = 0;
            for (var key:Object in assocArray)
            {
                len++;
            }
            return len;   
        }
                
    }

}