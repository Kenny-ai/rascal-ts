module TSSyntax

extend TSLex;

start syntax Program = prog: Stmt*;

syntax Stmt 
        = varstatement: VariableStmt 
        | exSep: ExpSep 
        | fnStmt: FuncStmt 
        | ifStmt: IfStmt 
        | loopStmt: LoopStmt;

syntax ExpSep = expSep: Exp SemiColon+;

syntax VariableStmt = variableStatement: VarKeyword? {VariableDecl ","}+  SemiColon+;

syntax VariableDecl = variableDeclaration: Id TypeDef? Initialize;

syntax TypeDef = typeDef: ":" Type;

syntax Initialize = initialize: "=" Exp;

syntax Exp
        = var: Id
        
        | integer: Integer

        | string: String

        | boolean: Boolean

        | arr: "[" {Exp ","}* "]"

        | fncall: Exp "(" {Exp ","}* ")"

        > poscheck: Id "[" Exp "]"

        // | fac: Exp "!"

        | bracket brac: "(" Exp ")"

        > left (mult: Exp "*" Exp | div: Exp "/" Exp)

        > left (add: Exp "+" Exp | sub: Exp "-" Exp)

        > non-assoc (
                greater: Exp "\>" Exp 
                | greaterEqual: Exp "\>=" Exp 
                | less: Exp "\<" Exp 
                | lessEqual: Exp "\<=" Exp 
        )
        > right (
                 equal: Exp "==" Exp
                | notEqual:  Exp "!=" Exp
                | strictEqual: Exp "===" Exp
                | strictNotEqual: Exp "!==" Exp
        )
        > left (and: Exp "&&" Exp)
        > left (or: Exp "||" Exp);

syntax FuncStmt = fnStatement: VarKeyword? {FuncDecl ","}+  SemiColon+;

syntax FuncDecl = fnDeclaration: Id FuncTypeOrInit+;

syntax FuncTypeOrInit = funcTypeDef: FuncTypeDef | funcInit: FuncInitialize;

syntax FuncTypeDef = fnTypeDef: ":" "(" {FuncArgDef ","}* ")" FuncArrow Type;

syntax FuncInitialize = fnInit: "=" "(" {FuncArgDef ","}* ")" FuncArrow "{" FuncBlock* "}";

syntax FuncArgDef = fnArgDef: Id TypeDef?;

syntax FuncBlock = fnBlock: Stmt | retStmt: ReturnStmt;

syntax ReturnStmt = rtnStmt: "return" Exp SemiColon+;

syntax IfStmt = ifStatement: "if" "(" Exp ")" "{" Stmt* "}" ElseIfStmt* ElseStmt? SemiColon+;

syntax ElseIfStmt = elseIfStmt: "else if" "(" Exp ")" "{" Stmt* "}";

syntax ElseStmt = elseStmt: "else" "{" Stmt* "}";

syntax LoopStmt = whileStatement: WhileStmt | forStatement: ForStmt;

syntax WhileStmt = whileStmt: "while" "(" Exp ")" "{" LoopBlock* "}";

syntax LoopBlock = blk: Stmt | breakCont: BrkCont;

syntax BrkCont = brkCont: LoopBlockKeyword SemiColon+;

syntax ForStmt = forStmt: "for" "(" ForCondition ")" "{" LoopBlock* "}";

syntax ForCondition = forCond: VariableStmt Exp ";" {VariableDecl ","}+;
