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
    Char = 258,                    /* Char  */
    Int = 259,                     /* Int  */
    Float = 260,                   /* Float  */
    Double = 261,                  /* Double  */
    PR_IF = 262,                   /* PR_IF  */
    PR_ELSE = 263,                 /* PR_ELSE  */
    PR_WHILE = 264,                /* PR_WHILE  */
    PR_FOR = 265,                  /* PR_FOR  */
    PR_CONTINUE = 266,             /* PR_CONTINUE  */
    PR_BREAK = 267,                /* PR_BREAK  */
    PR_SWITCH = 268,               /* PR_SWITCH  */
    PR_RETURN = 269,               /* PR_RETURN  */
    PR_MAIN = 270,                 /* PR_MAIN  */
    PR_SCANF = 271,                /* PR_SCANF  */
    tipos_scanf = 272,             /* tipos_scanf  */
    PR_PRINTF = 273,               /* PR_PRINTF  */
    PR_EXTERN = 274,               /* PR_EXTERN  */
    PR_CASE = 275,                 /* PR_CASE  */
    PR_INCLUDE = 276,              /* PR_INCLUDE  */
    PR_VECTOR = 277,               /* PR_VECTOR  */
    op_mas = 278,                  /* op_mas  */
    op_menos = 279,                /* op_menos  */
    op_por = 280,                  /* op_por  */
    op_div = 281,                  /* op_div  */
    Inc = 282,                     /* Inc  */
    Dec = 283,                     /* Dec  */
    op_igual = 284,                /* op_igual  */
    op_mayor = 285,                /* op_mayor  */
    op_menor = 286,                /* op_menor  */
    op_mayorigual = 287,           /* op_mayorigual  */
    op_menorigual = 288,           /* op_menorigual  */
    op_dosigual = 289,             /* op_dosigual  */
    op_negacion = 290,             /* op_negacion  */
    amperson = 291,                /* amperson  */
    ESPACIO = 292,                 /* ESPACIO  */
    guion = 293,                   /* guion  */
    llave_a = 294,                 /* llave_a  */
    llave_c = 295,                 /* llave_c  */
    par_a = 296,                   /* par_a  */
    par_c = 297,                   /* par_c  */
    cor_a = 298,                   /* cor_a  */
    cor_c = 299,                   /* cor_c  */
    coma = 300,                    /* coma  */
    punto = 301,                   /* punto  */
    punto_coma = 302,              /* punto_coma  */
    dos_puntos = 303,              /* dos_puntos  */
    id = 304,                      /* id  */
    Iconst = 305,                  /* Iconst  */
    numero = 306,                  /* numero  */
    Cconst = 307,                  /* Cconst  */
    String = 308,                  /* String  */
    cadena = 309,                  /* cadena  */
    Fconst = 310,                  /* Fconst  */
    GATO = 311                     /* GATO  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 14 "parser.y"

    char char_val;
	int int_val;
	double double_val;	
	char* str_val;
	list_t* symtab_item;

#line 128 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
