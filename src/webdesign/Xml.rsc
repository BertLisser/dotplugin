@license{
  Copyright (c) 2009-2013 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Bert Lisser - Bert.Lisser@cwi.nl}
/* Don't use the symbol '=' in the text */
module webdesign::Xml
import Prelude;

public str tg = "tg"; // tag
public str name = "name";

alias WProperty = map[str key, str val];

public map[str, WProperty] key2att = (
   "a":(tg:"a"), 
   "body":(tg:"body"),
   "head":(tg:"head"),
   "title":(tg:"title"),
   "meta":(tg:"meta"),
   "script":(tg:"script"),
   "h1":(tg:"h1"), 
   "h2":(tg:"h2"),  
   "h3":(tg:"h3"), 
   "h4":(tg:"h4"),
   "img":(tg:"img"),
   "p":(tg:"p"), 
   "br":(tg:"br"), 
   "i":(tg:"i"),
   "b":(tg:"b"), 
   "tt":(tg:"tt"),
   "div":(tg:"div"),
   "span":(tg:"span"),
   "pre":(tg:"pre"), 
   "table":(tg:"table"),  
   "tr":(tg:"tr"),
   "td":(tg:"td"), 
   "th":(tg:"th"), 
   "thead":(tg:"thead"),
   "foot":(tg:"tfoot"),
   "tbody":(tg:"tbody"), 
   "tfoot":(tg:"tfoot"),
   "caption":(tg:"caption"),      
   "iframe":(tg:"iframe"),
   "samp":(tg:"samp"),
   "em":(tg:"em"), 
   "strong":(tg:"strong"), 
   "small":(tg:"small"), 
   "code":(tg:"code"),
   "kbd":(tg:"kbd"),
   "var":(tg:"var"),
   "li":(tg:"li"),
   "ol":(tg:"ol"), 
   "ul":(tg:"ul"), 
   "dl":(tg:"dl"), 
   "dt":(tg:"dt"),
   "dd":(tg:"dd"),
   "sub":(tg:"sub"),
   "sup":(tg:"sup"), 
   "button":(tg:"button"), 
   "form":(tg:"form"),
   "fieldset":(tg:"fieldset"),
   "label":(tg:"label"),
   "input":(tg:"input"),
   "svg":(tg:"svg"), 
   "circle":(tg:"circle"), 
   "ellipse":(tg:"ellipse"), 
   "rect":(tg:"rect"), 
   "line":(tg:"line"), 
   "polyline":(tg:"polyline"), 
   "polygon":(tg:"polygon"),
   "g":(tg:"g"),
   "use":(tg:"use"), 
   "defs":(tg:"defs"),
   "symbol":(tg:"symbol")      
   );
   
public str class(str s) {
  return "class=\"<s>\"";
  }

public str id(str s) {
  return "id=\"<s>\"";
  }   
   
public map[str , WProperty] tag2att = ();

public map[str , str] name2body = ();
   
   
public str toCSS() {
   str r = "\<style\>\n";
   for (x<-tag2att) {
       r+="<x>{<for(y<-tag2att[x]){><y>:<tag2att[x][y]>;\n<}>}\n";
       }
   r+="\</style\>\n";
   return r;
   }
 
   
public str toScript() {
   str r = "\<script\>\n";
   for (x<-name2body) {
       r+="function <x>{<name2body[x]>}\n";
       }
   r+="\</script\>\n";
   return r;
   }

private str _html(str head, str body) {
	return "\<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"
            '  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"\>
            '  \<html xmlns=\"http://www.w3.org/1999/xhtml\"\>
            '
            '
            '<head>\n<body>\n\</html\>"
           ;
}

public str html(str b) {
    return  _html(head(toScript()+toCSS()), body(b));
    }
    
public str html(str hd, str b) {
    return  _html(head(hd+toCSS()), body(b));
    }   
private bool or(bool b...) {
    for (bool x<-b) if (x) return true;
    return false;
    }

