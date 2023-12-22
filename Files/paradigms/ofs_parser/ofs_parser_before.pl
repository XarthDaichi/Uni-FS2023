%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERATOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options(splash, '*** Generated by OFS compiler version 0.0 ***').

generator(Filename, prog(Statement_list)) :-
    open(Filename, write, Stream),
    options(splash, Header),
    generate_line_comment(Stream, Header),
    forall(member(Statement, Statement_list), 
        generate_statement(Stream, Statement)),
    close(Stream)
.

generate_statement(Stream, const( id(I), id(K) )) :- !,
    format(Stream, 'const ~s = ~s;~n', [I, K])
.

generate_statement(Stream, const( id(I), num(N) )) :- !,
    format(Stream, 'const ~s = ~d;~n', [I, N])
.

generate_statement(Stream, const( id(I), undefined )) :- !,
    format(Stream, 'const ~s = undefined;~n', [I])
.

generate_statement(Stream, let( id(I), id(K) )) :- !,
    format(Stream, 'let ~s = ~s;~n', [I, K])
.

generate_statement(Stream, let( id(I), num(N) )) :- !,
    format(Stream, 'let ~s = ~d;~n', [I, N])
.

generate_statement(Stream, let( id(I), undefined )) :- !,
    format(Stream, 'let ~s = undefined;~n', [I])
.

generate_statement(Stream, S) :-
    format(atom(Comment), 'Statement not generated! ~q', [S]), % esto para capturar lo que el format quiere escribir
    generate_line_comment(Stream, Comment)
.

generate_line_comment(Stream, Comment) :-
    format(Stream, '// ~s ~n', [Comment])
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eliminate_null(+OFSAst, -OFSAstWithoutNulls)

% buscar meta-predicados include y exclude

eliminate_null( prog(SL), prog(SLWithoutNulls) ) :-
    eliminate_null_from_statementList(SL, SLWithoutNulls)
.

eliminate_null_from_statementList( [], [] ).

eliminate_null_from_statementList( [ null | SL], SLWithoutNulls ) :- !,
    eliminate_null_from_statementList(SL, SLWithoutNulls)
.

eliminate_null_from_statementList( [ S | SL], [S | SLWithoutNulls] ) :-
    eliminate_null_from_statementList(SL, SLWithoutNulls)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARSER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ofs_parser( prog(SL) ) --> statement_list(SL).

statement_list([S | SL]) --> statement(S), statement_list(SL).
statement_list([]) --> [].

statement( const(I, RS) ) --> const, ident(I), right_side(RS).
statement( let(I, RS) ) --> let, ident(I), right_side(RS).
statement( null ) --> semicolon.

right_side(E) --> assignment, expr(E).
right_side( undefined ) --> [].

expr(I) --> ident(I).
expr(N) --> number(N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TOKENIZER = LEXER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

const --> spaces, "const", space, spaces.

let --> spaces, "let", space, spaces.

semicolon --> spaces, ";", spaces.

ident( id(I) ) --> [X], spaces, {member(X, [120, 121]), string_codes(I, [X])}.

number( num(1) ) --> "1", spaces.

assignment --> "=", spaces.

% whitespaces
space --> (" " ; "\t" ; "\n" ; "\r").

spaces --> space, spaces.
spaces --> [].