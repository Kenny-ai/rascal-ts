module AST

import TSSyntax;

// check out the commented line below
// data Program = prog(list[Stmt] stmt, list[str] newline);

data Stmt = varstatement(VariableStmt varStmt);

// data Decl = vardeclaration(VariableDecl varDecl);

data VariableStmt = variableStatement(str varKeyword, list[VariableDecl] vdecl, list[str] scolon);

data VariableDecl = variableDeclaration(str typeKeyword, str id, list[Initialize] init);

data Initialize = initialize(Exp exp);

data Exp = var(str id)
         | integer(int number)
         | string(str text)
         | boolean(bool boolValue)
         | arr(list[Exp] arrValues)
         | poscheck(str id, Exp exp)
         | mult(Exp lhs, Exp rhs)
         | add(Exp lhs, Exp rhs)
         | div(Exp lhs, Exp rhs)
         | sub(Exp lhs, Exp rhs)
         | brac(Exp exp)
         | fncall(str id, list[Exp] fnArgs)
         ;

// var string name = Blair; 
// const int age = 23;
// const hobbies = ["Following women", "Coding", true, false, 10];
// let calc = 2 + 3 * 17 / (2 * 3);
// const hobbies = age(2, 3);
// calc = 2 + 3 * 17 / true;
// calc = true / true;