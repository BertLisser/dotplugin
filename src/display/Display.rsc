module display::Display
import lang::dot::Dot;



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