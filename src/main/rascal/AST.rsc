module AST

import TSSyntax;

data Program = prog(list[Stmt] stmt);

data Stmt = varstatement(VariableStmt varStmt) | exSep(ExpSep es) | fnStmt(FuncStmt fs) | ifStmt(IfStmt ifs) | loopStmt(LoopStmt ls);

data ExpSep = expSep(Exp exp, list[str] scolon);

data VariableStmt = variableStatement(str varKeyword, list[VariableDecl] vdecl, list[str] scolon);

data VariableDecl = variableDeclaration(str id, list[TypeDef] td, list[Initialize] init);

data TypeDef = typeDef(str typ);

data Initialize = initialize(Exp exp);

data Exp = var(str id)
         | integer(int number)
         | string(str text)
         | boolean(bool boolValue)
         | arr(list[Exp] arrValues)
         | fncall(Exp exp, list[Exp] fnArgs)
         | poscheck(str id, Exp exp)
         | brac(Exp exp)
         | mult(Exp lhs, Exp rhs)
         | div(Exp lhs, Exp rhs)
         | add(Exp lhs, Exp rhs)
         | sub(Exp lhs, Exp rhs)
         ;

data FuncStmt = fnStatement(str varKeyword, list[FuncDecl] fndecl, list[str] scolon);

data FuncDecl = fnDeclaration(str id, list[FuncTypeOrInit] ftoi);

data FuncTypeOrInit = funcTypeDef(FuncTypeDef ftd) | funcInit(FuncInitialize fi);

data FuncTypeDef = fnTypeDef(list[FuncArgDef] fad, str fnArrow, str typ);

data FuncInitialize = fnInit(list[FuncArgDef] fad, str fnArrow, list[FuncBlock] fnBlock);

data FuncArgDef = fnArgDef(str id, str typ);

data FuncBlock = fnBlock(Block b) | retStmt(ReturnStmt rs);

data Block = block(Stmt stmt);

data ReturnStmt = rtnStmt(Exp exp, list[str] scolon);

data IfStmt = ifStatement(Condition cond, list[Block] block, list[ElseIfStmt] eis, list[ElseStmt] es, list[str] scolon);

data ElseIfStmt = elseIfStmt(Condition cond, list[Block] block);

data ElseStmt = elseStmt(list[Block] block);

// check line below if error
data Condition = condition(list[UnitCondition] unitcond);

data UnitCondition = greater(Exp lhs, Exp rhs)
                    | greaterEqual(Exp lhs, Exp rhs)
                    | less(Exp lhs, Exp rhs)
                    | lessEqual(Exp lhs, Exp rhs)
                    | equal(Exp lhs, Exp rhs)
                    | notEqual(Exp lhs, Exp rhs)
                    | strictEqual(Exp lhs, Exp rhs)
                    | strictNotEqual(Exp lhs, Exp rhs);

data LoopStmt = whileStatement(WhileStmt ws) | forStatement(ForStmt fs);

data WhileStmt = whileStmt(Condition cond, list[LoopBlock] lb);

data LoopBlock = blk(Block block) | lbScolon(str lbKeyword, list[str] scolon);

data ForStmt = forStmt(ForCondition forcond, list[LoopBlock] lb);

data ForCondition = forCond(VariableStmt varStmt, Condition cond, list[VariableDecl] vDecl);