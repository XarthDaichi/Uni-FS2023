options(splash, '*** Generated by OFS compiler version 2.0 ***').
stream_import(splash, import(symbols([id(['S',t,r,e,a,m])]),str(['.',/,c,o,m,b,i,n,a,d,o,r,e,s,'.',m,j,s]))).


generator(Filename, program([ISL, SL])) :-
    open(Filename, write, Stream),
    options(splash, Header),
    generate_line_comment(Stream, Header),
    stream_import(splash, StreamImport),
    generate_import_statement(Stream, StreamImport),
    forall(member(Import_statement, ISL),
        generate_import_statement(Stream, Import_statement)),
    forall(member(Statement, SL),
        generate_statement(Stream, Statement)),
    close(Stream)
.

%% generate_import_statement

generate_import_statement(Stream, import(symbols(SymbolsL),str(Path))) :-
    generate_import_symbols(SymbolsL, SymbolsAtomL),
    atomic_list_concat(SymbolsAtomL, ',', SymbolsAtom),
    atomic_list_concat(['{', SymbolsAtom, '}'], SymbolsFullAtom),
    atomic_list_concat(Path, PathAtom),
    writeln(SymbolsFullAtom),
    writeln(PathAtom),
    format(Stream, 'import ~s from \'~s\';~n', [SymbolsFullAtom, PathAtom])
.

%%% error final option for generate_import_statement
generate_import_statement(Stream, I) :-
    format(atom(Comment), 'Import Statement not generated! ~q', [I]),
    generate_line_comment(Stream, Comment)
.

generate_import_symbols([id(I) | RI], [AtomI | RSymbolsList]) :-
    generate_import_symbols(RI, RSymbolsList),
    atomic_list_concat(I, AtomI)
.

generate_import_symbols([], []).


%% generate_statement



%%% error final option for generate_statement
generate_statement(Stream, S) :-
    format(atom(Comment), 'Statement not generated! ~q', [S]),
    generate_line_comment(Stream, Comment)
.

% generate_line_comment
generate_line_comment(Stream, Comment) :-
    format(Stream, '// ~s ~n', [Comment])
.