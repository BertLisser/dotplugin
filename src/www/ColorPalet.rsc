module www::ColorPalet
import Prelude;
import www::HtmlWrite;
import www::XmlColor;
import dotplugin::Display;


str colorList(int from, int n) {
    int to = from+n;
    if (to>size(colorNames)) to = size(colorNames);
    list[str] v = colorNames[from..to];
    return table(class("table"),"<for(x<-v){><tr(td(x)+td(div(class("entry"),id(x))))><}>");
    }
 
str colorTable() {
    int step = 40;
    int to = size(colorNames);
    return table(tr("<for(x<-[0,step..to]){><td(colorList(x, step))><}>"));
    }

    
public void main()  {
    for (x<-colors)  S(".entry#<x>","background-color:<x>"); 
    S(".entry", "width:40px", "height:20px");
    S(".key", "width:50px", "height:20px");
    S(".table", "border:1px groove");
    str m = colorTable();
    str r = html(m);
    println(r);
    // writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "html", r);
    }