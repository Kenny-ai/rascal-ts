module Pprinter

import AST;
import ParseTree;
import List;
import String;
import TSLex;

public str convertToString(Program::prog(list[Stmt] stmts)) {
  return unparseStmts(stmts);
}

str unparseStmts(list[Stmt] stmts) {
  str statements = intercalate(" ", [transformToString(stmt) | stmt <- stmts]);
  return statements;
}

str transformToString(Stmt stmt) {
  switch(stmt) {
    case varstatement(VariableStmt varStmt): return unparseVariableStmt(varStmt) + "\n";

    case  exSep(ExpSep es): return unparseExpSep(es);

    case fnStmt(FuncStmt fs): return unparseFuncStmt(fs);

    case ifStmt(IfStmt ifs) : return unparseIfStmt(ifs);

    case loopStmt(LoopStmt ls) : return unparseLoopStmt(ls);

    default: throw "Unhandled Stmt: <stmt>";
  }
}

str unparseLoopStmt(LoopStmt ls) {
  switch(ls) {
    case whileStatement(WhileStmt ws): return unparseWhileStmt(ws);

    case  forStatement(ForStmt fs): return unparseForStmt(fs);

    default: throw "Unhandled loopStmt <ls>";
  }
}

str unparseWhileStmt(WhileStmt ws) {
  str expr = unparseExp(ws.exp);

  str loopBlock = intercalate(" ", [unparseLoopBlock(stmt) | stmt <- ws.lb]);
  return "while (<expr>) {\r\n <loopBlock>}";
}

str unparseLoopBlock(LoopBlock stmt) {
  switch(stmt) {
    case blk(Stmt block): return transformToString(block);
    case breakCont(BrkCont bc): return unparseBrkCont(bc);

    default: throw "Unhandled FuncBlock <stmt>" ;
  }
}

str unparseBrkCont(BrkCont bc) {
  str brkCont = bc.loopBlkKeywrd;
  str semiColons = intercalate(" ", bc.scolon);
  return brkCont + semiColons + "\r\n";
}

str unparseForStmt(ForStmt fs) {
  str forcondition = unparseForCondition(fs.forcond);

  str loopBlock = intercalate(" ", [unparseLoopBlock(stmt) | stmt <- fs.lb]);

  return "for (<forcondition>) {\r\n <loopBlock>}";
}

str unparseForCondition(ForCondition forcond) {
  str statements = unparseVariableStmt(forcond.varStmt);
  str expr = unparseExp(forcond.exp);
  str vdecl = intercalate(", ", [unparseVariableDecl(i) | i <- forcond.vDecl]);
  return "<statements> <expr>; <vdecl>";
}

str unparseIfStmt(IfStmt ifs) {
  str expr = unparseExp(ifs.exp);
  str block = unparseStmts(ifs.block);
  str elseIfStmt = !isEmpty(ifs.eis) ? intercalate(" ", [unparseElseIfStmt(stmt) | stmt <- ifs.eis]) : "";
  str elseStmt = !isEmpty(ifs.eis) ? intercalate(" ", [unparseElseStmt(stmt) | stmt <- ifs.es]) : " ";
  str semiColons = intercalate(" ", ifs.scolon);

  return "if (<expr>) {\r\n <block>} <elseIfStmt><elseStmt><semiColons>";
}

str unparseElseIfStmt(ElseIfStmt eis) {
  str expr = unparseExp(eis.exp);
  str block = unparseStmts(eis.block);
  return "else if (<expr>) {\r\n <block>}";
}

str unparseElseStmt(ElseStmt es) {
  str block = unparseStmts(es.block);
  return "else {\r\n <block>}";
}

str unparseExpSep(ExpSep es) {
  str exp = unparseExp(es.exp);
  str semiColons = intercalate(" ", es.scolon);
  return exp + semiColons;
}

str unparseVariableStmt(VariableStmt varStmt) {
  str varKeyword = !isEmpty(varStmt.varKeyword) ? varStmt.varKeyword + " " : "";

  str variables = intercalate( ", ", [unparseVariableDecl(vdecl) | vdecl <- varStmt.vdecl]);

  str semiColons = intercalate(" ", varStmt.scolon);

  return varKeyword + variables + semiColons;
}

str unparseVariableDecl(VariableDecl vdecl) {
  str id = vdecl.id;

  str typeDef = !isEmpty(vdecl.td) ? ": " + intercalate( ", ", [unparseTypeDef(td) | td <- vdecl.td ]) : "";
  
  str initialize = unparseInitialize(vdecl.init); 

  return id + typeDef + initialize;
}

str unparseTypeDef(TypeDef td) {
  return td.typ;
}

str unparseInitialize(Initialize init) {
  return " = <unparseExp(init.exp)>";
}

str unparseFuncStmt(FuncStmt fs) {
  str varKeyword = !isEmpty(fs.varKeyword) ? fs.varKeyword + " " : "";

  str variables = intercalate(", ", [unparseFuncDecl(fndecl) | fndecl <- fs.fndecl]);

  str semiColons = intercalate(" ", fs.scolon);

  return varKeyword + variables + semiColons + "\n";

}

