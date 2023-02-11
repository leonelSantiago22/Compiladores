/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    CHAR = 258,                    /* CHAR  */
    INT = 259,                     /* INT  */
    FLOAT = 260,                   /* FLOAT  */
    DOUBLE = 261,                  /* DOUBLE  */
    IF = 262,                      /* IF  */
    ELSE = 263,                    /* ELSE  */
    WHILE = 264,                   /* WHILE  */
    FOR = 265,                     /* FOR  */
    CONTINUE = 266,                /* CONTINUE  */
    BREAK = 267,                   /* BREAK  */
    VOID = 268,                    /* VOID  */
    RETURN = 269,                  /* RETURN  */
    ADDOP = 270,                   /* ADDOP  */
    MULOP = 271,                   /* MULOP  */
    DIVOP = 272,                   /* DIVOP  */
    INCR = 273,                    /* INCR  */
    OROP = 274,                    /* OROP  */
    ANDOP = 275,                   /* ANDOP  */
    NOTOP = 276,                   /* NOTOP  */
    EQUOP = 277,                   /* EQUOP  */
    RELOP = 278,                   /* RELOP  */
    LPAREN = 279,                  /* LPAREN  */
    RPAREN = 280,                  /* RPAREN  */
    LBRACK = 281,                  /* LBRACK  */
    RBRACK = 282,                  /* RBRACK  */
    LBRACE = 283,                  /* LBRACE  */
    RBRACE = 284,                  /* RBRACE  */
    SEMI = 285,                    /* SEMI  */
    COMMA = 286,                   /* COMMA  */
    ASSIGN = 287,                  /* ASSIGN  */
    REFER = 288,                   /* REFER  */
    ID = 289,                      /* ID  */
    ICONST = 290,                  /* ICONST  */
    FCONST = 291,                  /* FCONST  */
    CCONST = 292,                  /* CCONST  */
    STRING = 293,                  /* STRING  */
    MINUS = 294                    /* MINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 35 "parser.y"

	// different types of values
	Value val;   
	
	// structures
	list_t* symtab_item;
	AST_Node* node;
	
	// for declarations
	int data_type;
	int const_type;
	
	// for arrays
	int array_size;
	
	// for parameters
	Param par;

#line 122 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
