module Pprinter

import AST;
import List;

public str toString(Program::prog(list[Stmt] stmts)) {
  return "<for (stmt <- stmts) {>
         '  <toString(stmt)>
         '<}>";
}

public str toString(Stmt stmt) {
  switch(stmt) {
    case varstatement(VariableStmt varStmt): return "<toString(varStmt)>";
    default: throw "Unhandled Stmt: <stmt>";
  }
}