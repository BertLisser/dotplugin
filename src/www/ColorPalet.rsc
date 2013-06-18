module www::ColorPalet
import Prelude;
import www::XmlWrite;
import www::XmlColor;
import dotplugin::Display;
 

str tcolorBody(int from, int n) {
    int to = from+n;
    if (to>size(colorNames)) to = size(colorNames);
    list[str] v = colorNames[from..to];
    return "<for(x<-v){><tdId(x, "",<"class","entry">)> <}>";
    }
    
str tcolorHead(int from, int n) {
    int to = from+n;
    if (to>size(colorNames)) to = size(colorNames);
    list[str] v = colorNames[from..to];
    return "<for(x<-v){><thClass("header", divClass("width",x))> <}>";
    }
    
str tcolorEntry(int from, int n) {
    return thead(tr(tcolorHead(from,n)))+tcolorBody(from,n);
    }
    
str tcolorTable(int from, int n) {
    return table(captionClass("bigheader", "Palets <from> to <from+n>")+tbody(tr(td(table(tcolorEntry(from, n))))));
    }
    
str tcolorTables() {
    str r = "";
    for (int k<-[0,5..size(colorNames)]) {
         r+= tr(td(tcolorTable(k, 5)));
         }
    return tableScrollableClass("scrollPane", "mainTable", "400px", r);
    }
    
public void main()  {
    tag2att += (
            ".mainTable":("border":"none", "border-collapse":"collapse"),  
            ".scrollPane":("border":"1px groove grey", "text-align":"right")
            );
    tag2att += (".width":("width":"200px"));
    tag2att += (".header":
     ("background-color": "antiquewhite", 
      "border":"1px solid grey",
      "height":"20px",
      "text-align":"center")
     );
     tag2att += (".entry":("border":"1px solid grey","height":"20px"));
     tag2att += (".bigheader": 
                  ("background-color": "white", 
                   "border":"1px solid grey",
                   "height":"20px",
                    "text-align":"center"
                  )
                 );
    for (x<-colors)  tag2att += ("td#<x>":("background-color": x)); 
    str m = tcolorTables();
    str r = html(m);
    // println(r);
    writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "html", r);
    }