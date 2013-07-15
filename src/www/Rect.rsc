module www::Rect
import Prelude;
import www::HtmlWrite;
import www::XmlColor;
import dotplugin::Display;



public void main()  {
    S(".main", "width:400px", "height:400px");
    S(".rect", "width:100px", "height:50px", "border:1px solid", "fill:green","stroke:black");
    str m = h1("SVG demonstration");
    m+=svg(class("main"),  
       rect(class("rect"), "width=\"100px\"", "height=\"50px\""));
    str r = html(m);
    // println(r);
    // writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "rect", r);
    }