module www::Scrabble
import Prelude;
import www::XmlWrite;
import www::XmlColor;
import dotplugin::Display;

str siz = "25px";

bool isW3(int v) {
     return v==0 || v == 7 || v == 14
                 || v ==105 || v== 119 
                 || v == 210 || v == 217 || v == 224;
    }
    
bool isW2(int v) {
   int k = v/15;
   return (1<=k && k<=4 && (v==k*15+k || v==(k+1)*15-(k+1)))
    ||    (10<=k && k<=13 && (v == k*15+(14-k)
                   || v ==  (k+1)*15-(14-(k-1)))) || v== 112;
    }
    
bool isL3(int v) {
     return v == 76 || v == 80  || v == 84 || v == 88 ||
            v ==136 || v == 140 || v == 144|| v ==148 ||
            v == 200|| v == 204 || v == 20 || v == 24;
    }
    
bool isL2(int v) {
     list[int] w = [3,11,36,38,45,52,59,92,96,98,102,
     108,116,122,126,128,132,165,172,179,186,188,213,221];
     return v in w;
    }
    
str getColor(int v) {
   if (isW3(v)) return "w3";
   if (isW2(v)) return "w2";
   if (isL3(v)) return "l3";
   if (isL2(v)) return "l2";
   return "default";
   }               

str entries() {
    list[str] v = [getColor(i)
          |int i <-[0,1..225]];
    str r = "";
    for (d<-[0..15]) {
         w =  v[d*15..d*15+15];
         r +=tr("<for(x<-w){><tdClass("cell", divClass(x,""))> <}>");
         }
    return r;
    }
    
str board() {
    return tableClass("mainTable", captionClass("bigheader", "S C R A B B L E")+tbody(entries()));
    }

public void main()  {
    tag2att += (
            ".mainTable":("border":"none", "background-color":"grey","border-collapse":"collapse")         
            );
    tag2att += (".cell":("width":siz,"height":siz,"border":"1px groove lightgrey", "padding":"0"));
    tag2att += (".w3":("width":siz,"height":siz, "background-color":"red"));
    tag2att += (".w2":("width":siz,"height":siz, "background-color":"pink"));
    tag2att += (".l3":("width":siz,"height":siz, "background-color":"blue"));
    tag2att += (".l2":("width":siz,"height":siz, "background-color":"lightskyblue"));
    tag2att += (".default":("width":siz,"height":siz, "background-color":"seashell"));
    tag2att += (".bigheader": 
                  ("background-color": "lighgrey", 
                   "border":"1px solid grey",
                   "height":"20px",
                    "text-align":"center")
                 );
    str m = board();
    str r = html(m);
    // println(r);
    // writeFile(|file:///ufs/bertl/aap.html|, r);
    htmlDisplay("dotplugin", "html", r);
    }