module dotplugin::Display
import lang::dot::Dot;



@javaClass{dotplugin.DotDisplay}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(loc lc);


@javaClass{dotplugin.DotDisplay}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(str sr);


public void dotDisplay(DotGraph g) {
    dotDisplay(toString(g));
}  