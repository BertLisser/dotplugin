module webdesign::DataChart

import Relation;
import Set;
import webdesign::D3;
import webdesign::Dimple;
import display::Display;

public tuple[int width, int height] svgDim = <590, 700>;

public tuple[int x, int y, int width, int height] chartBounds =
     <60, 30, 510, 400>;


public void drawChart(loc location,  str title, str x, str y, list[map[str, value]] dat) {
 str header  = Z(title_, (), title)+
 Z(script_,(src_: "http://d3js.org/d3.v3.min.js"))+
 Z(script_,(src_: "http:dimplejs.org/dist/dimple.v1.1.2.min.js"));
 str body =  Z(h1_, (id_: "header"), title) +
      JavaScript(var((svg_: expr(dimple.newSvg("body", svgDim.width, svgDim.height)))))+
      JavaScriptJson("data.json", "error", "dat",
        var(("myChart":expr("new <dimple.chart("svg", "dat")>")))
        ,
        expr(chart.setBounds("myChart", chartBounds.x, chartBounds.y, 
                                         chartBounds.width, chartBounds.height ))
        ,
        var(("x":expr(chart.addCategoryAxis("myChart", "x",x))))
        ,
        expr(axis.addOrderRule("x", x, "false"))
        ,
        expr(chart.addMeasureAxis("myChart", "y", y))
        ,
        expr(chart.addSeries("myChart", "",  dimple.plot.bar()))
        ,
        expr(chart.draw("myChart"))
        );
      // println(header);
      // println(body);
      htmlDisplay(location, html(
         header
    , body), dat);      
      }