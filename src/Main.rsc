module Main
import dotplugin::display::Display;
// import Mies;
import IO;
// import lang::dot::Dot;
// import smt::Propositions;
// import smt::SatProp;
import lang::java::jdt::m3::Core;
import Relation;
import Set;
import lang::json::IO;

/*
Formula f = \and(
 \if(v("x"), v("y"))
, \if(\not(v("y")), \not(v("x")))
 //  ,\false()
);
*/
// public Z r;

public rel[loc,loc] getMethodsWorking(loc project)
{
        model = createM3FromEclipseProject(project);
        return { d | m <- methods(model), d <- model@declarations, m == d.name};        
}

/*
alias Z  = tuple[Z() a, Z() b];
    Z z = <Z() {println("a"); return z;},
           Z() {println("b"); return z;}>;
*/
// public Z f(Z z) { println(); return z;}
public rel[str, str] simplify(rel[loc,loc] a) {
      return {<x.file, y.file>  |<loc x, loc y> <- a};
      }

public map[str,set[str]] a = index(simplify(invert(getMethodsWorking(|project://dotplugin|))));

public list[map[str, value]] b = [("src":k,"#defs":size(a[k]))|k<-a];



public void main() {
   // z.a().z.b();
   println(b);
   writeTextJSonFile(|tmp:///aap.json|, b);  
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
