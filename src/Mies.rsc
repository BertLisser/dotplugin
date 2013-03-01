module Mies
import IO;
import Map;
import Set;
import String;
import lang::dot::Dot;

alias Block = set[str];
alias System = map[str, Block];
alias ReducedSystem = map[Block, Partition];
alias Partition = set[Block];

public System c = ("x":{"y", "u","w"}, "y":{"z","w"}, "z":{"x","w"}, "u":{"z","w"},"w":{});
public System z = ("x":{"y1", "y2", "s"}, "y":{"x1",  "s"}, "s":{},"y1":{"y"},"x1":{"x"}, "y2":{"y"});


Block next(System z, str x)  {return z[x];}

Block b2y(System z, Block b, Block y) {
    return {x| x<-b, !isEmpty(next(z, x)&y)};
    }
    
Partition split(System z, Partition p, Block y) {return {s|s <- {b2y(z,x, y) , x-b2y(z,x,y)|x<- p}, !isEmpty(s)};}

Partition split(System z, Partition p) {return (p|split(z, it, x)|x<-p);}

public Partition reduce(System z, Partition p) {
  solve (p) {
       p = split(z, p);
       println("a=<p>");
       }
   return p;
  }
  
public Partition computeP(System z) {
   Partition p = {domain(z)};
   return reduce(z, p);
   }
   
str name(Block b, str b1, str b2) {
   r = "<b1><for (str x<-b){><x>,<}>";
   return replaceLast(r,",",b2);
   }
   
str name(Block b) {
   return name(b,"\"{","}\"");
   }    

/*    
public System reduce(System z) {
   Partition p = computeP(z);
   map[str, Block] m = ();
   for (Block b<-p) m+=(x:b|str x<-b);
   System r = (name(m[getOneFrom(x)]):{name(m[y])|str y<-next(z, getOneFrom(x))}|Block x<-p);
   println("r=<r>");
   return r;
   }
 */

public ReducedSystem reduce(System z) {
   Partition p = computeP(z);
   map[str, Block] m = ();
   for (Block b<-p) m+=(x:b|str x<-b);
   ReducedSystem r = (m[getOneFrom(x)]:{m[y]|str y<-next(z, getOneFrom(x))}|Block x<-p);
   println("r=<r>");
   return r;
   } 
   
public Stm toDot(System t, int k) {
   Stms e =  [E(x , y) | str x<-domain(t), str y<-t[x]];
   Stm r = S("cluster<k>", e);
   return r;
   }
    
public Stm toDot(ReducedSystem t, int k) {
   Stms e =  [E(name(x), name(y)) | Block x<-domain(t), Block y<-t[x]];
   Stm r = S("cluster<k>", e);
   return r;
   }
   
public Stms connections(System s1, ReducedSystem s2) {
   Stms r =[];
   for (str x1<-domain(s1)) {
        for (Block x2<-domain(s2)) {
          if (x1 in x2) {r+= E(x1, name(x2), [<"style", "dashed">]);}
        }
   }
    return r;
   }
   
public DotGraph writeDot(System s1, ReducedSystem s2) {
   Stms r = [toDot(s1, 0), toDot(s2, 1)];
   r+=connections(s1, s2);
   r+=A("rank","top");
   return digraph("aap", r);
   }     

public void main() {
    reduce(z);
    }

// public DotGraph a = writeDot(s1, s2);

public str toDot() {
    System s1 =z;
    ReducedSystem s2 = reduce(z);
    return toDot(writeDot(s1, s2));
    } 
    
public DotGraph g = writeDot(z, reduce(z));
public DotGraph h = writeDot(c, reduce(c));