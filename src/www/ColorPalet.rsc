module www::ColorPalet
import Prelude;
import www::HtmlWrite;
import www::XmlColor;
import dotplugin::Display;


str colorList(int from, int n) {
    int to = from+n;
    if (to>size(colorNames)) to = size(colorNames);
    list[str] v = colorNames[from..to];
    return table(class("table"),"<for(x<-v){><tr(td(x)+td(button(class("entry"),id(x), 
                     "onClick=\"light(this.id)\"")))><}>");
    }
 
str colorTable() {
    int step = 40;
    int to = size(colorNames);
    return 
    table(tr(td(div(id("border"))))+ 
          tr(
           td(div(class("buttons"), table(tr("<for(x<-[0,step..to]){><td(colorList(x, step))><}>"))))+
           td(form(fieldset(
                   ul(
                   li(input("type=\"radio\"", "name=\"bord\"",  id("none"), "onchange=\"drawBorder();\"")+
                   label("for=\"none\"", "none"))+               
                   li(
                   input("type=\"radio\"", "name=\"bord\"",  id("dotted"), "onchange=\"drawBorder();\"")+   
                   label("for=\"dotted\"", "dotted")           
                   )+
                   li(
                   input("type=\"radio\"", "name=\"bord\"",  id("dashed"), "onchange=\"drawBorder();\"")+
                   label("for=\"dashed\"", "dashed")
                   )+
                   li(
                   input("type=\"radio\"", "name=\"bord\"",  id("solid"), "onchange=\"drawBorder();\"")+
                   label("for=\"solid\"", "solid")            
                   )+
                   li(
                   input("type=\"radio\"", "name=\"bord\"",  id("double"), "onchange=\"drawBorder();\"")+
                   label("for=\"double\"", "double")                 
                   )+
                   li(
                   input("type=\"radio\"", "name=\"bord\"",  id("groove"), "onchange=\"drawBorder();\"")+
                   label("for=\"groove\"", "groove")
                   )+
                   li(
                   input("type=\"radio\"", "name=\"bord\"",  id("ridge"), "onchange=\"drawBorder();\"")+
                   label("for=\"ridge\"", "ridge")          
                   )+
                   li(
                   input("type=\"radio\"", "name=\"bord\"",  id("inset"), "onchange=\"drawBorder();\"")+
                   label("for=\"inset\"", "inset")        
                   )+
                   li( 
                   input("type=\"radio\"", "name=\"bord\"",  id("outset"), "onchange=\"drawBorder();\"")+
                   label("for=\"outset\"", "outset")
                   )
                   ) ))
          )));
    }

    
public void main()  {
    for (x<-colors)  S(".entry#<x>","background-color:<x>"); 
    S(".entry", "width:40px", "height:20px");
    S(".key", "width:50px", "height:20px");
    S(".buttons", "width:400px", "height:300px","overflow:auto", "border:1px groove");
    S("#border", "width:200px", "height:50px", "border:1px solid");
    S("td", "vertical-align:top");
    S("ul", "list-style-type:none");
    Js("light(clicked_id)", "
    document.getElementById(\"border\").style.backgroundColor=clicked_id;
    ");
    Js("drawBorder()","
       var radios = document.getElementsByTagName(\'input\');
       for (var i = 0; i \< radios.length; i++) {
        if (radios[i].type == \'radio\' && radios[i].checked) {
        document.getElementById(\"border\").style.border=\"2px \"+radios[i].id;
        } 
        }     
    ");
    str m = colorTable();
    str r = html(m);
    // println(r);
    // writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "html", r);
    }