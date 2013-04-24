module dotplugin::Display
import lang::dot::Dot;



@javaClass{dotplugin.DotDisplay}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(loc lc);


@javaClass{dotplugin.DotDisplay}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(str sr);

@javaClass{dotplugin.DotDisplay}
@reflect{Uses URI Resolver Registry}
public java void dotDisplay(str projName, str outName, str sr);

@javaClass{dotplugin.DotDisplay}
@reflect{Uses URI Resolver Registry}
public void dotDisplay(DotGraph g) {
    dotDisplay(toString(g));
}

@javaClass{dotplugin.DotDisplay}
@reflect{Uses URI Resolver Registry}
public void dotDisplay(str projName, DotGraph g) {
    dotDisplay(projName, g.id, toString(g));
}   