module TSLex

extend lang::std::Layout;

// Must start with a letter followed by letters or numbers
// Must not be followed by another character. (Follow Restriction)
// Must not be a keyword
lexical Id = ([a-z A-Z][a-z A-Z 0-9]* !>> [a-z A-Z 0-9]) \ Keyword;

// Must be a number
// Can be one or more digits such as 100, 111, 0, 10
// Must not be followed by another number or preceded by another number.
// I.e you can't have layout between numbers
lexical Integer = [0-9] !<< [0-9]+ !>> [0-9];

// A String is characters between double quotes
lexical String = [\"] String_Char* [\"];
lexical String_Char  = ![\\ \" \n] | "\\" [\\ \"];
lexical SemiColon = ";";
lexical FuncArrow = "=\>";
lexical Boolean = "true" | "false";

lexical NewLine = "\r\n" | "\r\t";
lexical Type 
            = "number"
            | "string" 
            | "boolean"
            | TypeKeyword
            ;

keyword Keyword 
                = "true" 
                | "false" 
                | "class"
                | "return"
                | "while"
                | "for"
                | "in"
                | "of"
                | "if"
                | "else"
                | VarKeyword
                | TypeKeyword
                | LoopBlockKeyword
                ;

keyword VarKeyword = "let" | "const" | "var";

keyword TypeKeyword 
                    = 
                    | "void"
                    | "null" 
                    | "undefined" 
                    ;

keyword LoopBlockKeyword = "continue" | "break";
