module dotplugin::Svg
import lang::xml::DOM;
import Prelude;
import Real;

public void main() {
    str s = readFile(|project://MM-AiR/src/component.svg|);
    // println(getViewBox(s));
    /*
    Node N = parseXMLDOM(s);
    println(N); 
    if (document(element(_,"svg", list[Node] nsq)):=N) {
           list[str] ns = [siz|attribute(_,"viewBox", str siz)<-nsq];
           println(split(" ", head(ns)));
    }
    */
    str t = xmlPretty(updateViewBox(s));
    println(t);
  
    }
    
public tuple[int width,  int height] getViewBox(str s) {
    Node N = parseXMLDOM(s);
     if (document(element(_,"svg", list[Node] nsq)):=N) {
           list[str] ns = [siz|attribute(_,"viewBox", str siz)<-nsq];
           println(split(" ", head(ns)));
           list[int] r = [toInt(toReal(d))|d<-split(" ", head(ns))];
           return <r[2], r[3]>;
    }
    return <0,0>;
    }
    
public str updateViewBox(str s) {
    Node N = parseXMLDOM(s);
    if (document(element(q,"svg", list[Node] nsq)):=N) {
           list[str] ns = [siz|attribute(_,"viewBox", str siz)<-nsq];
           list[str] r = split(" ", head(ns));
           nsq=attribute("width", r[2])+nsq;
           nsq=attribute("height", r[3])+nsq;
           return xmlPretty(document(element(q,"svg", nsq)));
         }
    return xmlPretty(N);
    }