str unparseFuncDecl(FuncDecl fndecl) {
  str id  = fndecl.id;

  str fntypesOrInit = intercalate(" ", [unparseFuncTypeOrInit(ftoi) | ftoi <- fndecl.ftoi] );

  return id + fntypesOrInit;
}

str unparseFuncTypeOrInit(FuncTypeOrInit ftoi) {
  switch (ftoi) {
    case funcTypeDef(FuncTypeDef ftd): return unparseFuncTypeDef(ftd);

    case funcInit(FuncInitialize fi): return unparseFuncInitialize(fi);

    default: throw "Unhandled ftoi <ftoi>" ;
  }
}

str unparseFuncTypeDef(FuncTypeDef ftd) {
  str typeDef = !isEmpty(ftd.fad) ? intercalate(", ", [unparseFuncArgDef(fad) | fad <- ftd.fad ]) : "";

  str fnArrow = ftd.fnArrow;

  str typ = ftd.typ;

  return ": (<typeDef>) <fnArrow> <typ>";
}

str unparseFuncInitialize (FuncInitialize fi) {
  str fnArgs = !isEmpty(fi.fad) ? intercalate(", ", [unparseFuncArgDef(fad) | fad <- fi.fad ]) : "";

  str fnArrow = fi.fnArrow;

  str fnBlock = intercalate(" ", [unparseFuncBlock(stmt) | stmt <- fi.stmts]);

  return " = (<fnArgs>) <fnArrow> {\r\n <fnBlock>}";
}

str unparseFuncArgDef(FuncArgDef fad) {
  str id = fad.id;
  str typ = !isEmpty(fad.typ) ? ": " + intercalate("", [unparseTypeDef(t) | t <- fad.typ ]) : "";
  return id + typ;
}

str unparseFuncBlock(FuncBlock stmt) {
  switch(stmt) {
    case fnBlock(Stmt b): return transformToString(b);
    case retStmt(ReturnStmt rs): return unparseReturnStmt(rs);

    default: throw "Unhandled FuncBlock <stmt>" ;
  }
}

str unparseReturnStmt(ReturnStmt rs) {
  str exps = unparseExp(rs.exp);
  str semiColons = intercalate(" ", rs.scolon);
  return "return " + exps + semiColons + "\r\n";
}

str unparseExp(Exp exp) {
  switch(exp) {
      case var(str id): return "<id>";
      case integer(int number): return "<number>";

      case string(str text): return "<text>";

      case boolean(bool boolValue): return "<boolValue>";

      case arr(list[Exp] arrValues): return "[" + intercalate( ", ", [unparseExp(e) | e <- arrValues]) + "]";

      case fncall(Exp exp, list[Exp] fnArgs): return unparseExp(exp) + "(" + intercalate(", ", [unparseExp(arg) | arg <- fnArgs]) + ")";

      // case poscheck(str id, Exp exp): return id + "[" + unparseExp(exp) + "]";
      // case brac(Exp exp): return "(" + unparseExp(exp) + ")";

      case add(Exp lhs, Exp rhs): return "<unparseExp(lhs)> + <unparseExp(rhs)>";
      case sub(Exp lhs, Exp rhs): return "<unparseExp(lhs)> - <unparseExp(rhs)>";
      case mult(Exp lhs, Exp rhs): return "<unparseExp(lhs)> / <unparseExp(rhs)>";
      case div(Exp lhs, Exp rhs): return "<unparseExp(lhs)> * <unparseExp(rhs)>";

      case greater(Exp lhs, Exp rhs): return "<unparseExp(lhs)> \> <unparseExp(rhs)>";
      case greaterEqual(Exp lhs, Exp rhs): return "<unparseExp(lhs)> \>= <unparseExp(rhs)>";
      case less(Exp lhs, Exp rhs): return "<unparseExp(lhs)> \< <unparseExp(rhs)>";
      case lessEqual(Exp lhs, Exp rhs): return "<unparseExp(lhs)> \<= <unparseExp(rhs)>";
      case equal(Exp lhs, Exp rhs): return "<unparseExp(lhs)> == <unparseExp(rhs)>";
      case notEqual(Exp lhs, Exp rhs): return "<unparseExp(lhs)> != <unparseExp(rhs)>";
      case strictEqual(Exp lhs, Exp rhs): return "<unparseExp(lhs)> === <unparseExp(rhs)>";
      case strictNotEqual(Exp lhs, Exp rhs): return "<unparseExp(lhs)> !== <unparseExp(rhs)>";
      case and(Exp lhs, Exp rhs): return "<unparseExp(lhs)> && <unparseExp(rhs)>";
      case or(Exp lhs, Exp rhs): return "<unparseExp(lhs)> || <unparseExp(rhs)>";

      default: throw "Unhandled Exp: <exp>";

  }
}
