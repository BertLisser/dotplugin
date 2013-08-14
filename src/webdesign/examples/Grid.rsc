module webdesign::examples::Grid
import Prelude;
import webdesign::Xml;
import webdesign::XmlColor;
import display::Display;
import util::Math;

int w = 500;
list[str] kleur = ["lightgray", "lightcyan", "lightblue"];

str vertical() {
     return "<for(i<-[0.0,PI()/6..2*PI()]){> M <i> -1  v 2 <}>";
     }
     
str frame() {
    return rect("x=\"0\"", "y=\"-1\"", "width=\"<2*PI()>\"", "height=\"2\"", "stroke=\"black\"",
        "fill=\"white\"", "stroke-width=\"<4.0/w>\"");
    }
    
str htext(int y, int s) {
    return text("x=\"0\"", "y=\"<y>\"","dy=\"0.10\"", "font-size=\"<0.25>\"", "text-anchor=\"end\"", "<s>");
    }
        
str vtext(num x, str s) {
    return text("x=\"<x>\"", "y=\"1\"", "dy=\"0.25\"", "font-size=\"<0.25>\"", "text-anchor=\"middle\"", "<s>");
    }

str outerFrame() {
    return rect("x=\"-0.4\"", "y=\"-1.4\"", "width=\"<2*PI()+0.8>\"", "height=\"2.8\"", "stroke=\"black\"",
        "fill=\"seashell\"", "stroke-width=\"<4.0/w>\"");
    }
    
str horizontal() {
     return "<for(i<-[-1.0, -0.75..1.0]){> M 0 <i>  h <2*PI()> <}>";
     }
     
str grid() {
    return outerFrame()+frame()+path("d=\"<vertical()+horizontal()>\"", 
    "stroke-width=\"<2.0/w>\"",
    "stroke=\"black\"")+ htext(0, 0)+htext(-1, 1)+htext(1, -1)+vtext(PI(), "&pi;");
    }


public void main()  {
    str m =svg("width=\"<w>\"", "height=\"<w/2>\"", "viewBox=\"-0.5 -1.5 <2*PI()+1.0> 3\"", 
    "preserveAspectRatio=\"xMinYMin meet\"",
         grid());
    str r = html(m);
    // println(r);
    writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "grid/index", r);
    }