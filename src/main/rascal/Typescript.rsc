module Typescript

import TSSyntax;
import TSLex;
import ParseTree;
// import AST;

loc src = |project://rascal-ts/src/resources/transform.tap|;

start[Program] pTree = parse(#start[Program], src);

start[Program] translate(start[Program] t = pTree ) {
  return innermost visit (t) {
   case (VariableStmt) `const <Id f> = <Exp exp>;`

    => (VariableStmt) `<Id f> = <Exp exp>;`

  }
}