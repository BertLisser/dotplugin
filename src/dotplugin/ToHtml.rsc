module dotplugin::ToHtml
import Prelude;
import www::HtmlWrite;
import util::Reflective;
import lang::rascal::grammar::definition::Modules;
import lang::rascal::grammar::definition::Productions;
import lang::rascal::\syntax::Rascal;
import Grammar;
import lang::box::util::Box;

//  G reference, D definition
data Box = G(str lab, list[Box])|D(str lab, list[Box]);

str width ="600px", height = "800px"; 

str content = "content";

public Tree rascal2ParseTree(loc l) {
    pt = annotateMathOps(parseModule(l).top, mathLiterals);	
    pt = annotateDefRef(pt);
	return pt;
}


private map[str,str] mathLiterals = (
		"o": 		"&circ;",
		"\>": 		"&gt;",
		"\<": 		"&lt;",
		"\>=": 		"&ge;",
		"\<=": 		"&le;",
		"\<-": 		"&larr;",
		"in": 		"&isin;",
		"*": 		"&times;",
		"&": 		"&cap;",
		"&&": 		"&and;",
		"||": 		"&or;",
		"!": 		"&not;",
		"any": 		"&exist;",
		"all": 		"&forall;",
		"==": 		"&equiv;",
		"!=": 		"&nequiv;",
		"==\>": 	"&rArr;",
		"\<=\>": 	"&hArr.",
		"=\>": 		"&#21A6;", // mapsto
		":=": 		"&cong;",
		"!:=": 		"&#2246;", // not congruent
		"join":		"&#22C8;"

);

anno str Tree@def;
anno str Tree@ref;
anno str Tree@math;

public Tree annotateMathOps(Tree tree, map[str, str] subst) {
	return top-down-break visit (tree) {
		case a:appl(prod(lit(str s), _, _), _) => a[@math=subst[s]] when subst[s]? && !((a@math)?)
	}
}

private list[Box] highlightLayout(Tree t) {
	switch (t) {
		case a:appl(prod(_, _, {_*, \tag("category"("Comment"))}), _):
			return [COMM(L(unparse(a)))];
			
		case appl(_, as):
			return [ *highlightLayout(a) | a <- as ];
			
		case char(n):
			return [L(stringChar(n))];
			
		default:
			throw "Unhandled tree: <t>";
	}
}

private list[Box] highlight(Tree t) {
    list[Box] r;
	switch (t) {
		case a:appl(prod(lit(str l), _, _), _): {
			if ((a@math)?) {
				r = [MATH(L(a@math))];
			}
			if (/^[a-zA-Z0-9_\-]*$/ := l) { 
				r =  [KW(L(l))];
			} else
			r =  [L(l)];
		} 
		case appl(prod(\layouts(_), _, _), as): 
			r = [ *highlightLayout(a) | a <- as ];
			
		case a:appl(prod(_, _, {_*, \tag("category"("Constant"))}), _):
			r = [STRING(L(unparse(a)))];

		case a:appl(prod(_, _, {_*, \tag("category"("Identifier"))}), _):
			r = [VAR(L(unparse(a)))];
			
		case a:appl(prod(\lex(_), _, _), _):
			r = [L(unparse(a))];
			
		case appl(_, as):
			r = [ *highlight(a) | a <- as ];

		case amb({k, _*}): {
			// this triggers a bug in stringtemplates??? 
			//throw "Ambiguous tree: <report(t)>";
			// pick one
			println("Warning: ambiguity: <t>");
			return highlight(k);
		}
			
		default: 
			throw "Unhandled tree <t>";
	}
	if (t@def?) {return [D(t@def, r)];}
	if (t@ref?) {return [G(t@ref, r)];}
	return r;
}


private map[str, str] htmlEscapes = (
	"\<": "&lt;",
     "\>": "&gt;",
	"&": "&amp;",
	" ": "&nbsp;"
);


// &#9251 = open box 
private map[str, str] stringEscapes = htmlEscapes + (" ": "&middot;");

private str highlight2html(list[Box] bs) {
	res = "";
	for (b <- bs) {
		switch (b) {
			case KW(L(s)): 		res += span(class("keyword"), s);
			case STRING(L(s)): 	res += span(class("string"), escapeString(s));
			case COMM(L(s)): 	res += span(class("comment"), escape(s));
			case VAR(L(s)): 	res += span(class("variable"), escape(s));
			case MATH(L(s)): 	res += span(class("math"), s);
			case L(s): 			res += escape(s);
			case D(s, l):       res += span(id(s), highlight2html(l)); 
			case G(s, l):       res += a("href=#<s>", highlight2html(l)); 
			default: throw "Unhandled box: <b>"; // todo NUM, REF etc. 
		}
	}
	return res;
}


