module webdesign::examples::M3

import lang::java::jdt::m3::Core;
import Prelude;
import webdesign::DataChart;
import Relation;



public rel[loc,loc] getMethodsWorking(loc project)
{
        model = createM3FromEclipseProject(project);
        return { d | m <- methods(model), d <- model@declarations, m == d.name};        
}

public rel[str, str] simplify(rel[loc,loc] a) {
      return {<x.file, y.file>  |<loc x, loc y> <- a};
      }

public map[str,set[str]] a = Relation::index(simplify(invert(getMethodsWorking(|project://dotplugin|))));

public list[map[str, value]] b = [("src":k,"#defs":size(a[k]))|k<-a];

public void main() {
    // println(b);
    drawChart(|project://dotplugin/src/m3|,  "First example", "src", "#defs", b);
    }




/*
public void main() {
   // z.a().z.b();
   println(b);
   str header  = Z(title_, (), "Dimple")+
 Z(script_,(src_: "http://d3js.org/d3.v3.min.js"))+
 Z(script_,(src_: "http:dimplejs.org/dist/dimple.v1.1.2.min.js"))
 ;
 str body =  Z(h1_, (id_: "header"), "M3") +
      JavaScript(var((svg_: expr(dimple.newSvg("body", 590, 700)))))+
      JavaScriptJson("index.json", "error", "dat",
        var(("myChart":expr("new <dimple.chart("svg", "dat")>")))
        ,
        expr(chart.setBounds("myChart", 60, 30, 510, 400))
        ,
        var(("x":expr(chart.addCategoryAxis("myChart", "x","src"))))
        ,
        expr(axis.addOrderRule("x", "src", "false"))
        ,
        expr(chart.addMeasureAxis("myChart", "y","#defs"))
        ,
        expr(chart.addSeries("myChart", "",  dimple.plot.bar()))
        ,
        expr(chart.draw("myChart"))
        );
      println(header);
      println(body);
      htmlDisplay(|project://dotplugin/src/dimple/index|, html(
         header
    , body), b);      
}
*/
