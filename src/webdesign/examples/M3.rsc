module webdesign::examples::M3

import lang::java::jdt::m3::Core;
import lang::java::m3::TypeSymbol;
import Prelude;
import webdesign::BarChart;
import Relation;


public rel[loc,bool, loc] getMethodsWorking(loc project)
{
        model = createM3FromEclipseProject(project);
        rel[loc name, TypeSymbol typ] methodReturntype = { d| m <- methods(model), d<-model@types, m==d.name};
        rel[loc name, bool proc ] methodIsProc = 
           {<n, \void()==r >|<n, t> <- methodReturntype, \method(_,_, r,_):=t};
        rel[loc name, loc  src] methodSource=  {d | m <- methods(model), d <- model@declarations, m == d.name};  
        rel[loc name, bool proc, loc src] r = { <m1, b1, s2>   | <m1, b1><-methodIsProc, <m2, s2><-  methodSource, m1==m2 }; 
        return r; 
}

public rel[str, bool, str] simplify(rel[loc, bool, loc] a) {
      return {<name.file, proc, src.file>  |<loc name, bool proc, loc src> <- a};
      }

public rel[str,bool, str] a = simplify(getMethodsWorking(|project://dotplugin|));

public list[map[str, value]] b = [("proc":r[1], "src":r[2],"defs":r[0])|r<-a];

public void main() {
    println(simplify(getMethodsWorking(|project://dotplugin|)));
    drawBarChart(|project://dotplugin/src/m3|,  "First example", "src", "defs", b, "proc");
    }

/*
expr(chart.addSeries("myChart", "Channel",  dimple.plot.bar()))
        ,
        expr(chart.addLegend("myChart", 60, 10, 510, 20, "right"))
        ,
*/

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
