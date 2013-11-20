module webdesign::examples::Napoleon
import Prelude;
import webdesign::Xml2;
import webdesign::XmlColor;
import display::Display;
import util::Math;

num e(list[num] matrix, int i, int j) = matrix[((2*i)/2)*2 + j%2];

data Corner = X(list[num] a, list[num] b, list[num] c);

data Pos = ab()|ac()|bc();
   

list[num] m(list[num] matrix, list[num] v) =  [e(matrix, 0, 0)*v[0]
+e(matrix, 0, 1)*v[1],  e(matrix, 1, 0)*v[0]
+e(matrix, 1, 1)*v[1]];

list[num] m(list[num] matrix, list[num] v, num x, num y, num d) {
    list[num] r = m(matrix, v);
    return [d*r[0]+x, d*r[1]+y];
}
 
list[num] center(num xa, num ya, num xb, num yb, list[num] xC)=
  [(xa+xb+xC[0])/3, (ya+yb+xC[1])/3];
  
Corner turn(Corner q, Pos p) {
   if (X(list[num] a, list[num] b, list[num] c):= q) {
   num x = c[0];
   num y = c[1];
   num d = sqrt(x*x+y*y);
   num x1 = (b[0]-c[0]);
   num y1 = (b[1]-c[1]);
   num d1 = sqrt(x1*x1+y1*y1);
   num cosx = round(x/d, 0.00001);
   num siny = round(y/d, 0.00001);
   num cosx1 = round(x1/d1, 0.00001);
   num siny1 = round(y1/d1, 0.00001);
   list[num] R = [cosx, siny, -siny, cosx];
   list[num] R1 = [cosx1, siny1, -siny1, cosx1];
   list[num] xA = [0, 0];
   list[num] xB = m(R, c);
   list[num] xC = m(R, b);
   a[0] -= b[0];
   c[0] -= b[0];
   list[num] xA1 = m(R1, c);
   list[num] xC1 = m(R1, a);
   xC1[0] -= xA1[0];
   list[num] xB1 = [-xA1[0], 0];
   xA1[0] -= xA1[0];  
   //println("xB:<xB>");
   // println("xB1:<xB1>");
     switch (p) {
         case ab(): return q;
         case ac(): return X(xA, xB, xC);
         case bc(): return X(xA1, xB1, xC1);
         }
       }
    return X([0,0],[0,0],[0,0]);
    }

