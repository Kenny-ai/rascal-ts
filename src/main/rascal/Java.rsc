module Java

import lang::java::\syntax::Java15;
import ParseTree;

loc javasrc = |project://rascal-ts/src/resources/Example.java|;

start[CompilationUnit] javaPtree = parse(#start[CompilationUnit], javasrc);

// list[loc] publicFields(start[CompilationUnit] cu = javaPtree) = 
//   [f@\loc | /(FieldDec) `public <Type _> <Id f>;` := cu ];

start[CompilationUnit] transform(start[CompilationUnit] cu = javaPtree) {
  return innermost visit (cu) {
    case (ClassBody) `{ 
                        ' <ClassBodyDec* cs1> 
                        ' public <Type t> <Id f>; 
                        ' <ClassBodyDec* cs2> 
                      '}`

      => (ClassBody) `{
                        ' <ClassBodyDec* cs1>
                        ' private <Type t> <Id f>;
                        ' public void <Id setter> (<Type t> x) {
                        '  this.<Id f> = x;
                        ' }
                        ' public <Type t> <Id getter>() {
                        '  return this.<Id f>;
                        ' }
                        ' <ClassBodyDec* cs2> 
                      '}`
      when
        Id setter := [Id]"set<f>",
        Id getter := [Id]"get<f>"
  }
}
