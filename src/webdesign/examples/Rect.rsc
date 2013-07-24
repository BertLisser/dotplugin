module webdesign::examples::Rect
import Prelude;
import webdesign::Xml;
import webdesign::XmlColor;
import display::Display;



public void main()  {
    str w = "25px";
    S(".main", "width:<w>", "height:<w>");
    S(".rect",  "border:1px solid", "fill:black","stroke:black");
    S("tr","valign: Center");
    str m = "";
    m+=table("cellspacing=10px", tr(
       td(strong("Taal is niet volmaakt. Hier zijn geen woorden voor.")),
       td(svg(class("main"),  
       rect(class("rect"), "width=\"<w>\"", "height=\"<w>\"")))));
    m+=small(pre(code(
    "&lthtml&gt
         &lthead&gt&lt/head&gt
         &ltbody&gt&lttable cellspacing &eq \"10px\" &gt&lttr&gt
            &lttd&gt&ltstrong&gt
              Taal is niet volmaakt. Hier zijn geen woorden voor.
              &lt/strong&gt&lt/td&gt&lttd&gt
              &ltsvg&gt&ltrect width &eq\"25px\" height &eq \"25px\"&gt&lt/rect&gt&lt/svg&gt
              &lt/td&gt
         &lt/tr&gt&lt/table&gt&lt/body&gt
&lt/html&gt")));
     m+=em("Bert");
    str r = html(m);
    // println(r);
    writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "rect", r);
    }