str triangle(num xa, num ya, num xb, num yb,
num xc, num yc, str color) {
 
 list[num] nA = [];
 
 
 str makeNapoleon() {
     return Z(path, (id:"b",d_:"M <nA[0]> <nA[1]> L <nA[2]> <nA[3]> L <nA[4]> <nA[5]>L <nA[0]> <nA[1]>"));
     }
     
 list[num] base(num xa, num ya, num xb, num yb, num phi, num ac) {
   num x = xb-xa;
   num y = yb-ya;
   num d = sqrt(x*x+y*y);
   num cosx = round(x/d, 0.00001);
   num siny = round(y/d, 0.00001);
   list[num] R = [cosx, -siny, siny, cosx];
   list[num] xA = [xa, ya];
   list[num] xB = m(R, [1, 0], xa, ya, d);
   list[num] T = [cos(phi), ac*sin(phi)];
   list[num] xC = m(R, T, xa, ya, d);
   return xC;
   }
   
 list[num] base(num xa, num ya, num xb, num yb, Corner q, bool mirror) {
  if (X(list[num] a, list[num] b, list[num] c):= q) {
    num x = xb-xa;
    num y = yb-ya;
     num d = sqrt(x*x+y*y);
     num cosx = round(x/d, 0.00001);
     num siny = round(y/d, 0.00001);
     list[num] R = [cosx, -siny, siny, cosx];
     if (mirror) c[1] = -c[1];
     list[num] xC = m(R, c, xa, ya, 1);
     return xC;
   }
   return [0,0];
   }
 
str drawTriangle(num xa, num ya, num xb, num yb,list[num] xC) {
   str r=Z(path, (id:"a", d_:"M <xa> <ya> L <xC[0]> <xC[1]> L <xb> <yb>"
       ));
   list[num] c = center(xa, ya, xb, yb, xC);
   r+= Z(circle, (r_:"2", cx:"<c[0]>",
                           cy:"<c[1]>"));   
   return r;
   } 
   
 str equi(num xa, num ya, num xb, num yb,  Pos pos, Corner p, Corner p1, bool mirror) {
   list[num] xC = base(xa, ya, xb, yb, PI()/3, mirror?(-1):1);
   // println(xC);
    str r= drawTriangle(xa, ya, xb, yb, xC);
    list[num] c = center(xa, ya, xb, yb, xC);
    nA+= c;
    //r+= Z(circle, (r_:"2", cx:"<c[0]>",
    //                       cy:"<c[1]>"));                       
    list[num] b1 = base(xa, ya, xC[0], xC[1], p, pos==ab()|| pos==ac());
    str coord1 = "<xa> <ya>, <xC[0]> <xC[1]>, <b1[0]>, <b1[1]>";
    // println(coord1);
    r+= Z(polygon, 
           (fill:"<color>",
            stroke:"black", stroke_width:"1px" ,
            points:"<coord1>"
           ));
    list[num] xC1 = base(xa, ya, b1[0], b1[1], PI()/3, mirror?(-1):1);
   // println(xC);
    r += drawTriangle(xa, ya, b1[0], b1[1], xC1);
    
    list[num] b2 = base(xb, yb, xC[0], xC[1], p1, pos==bc());
    str coord2 = "<xb> <yb>, <xC[0]> <xC[1]>, <b2[0]>, <b2[1]>";
    // println(coord1);
    r+= Z(polygon, 
           (fill:"<color>",
            stroke:"black", stroke_width:"1px" ,
            points:"<coord2>"
           ));
           
    list[num] xC2 = base(xb, yb, b2[0], b2[1], PI()/3, !mirror?(-1):1);
   // println(xC);
    r += drawTriangle(xb, yb, b2[0], b2[1], xC2);
    return r;
    }
 
 Corner standardBase(num xa, num ya, num xb, num yb, bool mirror) {
    list[num] c =  base(xa, ya, xb, yb, PI()/5, mirror?(-0.5):0.5);
    num x = xb-xa;
    num y = yb-ya;
    num d = sqrt(x*x+y*y);
    num cosx = round(x/d, 0.00001);
    num siny = round(y/d, 0.00001);
    list[num] R = [cosx, siny, -siny, cosx];
    list[num] xA = [0, 0];
    list[num] xB = m(R, [xb-xa, yb-ya], 0, 0, 1); 
    list[num] xC = m(R, [c[0]-xa , c[1]-ya] , 0, 0, 1);  
    println("standardBase: <xA> <xB>");
    return X(xA, xB , xC);
    }
    
   
  
   list[num] standard(num xa, num ya, num xb, num yb, bool mirror) {
      return base(xa, ya, xb, yb, PI()/5, mirror?(-0.5):0.5);
   }
   
    Corner reflect(Corner q) {
        if (X(list[num] a, list[num] b, list[num] c):= q) {
            num x = (a[0] + b[0])-c[0];
            println("a=<a> b=<b> c=<c>");
            return X(a, b, [x, c[1]]);
            } 
        return X([0,0], [0,0], [0,0]);     
        }
   
    list[num] xC = standard(xa, ya, xb, yb, false);
    Corner BC = turn(standardBase(xa, ya, xb, yb, false),bc()) ;
    Corner AC = turn(standardBase(xa, ya, xb, yb, false),ac()) ;
    Corner AB = turn(standardBase(xa, ya, xb, yb, false),ab()) ;
    Corner BC1 = reflect(turn(standardBase(xa, ya, xb, yb, false),bc()));
    Corner AC1 = reflect(turn(standardBase(xa, ya, xb, yb, false),ac()));
    Corner AB1 = reflect(turn(standardBase(xa, ya, xb, yb, false),ab()));
      num xc = xC[0];
      num yc = xC[1];
      str coord = "<xa> <ya>, <xb> <yb>, <xc> <yc>";
      str r =  Z(polygon, 
           (fill:"<color>",
            stroke:"black", stroke_width:"1px" ,
            points:"<coord>"
           )) 
              +equi(xa, ya, xb, yb,  ab(), AB1, AB, true)
              +equi(xb, yb, xc, yc,  bc(), BC, BC1, true)
              +equi(xa, ya, xc, yc,  ac(), AC1 , AC, false)
              // +makeNapoleon()
          ;
       /*
       if (X(list[num] a, list[num] b, list[num] c):= q) {
          str coord1 = "<a[0]+100> <a[1]+100>, <b[0]+100> <b[1]+100>, <c[0]+100> <c[1]+100>";
          r+= Z(polygon, 
           (fill:"<color>",
            stroke:"black", stroke_width:"1px" ,
            points:"<coord1>"
           ));
       */
       return r;
    }
    
public void main() {
    int x = 50, y = 50;
    r = Z(svg, (width:"400", height:"400",id:"panel"),  triangle(50+x, 50+y, 135+x, 75+y, 125+x, 150+y, "pink"));   
    htmlDisplay("dotplugin", "napoleon/index", html(
         toCss((
            "#panel":(border:"5px groove"), 
            "path": (fill:"floralwhite", stroke:"black"), 
             "#b":(stroke:"darkblue",stroke_width:"1.0", fill:"none")
             ))
    , r));
}