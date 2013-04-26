module dotplugin::ReadSvg
import lang::xml::DOM;
import Prelude;

public void main() {
    str s = readFile(|project://dotplugin/src/graphviz2459750941624167733.svg|);
    Node N = parseXMLDOM(s);
    str t = xmlPretty(N);
    println(t);
    }
