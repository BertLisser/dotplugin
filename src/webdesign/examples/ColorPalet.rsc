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
    return radioButton("choice", "drawBorder()", ["none", "dotted", "dashed", "solid","double","groove","ridge",
    "inset","outset"]);
    }
             
 
str colorTable() {
    int step = 20;
    int to = size(colorNames);
    return 
    table(tr(td(div(id("border"))))+ 
          tr(
           td(div(class("buttons"), table("cellspacing=1px",
            tr("<for(x<-[0,step..to]){><td(colorList(x, step))><}>"))))+
           td(borderForm())
           +td("
            '<svg("width=\"400\"", "height=\"400\"",id("panel"),
           "onload=\"init(evt)\"",
            "
            '<srcScript("init.js")>",
            "
            '<script("\nfunction init(evt){
                 ' initSVG(evt);
                 '  c = circle(svgDocument);
                 '  root.appendChild(c);
                 '}"
                 +"
                 ' <Circle("r=\"20\"", id("circle"), "circle")>"+   
               "
               'function drawCircle(evt) {     
               '  c.setAttribute(\"cx\",evt.clientX-curX-10);
               '  c.setAttribute(\"cy\",evt.clientY-curY);
               '  root.replaceChild(c,svgDocument.getElementById(\"circle\"));
               '}")>",          
           "onclick=\"drawCircle(evt)\"")>")
          ));
    }

    
public void main()  {
    for (x<-colors)  S(".entry#<x>","background-color:<x>"); 
    S(".entry", "width:20px", "height:20px");
    S(".key", "width:50px", "height:20px");
    S(".buttons", "width:150px", "height:250px","overflow:auto", "border:5px groove");
    S("#border", "width:150px", "height:50px", "border:1px solid");
    S("#panel", "border:5px groove");
    S("td", "vertical-align:top");
    S("ul", "list-style-type:none", "padding:0px");
    S("fieldset", "border:solid","padding:0px");
    S("form", "border:none");
    Js("light(clicked_id)", "
    document.getElementById(\"border\").style.backgroundColor=clicked_id;
    document.getElementById(\"circle\").setAttribute(\"fill\",clicked_id);
    ");
    // Js("drawCircle(evt)", "alert(evt.clientX)");
    Js("drawBorder()","
       var radios = document.getElementsByTagName(\'input\');
       for (var i = 0; i \< radios.length; i++) {
        if (radios[i].type == \'radio\' && radios[i].checked) {
        document.getElementById(\"border\").style.border=\"2px \"+radios[i].id;
        document.getElementById(\"circle\").setAttribute(\"stroke\",\"black\");
        } 
        }     
    ");
    str m = colorTable();
    str r = html(m);
    // println(r);
    // writeFile(|file:///ufs/bertl/aap.html|, r);
    initSVG("panel", |project://dotplugin/src/colorpalet/init.js|);
    htmlDisplay("dotplugin", "colorpalet/index", r);
    }