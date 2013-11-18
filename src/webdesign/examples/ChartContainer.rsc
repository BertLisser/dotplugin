module webdesign::examples::ChartContainer
import Prelude;
import webdesign::D3;
import webdesign::Dimple;
import display::Display;

public void main() {
 str header  = Z(title_, (), "Dimple")+
 Z(script_,(src_: "http://d3js.org/d3.v3.min.js"))+
 Z(script_,(src_: "http:dimplejs.org/dist/dimple.v1.1.2.min.js"))
 ;
 str body =  Z(h1_, (id_: "header"), "ChartContainer") +
      JavaScript(var((svg_: expr(dimple.newSvg("body", 590, 700)))))+
      JavaScriptTsv("example.tsv", "error", "dat",
        var(("myChart":expr("new <dimple.chart("svg", "dat")>")))
        ,
        expr(chart.setBounds("myChart", 60, 30, 510, 400))
        ,
        var(("x":expr(chart.addCategoryAxis("myChart", "x","Month"))))
        ,
        expr(axis.addOrderRule("x", "Date", "false"))
        ,
        expr(chart.addMeasureAxis("myChart", "y","Unit Sales"))
        ,
        expr(chart.addSeries("myChart", "Channel",  dimple.plot.bar()))
        ,
        expr(chart.addLegend("myChart", 60, 10, 510, 20, "right"))
        ,
        expr(chart.draw("myChart"))
        );
      println(header);
      println(body);
      htmlDisplay("dotplugin", "dimple/index", html(
         header
    , body));
 }