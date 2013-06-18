module www::XmlWrite
import Prelude;


public str id = "id";
public str tg = "tg"; // tag
public str name = "name";

alias WProperty = map[str key, str val];

public map[str, WProperty] key2att = (
   "a":(tg:"a"), 
   "body":(tg:"body"),
   "head":(tg:"head"),
   "title":(tg:"title"),
   "h1":(tg:"h1"), 
   "h2":(tg:"h2"),  
   "h3":(tg:"h3"), 
   "h4":(tg:"h4"),
   "img":(tg:"img"),
   "p":(tg:"p"), 
   "div":(tg:"div"),
   "span":(tg:"span"),
   "svg":(tg:"svg"),
   "pre":(tg:"pre"), 
   "table":(tg:"table"),  
   "tr":(tg:"tr"),
   "td":(tg:"td"), 
   "th":(tg:"th"), 
   "thead":(tg:"thead"),
   "tbody":(tg:"tbody"), 
   "tfoot":(tg:"tfoot"),
   "caption":(tg:"caption"),      
   "iframe":(tg:"iframe")  
   );
   
public map[str , WProperty] tag2att = ();
   
   
public str toCSS() {
   str r = "\<style\>\n";
   for (x<-tag2att) {
       r+="<x>{<for(y<-tag2att[x]){><y>:<tag2att[x][y]>;\n<}>}\n";
       }
   r+="\</style\>\n";
   return r;
   }

public str html(str head, str body) {
	return "\<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"
            '  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"\>
            '  \<html xmlns=\"http://www.w3.org/1999/xhtml\"\>
            '
            '
            '<head>\n<body>\n\</html\>"
           ;
}

public str html(str b) {
    return  html(head(toCSS()), body(b));
    }

private str transform(str key, str txt, map[str, WProperty] m) {
    WProperty props = m[key];
    str key = props[tg];
    return ("\<<key><for(x<-props, x!=tg){> <x>=\"<props[x]>\"<}>\>\n"+
         "<txt>\n"+"\</<key>\>");
    }


public str _(str tg, str txt,  map[str, WProperty] m,  tuple[str key, str val] atts ... ) {
    for (att <- atts) m[tg]+=(att.key:att.val);
    return transform(tg, txt, m);
    }    
    
public str aHref(str href, str txt,tuple[str key, str val] atts ...) {return _("a", txt, key2att, atts+<"href", href>);}

public str aId(str id, str txt) {return _("a", txt, key2att, atts+<"id", id>);}

public str p(str txt,tuple[str key, str val] atts ... ) {return _("p", txt, key2att,atts);}

public str h1(str txt,tuple[str key, str val] atts ...) {return _("h1", txt, key2att,atts);}

public str h2(str txt,tuple[str key, str val] atts ...) {return _("h2", txt,key2att,atts);}

public str h3(str txt,tuple[str key, str val] atts ...) {return _("h3", txt ,key2att,atts);}

public str h4(str txt,tuple[str key, str val] atts ...) {return _("h4", txt ,key2att,atts);}

public str span(str txt,tuple[str key, str val] atts ...) {return _("span", txt, key2att,atts);}

public str spanId(str id, str txt,tuple[str key, str val] atts ...) {return _("span", txt, key2att, atts+<"id", id>);}

public str spanClass(str id, str txt,tuple[str key, str val] atts ...) {return _("span", txt, key2att, atts+<"id", id>);}

public str div(str txt,tuple[str key, str val] atts ...) {return _("div", txt, key2att,atts);}

public str divId(str id, str txt,tuple[str key, str val] atts ...) {return _("div", txt, key2att, atts+<"id", id>);}

public str divClass(str id, str txt,tuple[str key, str val] atts ...) {return _("div", txt, key2att, atts+<"class", id>);}



public str body (str txt,tuple[str key, str val] atts ...) {return _("body", txt, key2att,atts);}

public str head (str txt,tuple[str key, str val] atts ...) {return _("head", txt,  key2att,atts);}

public str title (str txt,tuple[str key, str val] atts ...) {return _("title", txt, key2att,atts);}

public str iframeId(str id, str fname, str width, str height) {
	return _("iframe", key2att, atts+[<"src", fname>, <"id", id>, <"width",width>, <"height", height>]);
}

public str img(str fname, str alt,tuple[str key, str val] atts ...) {
	return _("iframe", key2att, atts+[<"src", fname>, <"alt",alt>]);
}

public str imgId(str id, str fname, str alt,tuple[str key, str val] atts ...) {
	return _("iframe", key2att, atts+<"src", fname>, <"id", id>, <"alt",alt>);
}

public str imgClass(str id, str fname, str alt,tuple[str key, str val] atts ...) {
	return _("iframe", key2att, atts+<"src", fname>, <"class", id>, <"alt",alt>);
}

public str table(str txt,tuple[str key, str val] atts ...) {return _("table", txt, key2att,atts);}

public str tbody(str txt,tuple[str key, str val] atts ...) {return _("tbody", txt, key2att,atts);}

public str thead(str txt,tuple[str key, str val] atts ...) {return _("thead", txt, key2att,atts);}

public str tfoot(str txt,tuple[str key, str val] atts ...) {return _("tfoot", txt, key2att,atts);}

public str tableId(str id, str txt,tuple[str key, str val] atts ...) {return _("table", txt, key2att, atts+<"id", id>);}

public str tableClass(str id, str txt,tuple[str key, str val] atts ...) {return _("table", txt, key2att, atts+<"class", id>);}

public str tableScrollableClass(str id1, str id2, str height, str txt,tuple[str key, str val] atts ...){
  return divClass(id1, tableClass(id2, txt, atts), <"style", "height:<height>; overflow:auto;">);
  }

public str tr(str txt,tuple[str key, str val] atts ...) {return _("tr", txt, key2att,atts);}

public str th(str txt,tuple[str key, str val] atts ...) {return _("th", txt, key2att,atts);}

public str thClass(str id, str txt,tuple[str key, str val] atts ...) {return _("th", txt, key2att, atts+<"class", id>);}

public str thId(str id, str txt,tuple[str key, str val] atts ...) {return _("th", txt, key2att, atts+<"id", id>);}

public str td(str txt,tuple[str key, str val] atts ...){return _("td", txt, key2att,atts);}

public str tdId(str id, str txt,tuple[str key, str val] atts ...){
  return _("td", txt, key2att, atts+<"id", id>);}

public str tdClass(str id, str txt,tuple[str key, str val] atts ...){
  return _("td", txt, key2att,  atts+<"class", id>);
}
public str caption(str txt,tuple[str key, str val] atts ...) {return _("caption", txt, key2att,atts);}

public str captionClass(str id, str txt,tuple[str key, str val] atts ...) {return _("caption", txt, key2att, atts+<"class", id>);}

public str preClass(str id, str txt,tuple[str key, str val] atts ...){
  return _("pre", txt, key2att, atts+<"class", id>);
}

public str preId(str id, str txt,tuple[str key, str val] atts ...){
  return _("pre", txt, key2att, atts+<"id", id>);
}





 