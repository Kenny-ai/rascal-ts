module Main

// import IO;

import TSSyntax;
import TSLex;
import ParseTree;
import AST;

loc src = |project://rascal-ts/src/resources/transform.tap|;

start[Program] pTree = parse(#start[Program], src);

// Program absTree = implode(#Program, pTree);

// start[Program] main() {
//     // println("argument: <testArgument>");
//     // return pTree;
//     // println(pTree);
//     return pTree;
// }

start[Program] translate(start[Program] t = pTree) {
  return visit (t) {
    case (Stmt) `{ <VariableStmt vs1> <Id f> <TypeDef td> <Initialize init>; <VariableStmt vs2> } `

    => (Stmt) `{ <VariableStmt vs1> <TypeDef td> <Id f> <Initialize init>; <VariableStmt vs2> }`

  }
}