module webdesign::Dimple
import Prelude;
import webdesign::D3;
import display::Display;


public tuple[str(str, int, int) newSvg, str(str, str) chart, tuple [str() bar] plot]  dimple = 
  < 
     str(str tg, int w, int h) {
        return "dimple.newSvg(\"<tg>\",<w>, <h>);"; 
        },
     str(str svg, str dat) {
        return "dimple.chart(<svg>, <dat>)";
        },
     <str() {return "dimple.plot.bar";}>
  >;
  

  
public tuple[
      str(str, list[value]) addCategoryAxis // (chart, position, field)
      , 
      str(str,list[value]) addMeasureAxis // (chart, position, field )
      , 
      str(str, value, str, list[value]) addSeries // (chart, categoryFields, plotFunction )
      , 
      str(str) draw // ()
      ,  
      str(str, int, int, int, int) setBounds
      ,
      str(str, int, int, int, int, str,  list[value]) addLegend  // (chart, x, y, width, height, 
         //  [horizontalAlign], [series]
      ]
chart=
<
// str(str chart, str position, value field) {return "<chart>.addCategoryAxis(\"<position>\",<val(field)>)";},
str(str chart, value e...) {return "<chart>.addCategoryAxis(<vals(e)>)";},
str(str chart, value e...) {return "<chart>.addMeasureAxis(<vals(e)>)";},
str(str chart, value fields, str plotFunction, value e...) {return "<chart>.addSeries(<val(fields)>, <plotFunction> <vals1(e)>)";},
str(str chart) {return "<chart>.draw()";},
str(str chart, int x, int y , int width, int height) {return 
     "<chart>.setBounds(<x>, <y>, <width>, <height>)";},
str(str chart, int x, int y , int width, int height, str align,  value e...) {
    if (isEmpty(align)) return "";
    return "<chart>.addLegend(<x>, <y>, <width>, <height>, <val(align)>  <vals1(e)>)";
    }    
>;

public tuple[str(str, str, str) addOrderRule] 
axis = 
<
str(str axis, str ordering, str desc) {return "<axis>.addOrderRule(\"<ordering>\",<desc>)";}
>;

str val(value field) {
      if (list[str] fields := field) {
           if (isEmpty(fields)) return "[]";
           str r="[";
           r += head(fields);
           for (f<-tail(fields)) r+= ",\"<f>\"";
           r += "]";
           return r;
       }
       if (expr(str f):= field) {
           return "<f>";
           }
       if (str f := field) {return isEmpty(f)?"null":"\"<f>\"";}
       return "<field>";
 }
 
str vals(list[value] fields) {
    if (isEmpty(fields)) return "";
    str r = val(head(fields));
    for (f<-tail(fields)) r+= ", <val(f)>";
    return r;
    }
    
str vals1(list[value] fields) {
    if (isEmpty(fields)) return "";
    str r="";
    for (f<-fields) r+= ", <val(f)>";
    return r;
    }

// data Dimple = newSVG(str tg, int width, int height)| chart(str svg, str dat);

// data Chart = add
public void main() {
 str header  = Z(title_, (), "Dimple")+
 Z(script_,(src_: "http://d3js.org/d3.v3.min.js"))+
 Z(script_,(src_: "http:dimplejs.org/dist/dimple.v1.1.2.min.js"))
 ;
 str body =  Z(h1_, (id_: "header"), "Dimple") +
  JavaScript(
        var((svg_: expr(dimple.newSvg("body", 800, 600))))
        ,
        var(("data":expr("[
              {\"Word\":\"Hello\", \"Awesomeness\":2000},
              {\"Word\":\"World\", \"Awesomeness\":3000}
             ]"
             )))
        ,
        var(("chart":expr("new <dimple.chart("svg", "data")>")))
        ,
        expr(chart.addCategoryAxis("chart","x","Word"))
        ,
        expr(chart.addMeasureAxis("chart","y", "Awesomeness"))
        ,
        expr(chart.addSeries("chart", "", "dimple.plot.bar"))
        ,
        expr(chart.draw("chart"))
        );
      println(header);
      println(body);
      htmlDisplay("dotplugin", "dimple/index", html(
         header
    , body));
    }