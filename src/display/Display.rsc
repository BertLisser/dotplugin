module display::Display
import lang::dot::Dot;
import lang::json::IO;



@javaClass{display.Display}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(loc lc);


@javaClass{display.Display}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(str sr);

@javaClass{display.Display}
@reflect{Uses URI Resolver Registry}
public java str dotToSvg(str sr);

@javaClass{display.Display}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(str projName, str outName, str sr);

public void dotDisplay(DotGraph g) {
    dotDisplay(toString(g));
}

public void dotDisplay(str projName, DotGraph g) {
    dotDisplay(projName, g.id, toString(g));
} 

@javaClass{display.Display}
@reflect{Uses URI Resolver Registry}
public str dotToSvg(DotGraph g) {
    return dotToSvg(toString(g));
} 

@javaClass{display.Display}
@reflect{Uses URI Resolver Registry}
public java void htmlDisplay(str projName, str outName, str sr); 

@javaClass{display.Display}
@reflect{Uses URI Resolver Registry}
public java void htmlDisplay(loc location, str sr); 

public void htmlDisplay(loc location, str sr, list[map[str, value]] json) {
     writeTextJSonFile(location+"data.json", json);
     htmlDisplay(location+"index.html", sr);
     } 