module webdesign::Dimple
import Prelude;
import webdesign::D3;
import display::Display;


tuple[str(str, int, int) newSvg, str(str, str) chart, tuple [str() bar] plot]  dimple = 
  < 
     str(str tg, int w, int h) {
        return "dimple.newSvg(\"<tg>\",<w>, <h>);"; 
        },
     str(str svg, str dat) {
        return "dimple.chart(<svg>, <dat>)";
        },
     <str() {return "dimple.plot.bar";}>
  >;
  

  
tuple[str(str, str, str) addCategoryAxis , str(str,str, str) addMeasureAxis, str(str, str, str) addSeries, str(str) draw] chart=
<
str(str chart, str position, str field) {return "<chart>.addCategoryAxis(\"<position>\",\"<field>\")";},
str(str chart, str position, str measure) {return "<chart>.addMeasureAxis(\"<position>\",\"<measure>\")";},
str(str chart, str field, str plotFunction){return "<chart>.addSeries(<field>, <plotFunction>)";},
str(str chart) {return "<chart>.draw()";}
>;


// data Dimple = newSVG(str tg, int width, int height)| chart(str svg, str dat);

// data Chart = add
public void main() {
 str header  = Z(title_, (), "Dimple")+
 Z(script_,(src_: "http://d3js.org/d3.v3.min.js"))+
 Z(script_,(src_: "http:dimplejs.org/dist/dimple.v1.1.2.min.js"))
 ;
 str body =  Z(h1_, (id_: "header"), "Dimple") +
  Z(script_,  
    toString(program([
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
        expr(chart.addSeries("chart", "null", dimple.plot.bar()))
        ,
        expr(chart.draw("chart"))
        ])));
      println(header);
      println(body);
      htmlDisplay("dotplugin", "dimple/index", html(
         header
    , body));
    }