private str escapeString(str s) {
	return escape(s, stringEscapes);
}

private str escape(str s) {
	return escape(s, htmlEscapes);
}
    

                        
private str rascalModuleToHTML(loc l) {
	pt = annotateMathOps(parseModule(l), mathLiterals);	
	pt = annotateDef(pt);
	list[Box] b = highlight(pt);
	// println(b);
	return highlight2html(b);
}


private str rascalModuleToHTML(Tree pt) {
	list[Box] b = highlight(pt);
	// println(b);
	return highlight2html(b);
}

private Tree updateTree(Tree t, int idx, Tree n) {
    if (appl(Production prod, list[Tree] args):=t) {
       list[Tree] v = args;
       v[idx] = n;
       Tree r =  appl(prod, v);
       r@def = t@def;
       return r;
       }
    return t;
    }

private Tree annotateRef(Tree tree) {
	return top-down-break visit (tree) {
		case a:appl(prod(def:label("nonterminal", _), _, _), list[Tree] q)=> a[@ref="<q[0]>"]
	}
}

private Tree annotateDefRef(Tree tree) {
	return top-down-break visit (tree) {	
		case a:appl(prod(def:label("language", sort("SyntaxDefinition")), _, _), list[Tree] q)=> 
		   updateTree(a[@def="<q[4]>"], 8, annotateRef(q[8]))
		case a:appl(prod(def:label("lexical", sort("SyntaxDefinition")), _, _), list[Tree] q)=> 
		   updateTree(a[@def="<q[2]>"], 6, annotateRef(q[6]))
	}
}

private str refButtons(Tree t) {
     str r = "";
     top-down visit (t) {
     case Tree q: { 
		     if (q@def?) r+=tr(td(a("href=#<q@def>", q@def)));
		 }
	   } 
	 return r;
     }
     
private list[str] report(Tree t) {
    list[str] r = [];
	top-down visit (t) {
		 case Tree a: { 
		    if (a@def?) r+=a@def;
		 }
	}
	return r;
}

// -----   Main Part

str headerScript = "function goTo(loc)\n" 
    +  "{document.getElementById(\'syntax\').src=loc;return false;}";
                   
str topHeader =  script(headerScript);

private str getContent(Tree t) {
   str bod = rascalModuleToHTML(t); 
   str txt = pre(code(class("rascal") , bod));
   return txt;
   }

private str topPanel(Tree pt, str titl) {
   str hd = " <titl>.rsc";
   str r = html(head(title(hd)+topHeader), body(
        h1(img("src=../rascal3D_2-66px.png", "Rascal")+hd)+
        table("cellspacing=\"10px\"", "cellpadding=\"2px\"",
        tr(
          td(
            div(class("panel"), id("index"),  
                  h2("Nonterminals")+table("cellpadding=\"2px\"",refButtons(pt))))
         +td(div(class("panel"), id("syntax"), h2("Content")+p(getContent(pt))
        ))
        )))
        ); 
   return r; 
   }
   
list[tuple[str, loc]] inputs = [
                    <"C", |project://main/std/lang/c90/syntax/C.rsc|> 
                    // <"dot", |project://main/std/lang/dot/syntax/Dot.rsc|>
                    // , <"pico", |project://main/std/lang/pico/syntax/Main.rsc|>
                    // , <"rascal", |project://main/std/lang/rascal/syntax/Rascal.rsc|> 
                    //, <"sdf2", |project://main/std/lang/sdf2/syntax/Sdf2.rsc|>                            
                   ];
   
public void main() {
   // rprint(parseModule(|project://main/src/Ap.rsc|));
   // loc l = |project://main/src/C.rsc|;
   // println(inputs);
   topCcs();
   for (<title, l><-inputs)  {
       println(title);
       rascal2HTML(title, l, |file:///ufs/bertl/html|);
       }
   }
   
public void rascal2HTML(str title, loc input, loc output) {
     output+=title;
     if (!exists(output)) {
         mkDirectory(output);
         }
     Tree pt = rascal2ParseTree(input);
     loc outMain = output+"index.html";
     str top = topPanel(pt, title);
     writeFile(outMain, top);   
}

private void topCcs() {
    S(".panel", "border:2px groove grey", "background-color:antiquewhite", "overflow:auto", 
        "max-width:<width>", "max-height:<height>");
    S("td", "vertical-align:top");
    S("h1", "text-align:center");
    S("h2", "text-align:center");
    S("#syntax", "background-color:antiquewhite", "max-height:<height>");
    S(".keyword", "font-weight:bold", "color:darkmagenta");
    S(".string", "color:darkmagenta");
    S(".comment","color:gray");
    }   
