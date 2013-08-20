module webdesign::examples::ColorPalet
import Prelude;
import webdesign::Xml;
import webdesign::XmlColor;
import display::Display;


str colorList(int from, int n) {
    int to = from+n;
    if (to>size(colorNames)) to = size(colorNames);
    list[str] v = colorNames[from..to];
    return table("<for(x<-v){><tr(td(button("title=\"<x>\"", class("entry"),id(x), 
                     "onClick=\"light(this.id)\"")))><}>");
    }
    

str borderForm() {
    return radioButton("choice", "drawBorder()", ["none", "dotted", "dashed", "solid"]);
    /*
    return form(fieldset(
                   ul(
                   li(input("type=\"radio\"",   id("none"),"name=\"choice\"", "onchange=\"drawBorder();\"")
                   +label("for=\"none\"", "none")
                   )+               
                   li(
                   input("type=\"radio\"",   id("dotted"),"name=\"choice\"", "onchange=\"drawBorder();\"")+   
                   label("for=\"dotted\"", "dotted")           
                   )+
                   li(
                   input("type=\"radio\"",  id("dashed"),"name=\"choice\"", "onchange=\"drawBorder();\"")+
                   label("for=\"dashed\"", "dashed")
                   )+
                   li(
                   input("type=\"radio\"",   id("solid"),"name=\"choice\"", "onchange=\"drawBorder();\"")+
                   label("for=\"solid\"", "solid")            
                   )+
                   li(
                   input("type=\"radio\"",   id("double"),"name=\"choice\"", "onchange=\"drawBorder();\"")+
                   label("for=\"double\"", "double")                 
                   )+
                   li(
                   input("type=\"radio\"",   id("groove"),"name=\"choice\"", "onchange=\"drawBorder();\"")+
                   label("for=\"groove\"", "groove")
                   )+
                   li(
                   input("type=\"radio\"",  id("ridge"),"name=\"choice\"", "onchange=\"drawBorder();\"")+
                   label("for=\"ridge\"", "ridge")          
                   )+
                   li(
                   input("type=\"radio\"",  id("inset"),"name=\"choice\"", "onchange=\"drawBorder();\"")+
                   label("for=\"inset\"", "inset")        
                   )+
                   li( 
                   input("type=\"radio\"",   id("outset"),"name=\"choice\"", "onchange=\"drawBorder();\"")+
                   label("for=\"outset\"", "outset")
                   )
                   ) ));
                   */
                   }
                   
str radioButton(str name, str script, list[str] choices) {
                   return form(fieldset(ul("<for (c <- choices)
                   {> <li(input("type=\"radio\"", id(c), "name=\"<name>\"", "onchange=\"<script>\"")
                   +label("for=\"<c>\"", "<c>"))> <}>")));
                   }
 
str colorTable() {
    int step = 20;
    int to = size(colorNames);
    return 
    table(tr(td(div(id("border"))))+ 
          tr(
           td(div(class("buttons"), table("cellspacing=1px",
            tr("<for(x<-[0,step..to]){><td(colorList(x, step))><}>"))))+
           td(borderForm()
          )));
    }

    
public void main()  {
    for (x<-colors)  S(".entry#<x>","background-color:<x>"); 
    S(".entry", "width:20px", "height:20px");
    S(".key", "width:50px", "height:20px");
    S(".buttons", "width:150px", "height:250px","overflow:auto", "border:5px groove");
    S("#border", "width:150px", "height:50px", "border:1px solid");
    S("td", "vertical-align:top");
    S("ul", "list-style-type:none", "padding:0px");
    S("fieldset", "border:solid","padding:0px");
    S("form", "border:none");
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