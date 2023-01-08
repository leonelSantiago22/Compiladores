
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     Char = 258,
     Int = 259,
     Float = 260,
     Double = 261,
     PR_IF = 262,
     PR_ELSE = 263,
     PR_WHILE = 264,
     PR_FOR = 265,
     PR_CONTINUE = 266,
     PR_BREAK = 267,
     PR_SWITCH = 268,
     PR_RETURN = 269,
     PR_MAIN = 270,
     PR_SCANF = 271,
     tipos_scanf = 272,
     PR_PRINTF = 273,
     PR_EXTERN = 274,
     PR_CASE = 275,
     PR_INCLUDE = 276,
     PR_VECTOR = 277,
     op_mas = 278,
     op_menos = 279,
     op_por = 280,
     op_div = 281,
     Inc = 282,
     Dec = 283,
     op_igual = 284,
     op_mayor = 285,
     op_menor = 286,
     op_mayorigual = 287,
     op_menorigual = 288,
     op_dosigual = 289,
     op_negacion = 290,
     amperson = 291,
     ESPACIO = 292,
     guion = 293,
     llave_a = 294,
     llave_c = 295,
     par_a = 296,
     par_c = 297,
     cor_a = 298,
     cor_c = 299,
     coma = 300,
     punto = 301,
     punto_coma = 302,
     dos_puntos = 303,
     id = 304,
     Iconst = 305,
     numero = 306,
     Cconst = 307,
     String = 308,
     cadena = 309,
     Fconst = 310,
     GATO = 311
   };
#endif
/* Tokens.  */
#define Char 258
#define Int 259
#define Float 260
#define Double 261
#define PR_IF 262
#define PR_ELSE 263
#define PR_WHILE 264
#define PR_FOR 265
#define PR_CONTINUE 266
#define PR_BREAK 267
#define PR_SWITCH 268
#define PR_RETURN 269
#define PR_MAIN 270
#define PR_SCANF 271
#define tipos_scanf 272
#define PR_PRINTF 273
#define PR_EXTERN 274
#define PR_CASE 275
#define PR_INCLUDE 276
#define PR_VECTOR 277
#define op_mas 278
#define op_menos 279
#define op_por 280
#define op_div 281
#define Inc 282
#define Dec 283
#define op_igual 284
#define op_mayor 285
#define op_menor 286
#define op_mayorigual 287
#define op_menorigual 288
#define op_dosigual 289
#define op_negacion 290
#define amperson 291
#define ESPACIO 292
#define guion 293
#define llave_a 294
#define llave_c 295
#define par_a 296
#define par_c 297
#define cor_a 298
#define cor_c 299
#define coma 300
#define punto 301
#define punto_coma 302
#define dos_puntos 303
#define id 304
#define Iconst 305
#define numero 306
#define Cconst 307
#define String 308
#define cadena 309
#define Fconst 310
#define GATO 311




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 14 "parser.y"

    char char_val;
	int int_val;
	double double_val;	
	char* str_val;
	list_t* symtab_item;



/* Line 1676 of yacc.c  */
#line 174 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


