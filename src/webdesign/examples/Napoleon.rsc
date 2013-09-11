module webdesign::examples::Napoleon
import Prelude;
import webdesign::Xml;
import webdesign::XmlColor;
import display::Display;
import util::Math;

num e(list[num] matrix, int i, int j) = matrix[((2*i)/2)*2 + j%2];
   

list[num] m(list[num] matrix, list[num] v) =  [e(matrix, 0, 0)*v[0]
+e(matrix, 0, 1)*v[1],  e(matrix, 1, 0)*v[0]
+e(matrix, 1, 1)*v[1]];

list[num] m(list[num] matrix, list[num] v, num x, num y, num d) {
    list[num] r = m(matrix, v);
    return [d*r[0]+x, d*r[1]+y];
}


   
list[num] center(list[num] xA, list[num] xB, list[num] xC)=
  [(xA[0]+xB[0]+xC[0])/3, (xA[1]+xB[1]+xC[1])/3];

str triangle(num xa, num ya, num xb, num yb,
num xc, num yc, str color) {
 
 list[num] nA = [];
 
 str makeNapoleon() {
     return path(id("b"),"d=\"M <nA[0]> <nA[1]> L <nA[2]> <nA[3]> L <nA[4]> <nA[5]>L <nA[0]> <nA[1]>\"");
     }
 
 str equi(num xa, num ya, num xb, num yb, bool mirror) {
     num x = xa-xb;
        num y = ya-yb;
   num d = sqrt(x*x+y*y);
   num cosx = round(x/d, 0.00001);
   num siny = round(y/d, 0.00001);
   list[num] R = [cosx, -siny, siny, cosx];
   list[num] xA = [xb, yb];
   list[num] xB = m(R, [1, 0], xb, yb, d);
   list[num] T = [0.5, ((mirror? (-0.5):0.5))*sqrt(3)];
   list[num] xC = m(R, T, xb, yb, d);
   
   r=path(id("a"),"d=\"M <xA[0]> <xA[1]> L <xC[0]> <xC[1]> L <xB[0]> <xB[1]>\""
       );
   list[num] c = center(xA, xB, xC);
   nA+= c;
   r+= circle("r=2", "cx=\"<c[0]>\"",
                      "cy=\"<c[1]>\""); 
   return r;
   }

    str coord = "<xa> <ya>, <xb> <yb>, <xc> <yc>";
    return polygon(
          "fill=\"<color>\"",
          "stroke=\"black\"", "stroke-width=\"1px\"" 
         , "points=\"<coord>\""
           ) + equi(xa, ya, xb, yb, false)+equi(xb, yb, xc, yc, false)+equi(xa, ya, xc, yc, true)
           +makeNapoleon();
}

public void main() {
    // setPrecision(3);
    S("#panel", "border:5px groove");
    S("path", "fill:floralwhite; stroke:black");
    S("#b", "stroke:darkblue;stroke-width:1.0;fill:none");
    // S("#a", "stroke-width:<1.0/d>px");
    //q = path(id("a"), "transform=\"scale(<d>) rotate(<180*arctan(y/x)/PI()>)\"" /*rotate(<90*arctan(y/x)/PI()>)*/, "d=\"M 0 0 L 0.5 <0.5*sqrt(3)> L 1 0\""
    //    );
    // l = path("d=\"M 0 0 L <x> <y>\"");
    // r = svg("width=\"400\"", "height=\"400\"",id("panel"),  l, q); 
    int x = 50, y = 50;
    r = svg("width=\"400\"", "height=\"400\"",id("panel"),  triangle(50+x, 50+y, 135+x, 75+y, 125+x, 150+y, "pink"));   
    htmlDisplay("dotplugin", "napoleon/index", html(r));
}