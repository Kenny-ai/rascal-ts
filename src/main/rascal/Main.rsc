module Main

import IO;

import TSSyntax;
import TSLex;
import ParseTree;
import AST;

loc src = |project://rascal-ts/src/resources/test.tap|;

start[Program] pTree = parse(#start[Program], src);

Program absTree = implode(#Program, pTree);

Program main() {
    // println("argument: <testArgument>");
    // return pTree;
    println(absTree);
    return absTree;
}
