module webdesign::examples::Tessellation
import Prelude;
import webdesign::Xml;
import webdesign::XmlColor;
import display::Display;
import util::Math;

int w = 500;
num d =  sqrt(3);
list[str] kleur = ["lightgray", "lightcyan", "lightblue"];

str poly(num x, num y, str color) {
    str coord = 
    "<for(int i<-[0..6])
      {> <x+round(sin(PI()*i/3), 0.01)> <y+round(cos(PI()*i/3), 0.01)>,
     <}>";
    return polygon(
           "fill=\"<color>\"",
          "stroke=\"black\"", "stroke-width=\"0.01\"" 
         , "points=\"<coord>\"");
    
    }
 
str polyRow(num x, num y, int ofs, int n) {
    return "<for(int i<-[0..n])
    {> <poly(x+i*d, y, kleur[(ofs+2*i)%3])>
    <}>";
    }
    
str polyRows(int cols, int rows) {
    return "<for(int i<-[0..rows])
    {> <polyRow(0.5+i*d*0.5, 1.5*i, i%3, cols)>
    <}>";
    }

str define() {
        return symbol(id("hex"),
       "preserveAspectRatio=\"xMinYMin meet\"",
       "viewBox = \"<-1.2> <-1.2> <10*d> <4>\"",
        polyRows(6, 6));
    } 
    
str present() {
    return use("xlink:href=\"#hex\"","x=\"0\"", "y=\"0\"",
    "width=\"<w>\"","height=\"<w>\"");  
    }

public void main()  {
    str m =svg("width=\"<w>\"", "height=\"<w>\"",  
         define()+present());
    str r = html(m);
    // println(r);
    writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "tessellation/index", r);
    }