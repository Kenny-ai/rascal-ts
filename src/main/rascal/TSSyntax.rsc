module TSSyntax

extend TSLex;

// start syntax Program = prog: {Stmt NewLine*}*;

start syntax Stmt = varstatement: VariableStmt;

// syntax Decl = vardeclaration: VariableDecl;

syntax VariableStmt = variableStatement: VarKeyword? {VariableDecl ","}+  SemiColon?;

syntax VariableDecl = variableDeclaration: TypeKeyword? Id Initialize?;

syntax Initialize = initialize: "=" Exp;


start syntax Exp
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
        ;