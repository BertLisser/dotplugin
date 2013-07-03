module www::Scrabble
import Prelude;
import www::HtmlWrite;
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
         r +=tr("<for(x<-w){><td(class(x), div(class("cell")))> <}>");
         }
    return r;
    }
    
str board() {
    return table(class("mainTable"),"cellspacing=0", tbody(entries()));
    }
    
str letterCode() {
    str r = h3(small("LETTER FREQUENCY"));
    str r1 = dl("<for(x<-[65..78]){><dt(small(stringChar(x)+"-"))> <dd(small("0"))> <}>");
    str r2 = dl("<for(x<-[78..91]){><dt(small(stringChar(x)+"-"))> <dd(small("0"))> <}>");
    return table(class("lettercode"), r+tr(td(r1), td(r2)));
    }
    
str game() {
    return table(class("gameBoard"), 
    thead(tr(th("","width=20"), th(class("upHeader"), "S C R A B B L E")))+
    tfoot(tr(th(""), th("S C R A B B L E")))+
    tbody(tr(td(letterCode(), td(board())+th(class("sideHeader"), "S C R A B B L E"),"style=vertical-align:top"))));
    }

public void main()  {
    S(".mainTable", "border:1px solid", "padding:1px");   
    S(".cell", "width:<siz>","height:<siz>","border:1px inset lightgrey", "padding:0");
    S(".w3", "background-color:red");
    S(".w2", "background-color:pink");
    S(".l3", "background-color:blue");
    S(".l2", "background-color:lightskyblue");
    S("small","font-size: 9px");
    S(".bigheader", "background-color:lighgrey", 
                   "border:1px solid grey",
                   "height:20px",
                   "text-align:center"
                 );
    S("td", "padding:0");
    S("dl",  "padding:0.5em","margin:0","width:20px");
    S("dt", "float: left", "clear: left", 
                "width:10px", "text-align:right"); 
    S("dd",    "margin:0");
    S(".gameBoard","border:1px solid black",  "background-color:seashell", "width:500px");
    S(".upHeader", "transform:rotate(180deg)",
                 "-ms-transform:rotate(180deg)", /* IE 9 */
                 "-webkit-transform: rotate(180deg)");
    S(".rotate", "transform:rotate(-90deg)",
                 "-ms-transform:rotate(-90deg)", /* IE 9 */
                 "-webkit-transform: rotate(-90deg)");
    S(".sideHeader", "width:1m", "letter-spacing: 5px",
                     "font-size: 18px",
                   "height:300px");  
    str m = table(tr(td(game())));
    str r = html(m);
    // println(r);
    // writeFile(|file:///ufs/bertl/html/aap.html|, r);
    htmlDisplay("dotplugin", "scrabble/index", r);
    }