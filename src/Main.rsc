module Main
import dotplugin::Display;
import Mies;
import IO;
import lang::dot::Dot;
import smt::Propositions;
import smt::SatProp;

Formula f = \and(
 \if(v("x"), v("y"))
, \if(\not(v("y")), \not(v("x")))
 //  ,\false()
);

public void main() {
    // dotDisplay(|project://dotplugin/src/a.dot|);
    // writeFile(|file:///tmp/aap.dot|, toString(g));
    println("TEST:<findModel(["x", "y"], f, 10)>");
    dotDisplay(h);    
}
