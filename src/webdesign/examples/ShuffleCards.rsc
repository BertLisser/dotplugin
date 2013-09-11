module webdesign::examples::ShuffleCards
import Prelude;
import webdesign::Xml;
import webdesign::XmlColor;
import display::Display;


public void main()  {
     int width = 210; int height = 420;
     S(".cut ",  "border:1px solid","width:<width/3>px", "height:<height/4>px");
     S(".frame", "width:300%", "height:400%");
     S("img", "transform:matrix(0.5, 0, 0, 0.5, -200, -200)",
              "-ms-transform:matrix(0.5, 0, 0, 0.5, -200, -200)", 
              "-webkit-transform:translate(-33%, -38%)",
           "width:100%", "height:100%");
    // S(".main", "resize:both", "overflow:auto", "width:<(width*2)/3>px", "height:<height/4>px");
    str m =  h1("playing card")
    +p("Hallo"+div(class("main"), table(tr(td(
      div(class("cut"), div(class("frame"),img("src=9C.svg")))), 
      td(div(class("cut"), div(class("frame"), 
         img("src=KC.svg"))))))));
    str r = html(m);
    // println(r);
    // writeFile(|file:///ufs/bertl/html/aap.html|, r);
    htmlDisplay("dotplugin", "shufflecards/index", r);
 }