module Main

import TSSyntax;
import TSLex;
import ParseTree;
import AST;
import  Pprinter;

loc src = |project://rascal-ts/src/resources/test.tap|;

start[Program] pTree = parse(#start[Program], src);

Program absTree = implode(#Program, pTree);

str pPrinter = convertToString(absTree);

str main() {
    // return pTree;
    return pPrinter;
}
