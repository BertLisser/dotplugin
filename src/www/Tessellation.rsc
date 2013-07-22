module www::Tessellation
import Prelude;
import www::HtmlWrite;
import www::XmlColor;
import dotplugin::Display;
import util::Math;

str w = "600px";
real left = sin(PI()*1/3);
real d =  2*left;
num height = 50;
num width = height*(d/2);

str poly(num x, num y, str kleur) {
     return use(class(kleur), "xlink:href=\"#hex\"","x=\"<x>\"", 
       "y=\"<y>\"","width=\"<width>\"","height=\"<height>\""
       , "fill=\"<kleur>\""
       );
     }

str polyRow(num x, num y) {return "<for(i<-[0..10]){> <poly(x+i*width, y, (i%2==0?"red":"blue"))> <}>";}      

public void main()  {
    str coord = "<for(i<-[0..6]){> <round(sin(PI()*i/3), 0.01)> <round(cos(PI()*i/3), 0.01)>,<}>";
    println(coord);
    S(".main", "width:<w>", "height:<w>");
    S(".polygon",  "fill:green");
    S(".red","fill: none");
    S(".blue","fill: none");
    str m = "";    
    m+=svg("width=<w>", "height=<w>",  symbol(id("hex"), 
       //  "preserveAspectRatio=\"xMidyMid slice\"",
       "preserveAspectRatio=\"none\"",
       "viewBox = \"<-left> <-1.0> <d> <2>\"",
       polygon(
          // "fill=\"green\"",
          "stroke=\"black\"", "stroke-width=\"0.3\"" 
         , "points=\"<coord>\""))+polyRow(0, 0)+polyRow(width/2, height));
    str r = html(m);
    // println(r);
    writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "tessellation", r);
    }