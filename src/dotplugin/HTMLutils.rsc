@license{
  Copyright (c) 2009-2013 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Paul Klint - Paul.Klint@cwi.nl - CWI}

module dotplugin::HTMLutils


import List;
import DateTime;

alias JsProp=tuple[str, str];

alias JsProps=list[tuple[str, str]];

public str html(str head, str body) {
	return "\<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"
            '  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"\>
            '  \<html xmlns=\"http://www.w3.org/1999/xhtml\"\>
            '
            '
            '<head>\n<body>\n\</html\>"
           ;
}

public str head(str txt) {
  return "\n\<head\><txt>\n\</head\>";
}
public str title(str txt) {
  return "\n\<title\><txt>\</title\>\n";
}

public str meta(str name, str content){
   return "\n\<meta name=\"<name>\" content=\"<content>\"\>\n";
}

public str body(str txt) {
  return "\<body\>\n<txt>\n\</body\>";
}

public str h(int level, str txt) {
  return "\<h<level>\><txt>\</h<level>\>\n";
}

public str h1(str txt) {
  return h(1,txt);
}

public str h2(str txt) {
  return h(2, txt);
}

public str h3(str txt) {
  return h(3, txt);
}

public str hr(){
  return "\<hr\>\n";
}

public str p(str txt){
  return "\<p\><txt>\</p\>\n";
}

public str b(str txt){
  return "\<b\><txt>\</b\>";
}

public str i(str txt){
  return "\<i\><txt>\</i\>";
}

public str img(str src, str alt) {
  return "\<img src=\"<src>\" alt=\"<alt>\"/\>";
 }

public str tt(str txt){
  return "\<tt\><txt>\</tt\>";
}

public str code(str txt){
  return "\<code\><txt>\</code\>";
}

public str blockquote(str txt){
  return "\<blockquote\><txt>\</blockquote\>";
}

public str br(){
  return "\<br/\>\n";
}

public str font(str color, str txt){
  return "\<font color=\"<color>\"\><txt>\</font\>";
}

public str li(str txt){
  return "\<li\><txt>\</li\>\n";
}

public str sub(str txt){
return "\<sub\><txt>\</sub\>";
}

public str sup(str txt){
return "\<sup\><txt>\</sup\>";
}

public str ul(str txt){
  return "\<ul\><txt>\</ul\>";
}

public str ol(str txt){
  return "\<ol\><txt>\</ol\>";
}

public str td(str txt){
  return td(txt, "left");
}

public str tdId(str id, str txt){
  return "\<td id=\"<id>\"\><txt>\</td\>";
}

public str td(str txt, str align){
  return "\<td align=\"<align>\"\><txt>\</td\>";
}

public str tr(str txt){
  return "\<tr\><txt>\</tr\>";
}

public str table(str txt){
  return "\<table\><txt>\</table\>";
}

public str tableId(str id, str txt){
  return "\<table id=\"<id>\"\><txt>\</table\>";
}

public str tableClass(str class, str txt){
  return "\<table class=\"<class>\"\><txt>\</table\>";
}

public str tableScrollableClass(str height, str class, str txt){
  return "\<div class=\"<class>\" style=\"height:<height>;overflow:auto;\"\>\<table\><txt>\</table\>\</div\>";
}

public str th(str txt, str align){
  return "\<th align=\"<align>\"\><txt>\</th\>";
}

public str col(str align){
  return "\<col align=\"<align>\" /\>";
}

public str pre(str class, str txt){
  return "\<pre class=\"<class>\"\><txt>\</pre\>";
}

public str sectionHead(str txt){
  return "\<span class=\"sectionHead\"\><txt>\</span\>";
}

public str inlineError(str txt){
  return "\<span class=\"inlineError\"\><txt>\</span\>";
}

public str div(str id, str txt){
	return "\n\<div id=\"<id>\"\>\n<txt>\n\</div\>\n";
}

public str div(str id, str class, str txt){
	return "\n\<div id=\"<id>\" class=\"<class>\"\>\n<txt>\n\</div\>\n";
}

public str span(str class, str src) {
	return "\<span class=\"<class>\"\><src>\</span\>";
}

public str spanId(str id, str src) {
	return "\<span id=\"<id>\"\><src>\</span\>";
}

public str ahref(str href, str txt) {
	return "\<a href=\"<href>\" \><txt>\</a\>";
}

public str ahref(str id, str href, str txt) {
	return "\<a id=\"<id>\" name=\"<id>\" href=\"<href>\" \><txt>\</a\>";
}

public str ahrefTarget(str id, str href, str target, str txt) {
	return "\<a id=\"<id>\" name=\"<id>\" href=\"<href>\" target=\"<target>\"\><txt>\</a\>";
}


public str ahrefIdOnclick(str id, str onclick, str txt) {
	return "\<a id=\"<id>\" name=\"<id>\" href=\"javascript:;\" onclick=\"return <onclick>;\"\><txt>\</a\>";
}

public str ahref(str id, str class, str href, str txt) {
	return "\<a id=\"<id>\" name=\"<id>\" class=\"<class>\" href=\"<href>\" \><txt>\</a\>";
}

public str iframe(str fname, str id, str width, str height) {
	return "\<iframe src=\"<fname>\" id=\"<id>\" width=\"<width>\" height=\"<height>\"\</iframe\>";
}

public str escapeForRascal(str input){
  return 
    visit(input){
      case /^\</ => "\\\<"
      case /^\>/ => "\\\>"
      case /^"/  => "\\\""
      case /^'/  => "\\\'"
      case /^\\/ => "\\\\"
    };
}

public str escapeForHtml(str txt){
  return
    visit(txt){
      case /^\</ => "&lt;"
      case /^\>/ => "&gt;"
      case /^"/ => "&quot;"
      case /^&/ => "&amp;"
    }
}

public str escapeForJavascript(str txt){
  return
    visit(txt){
      case /^"/ => "\\\""
      case /^'/ => "\\\'"
      case /^\\/ => "\\\\"
    };
}

public str htmlButton(str title, str onClick) {
    return "\<button type=\"button\" onclick = <onClick>\>"+
       "<escapeForHtml(title)>\</button\>";
    }
    
public str htmlButton(str name, str title, str onClick) {
    return "\<button type=\"button\" name=\"<name>\" onclick = <onClick>\>"+
       "<escapeForHtml(title)>\</button\>";
    }

public str jS(str txt) {
   return "\n\<script\><txt>\n\</script\>";
   }
   
public str jsFun(str name, str elem, str body) {
   return "\nfunction <name>()\n"+"{\n"+
   "var elm = document.getElementById(\"<elem>\");\n"+
   "<body>\n"+"}\n";  
   ;
   }
   
public str jsSet(str name, str elem, str tagg, JsProp prop) {
   return "\nfunction <name>()\n"+"{\n"+
   "var elm = document.getElementById(\"<elem>\").getElementsByTagName(\"<tagg>\");\n"+
   "for (var i=0;i\<elm.length;i++) {elm[i].setAttribute(\'<prop[0]>\', \'<prop[1]>\');}\n"+"}\n";  
   ;
   }
   
public str jsTextContent(str name, str elem, str txt) {
   return "\nfunction <name>(<elem>, <txt>)\n"+"{\n"+
   "var elm = document.getElementById(<elem>).getElementsByTagName(\"text\");\n"+
   "for (var i=0;i\<elm.length;i++) {elm[i].textContent=<txt>;}\n"+"}\n";  
   ;
   }