private str _(str key, map[str, WProperty] m, list[str] txt) {
    WProperty props = m[key];
    str key = props[tg];
    /* Cannot handle with ||  -- Bug in Rascal? */
    // Bug? list[str] content = [replaceAll(x, "&eq","=")| str x<-txt, or(contains(x,"\<"),!contains(x,"="))];
    list[str] content = [x| str x<-txt, or(contains(x,"\<"),!contains(x,"="))];
    list[str] atts = txt - content;
    str s = replaceAll("<for(x<-content){><x><}>", "&eq","=");
    return "\<<key><for(x<-props, x!=tg)
         {> <x>=\"<props[x]>\"<}> <for(x<-atts) {> <x><}>"
         +"\><s>\</<key>\>";
    }
 
public void S(str atts...) {
   str s = "<for(x<-atts, !contains(x,":")){><x><}>";
   WProperty v = (key:val| x<-atts, /<key:[\w\-\s]+>:<val:.+>/:=x);
   tag2att +=(s:v);
   }
   
public void Js(str name, str body) {
   name2body += (name:body);
   } 
   
public str a(str txt ...) {return _("a", key2att, txt);}

public str p(str txt... ) {return _("p", key2att, txt);}

public str br() {return _("br", key2att, []);}

public str meta() {return _("meta", key2att, []);}

public str h1(str txt...) {return _("h1", key2att, txt);}

public str h2(str txt...) {return _("h2", key2att, txt);}

public str h3(str txt...) {return _("h3", key2att, txt);}

public str h4(str txt...) {return _("h4", key2att, txt);}

public str span(str txt...) {return _("span", key2att, txt);}

public str div(str txt...) {return _("div", key2att, txt);}

public str body (str txt...) {return _("body", key2att, txt);}

public str head (str txt...) {return _("head", key2att, txt);}

public str script (str txt...) {return _("script", key2att, txt);}

public str title (str txt...) {return _("title", key2att, txt);}

public str iframe(str txt...) {return _("iframe", key2att, txt);}

public str img(str txt...) {return _("img", key2att, txt);}


public str table(str txt...) {return _("table", key2att, txt);}

public str tbody(str txt...) {return _("tbody", key2att, txt);}

public str thead(str txt...) {return _("thead", key2att, txt);}

public str tfoot(str txt...) {println("tfoot");return _("tfoot", key2att, txt);}

/*
public str tableScrollableClass(str id1, str id2, str height, str txt...){
  return divClass(id1, tableClass(id2, txt, atts), <"style", "height:<height>; overflow:auto;">);
  }
*/

public str tr(str txt...) {return _("tr", key2att, txt);}

public str th(str txt...) {return _("th", key2att, txt);}

public str td(str txt...){return _("td", key2att, txt);}

public str caption(str txt...) {return _("caption", key2att, txt);}

public str pre(str txt...){ return _("pre", key2att,  txt);}

public str code(str txt...){ return _("code",  key2att, txt);}

/*--------------------- Fonts ------------------------------------------ */
public str b(str txt...){return _("b", key2att, txt);}

public str i(str txt...){return _("i", key2att, txt);}

public str tt(str txt...){return _("tt", key2att, txt);}

public str em(str txt...){return _("em", key2att, txt);}

public str strong(str txt...){return _("strong", key2att, txt);}

public str small(str txt...){return _("small", key2att, txt);}

public str samp(str txt...){return _("samp", key2att, txt);}

public str kbd(str txt...){return _("kbd", key2att, txt);}

public str var(str txt...){return _("var", key2att, txt);}

/* -------------------------------------lists ---------------------------- */

public str li(str txt...){return _("li", key2att, txt);}

public str ul(str txt...){return _("ul", key2att, txt);}

public str ol(str txt...){
  return _("ol", key2att, txt);
}

public str dl(str txt...){return _("dl", key2att, txt);}

public str dt(str txt...){return _("dt", key2att, txt);}

public str dd(str txt...){return _("dd", key2att, txt);}

public str sub(str txt...){return _("sub", key2att, txt);}

public str sup(str txt...){return _("sup", key2att, txt);}




/* -------------------------------------------------------------------------- */

public str button(str txt...){return _("button", key2att, txt);}

public str form(str txt...){return _("form", key2att, txt);}

public str input(str txt...){return _("input", key2att, txt);}

public str fieldset(str txt...){return _("fieldset", key2att, txt);}

public str label(str txt...){return _("label", key2att, txt);}

/* --------------------------------------------------------------------------- */

public str svg(str txt...) {return _("svg", key2att, txt);}

public str rect(str txt...) {return _("rect", key2att, txt);}

public str line(str txt...) {return _("line", key2att, txt);}

public str circle(str txt...) {return _("circle", key2att, txt);}

public str ellipse(str txt...) {return _("ellipse", key2att, txt);}

public str polygon(str txt...) {return _("polygon", key2att, txt);}

public str polyline(str txt...) {return _("polyline", key2att, txt);}

public str g(str txt...) {return _("g", key2att, txt);}

public str use(str txt...) {return _("use", key2att, txt);}

public str defs(str txt...) {return _("defs", key2att, txt);}

public str symbol(str txt...) {return _("symbol", key2att, txt);}


