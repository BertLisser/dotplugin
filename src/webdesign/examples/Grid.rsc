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
     
str f() {
     real d = PI()/100;
     str s = "M 0 0 <for(x<-[d, 2*d ..2*PI()+d]){> L <x> <round(-sin(x), 0.001)><}>";
     return Path("d=\"<s>\"",  "stroke-width=\"<2.0/w>\"" ,"stroke=\"blue\"", "fill=\"none\"","f");
    }

str g() {
     real d = PI()/100;
     str s = "M 0 0 <for(x<-[d, 2*d ..2*PI()+d]){> L <x> <round(-cos(x), 0.001)><}>";
     return Path("d=\"<s>\"",  "stroke-width=\"<2.0/w>\"" ,"stroke=\"blue\"", "fill=\"none\"","g");
    } 
  
str grid() {
    return outerFrame()+frame()+path("d=\"<vertical()+horizontal()>\"", 
    "stroke-width=\"<2.0/w>\"",
    "stroke=\"black\"")+ htext(0, 0)+htext(-1, 1)+htext(1, -1)+vtext(PI(), "&pi;");
    
    }


str radio() {return  form(fieldset(
                ul(
                li(input("type=\"radio\"", "name=\"bord\"",  id("sin"), "onchange=\"drawFunction();\"")+
                label("for=\"sin\"", "sin"))+               
                li(
                input("type=\"radio\"", "name=\"bord\"",  id("cos"), "onchange=\"drawFunction();\"")+   
                label("for=\"cos\"", "cos")           
                ))));
                }

public void main()  {
     Js("drawFunction()","
       var radios = document.getElementsByTagName(\'input\');
       for (var i = 0; i \< radios.length; i++) {
        if (radios[i].type == \'radio\' && radios[i].checked) {
           drawF(radios[i].id);
        } 
        }     
    ");
    str m =svg(id("t"),"width=\"<w>\"", "height=\"<w/2>\"", "viewBox=\"-0.5 -1.5 <2*PI()+1.0> 3\"" 
         ,"preserveAspectRatio=\"xMinYMin meet\""
         , "onload=\"init(evt)\""
         , script(
                "\n<f()>\n"+
                "<g()>\n"+
                 "function init(evt){
                    svgDocument = evt.target.ownerDocument;
                    root = svgDocument.getElementById(\"t\");
                    parent.drawF= drawF;
                    current = f(svgDocument);
                    root.appendChild(current);
                 }
                 function  drawF(v) { 
                    if (v==\"sin\") {
                        var x  = f(svgDocument);
                        root.replaceChild(x, current);
                        current = x;
                        }
                    if (v==\"cos\") {
                        var x  = g(svgDocument);
                        root.replaceChild(x, current);
                        current = x;
                        }
                 }"
                 )
                 ,  grid());
    str r = html(table(tr(td(radio()))+tr(td(m))));
    // println(r);
    writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "grid/index", r);
    }