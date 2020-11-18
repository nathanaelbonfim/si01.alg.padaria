Program Padaria;
Uses Crt;

Type Produto = Record
    cod: Integer;
    nome: String[80];
    valor: Double;
    qtd: Integer;
    status: Char;
End;

Var { Variáveis globais }
    produtoMem: Produto;
    arqProdutos: File of Produto;
    escolha: Integer;
    listaDeStatus: Array [0..3] of Char;

Procedure inicializarGlobais();
Begin
    escolha := 0;

    listaDeStatus[0] := 'A';
    listaDeStatus[1] := 'a';
    listaDeStatus[2] := 'i';
    listaDeStatus[3] := 'I';
End;

{ Configura o arquivo }
Procedure configArquivo;
Begin
    assign(arqProdutos, 'padaria.dat');
    {$I-}
    reset(arqProdutos);
    {$I+}
    if IOresult <> 0 then
        rewrite(arqProdutos);
End;

{ Desenha uma linha de  caracates }
Procedure menuLinha();
Begin
    writeln('--------------------------------------------------------------------------------');
End;

{ Cabeçalho de cada menu }
Procedure menuCabecalho(titulo: String);
Begin
    menuLinha();
    writeln('| ', titulo);
    menuLinha();
End;

{ Imprime a mensagem 'pressione qualquer tecla para continuar' }
Procedure mensagemContinuar();
Begin
    writeln();
    writeln('<pressione qualquer tecla para continuar>');
    readkey();
End;

{ Retorna um erro quando a opção é inválida }
Procedure opcaoInvalida();
Begin
    clrScr();
    writeln('Opção inválida, tente novamente');
    mensagemContinuar();
End;

{ Tela de finalização do programa }
Procedure encerrarPrograma();
Begin
    ClrScr();
    close(arqProdutos);
    writeln('=> Programa encerrado');
    mensagemContinuar();
    exit;
End;


{ Tela do menu principal }
Function menuPrincipal: Integer;
Begin
    menuCabecalho('Padaria do Seu Zé');
    writeln('| 1. Incluir Produto');
    writeln('| 2. Alterar Produto');
    writeln('| 3. Relatório dos Produtos');
    writeln('| 4. Sobre o autor e o Programa');
    writeln('| 5. Sair ');
    menuLinha();
    write('ESCOLHA: ');
    readln(escolha);

    menuPrincipal := escolha;
End;

{ Grava um registro no arquivo }
Procedure gravarRegistro();
Begin
    write(arqProdutos, produtoMem);    
    writeln('>> Produto cadastrado');
    mensagemContinuar();
End;


Function validarNegativoInt(campo: String): Integer;
Var
    entrada: Integer;
    confirmacao: Boolean;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write(campo);
        readln(entrada);

        if entrada < 0 then
            Begin
                write('Valores negativos não são permitidos');
                mensagemContinuar();
            End
        Else
            Begin
                confirmacao := true;
            End;

    Until confirmacao = true;

    validarNegativoInt := entrada;
End;

Function validarNegativoDouble(campo: String): Double;
Var
    entrada: Double;
    confirmacao: Boolean;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write(campo);
        readln(entrada);

        if entrada < 0 then
            Begin
                write('Valores negativos não são permitidos');
                mensagemContinuar();
            End
        Else
            Begin
                confirmacao := true;
            End;

    Until confirmacao = true;

    validarNegativoDouble := entrada;
End;

Function validarCaracteres(campo: String; tamanho: Integer): String;
Var
    entrada: String;
    confirmacao: Boolean;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write(campo);
        readln(entrada);

        if length(entrada) > tamanho then
            Begin
                writeln('ERRO são permitidos apenas ', tamanho, ' caracteres para este campo');
                mensagemContinuar();
            End
        Else
            Begin
                confirmacao := true;
            End;

    Until confirmacao = true;

    validarCaracteres := entrada;
End;

Function validarStatus(lista: Array of Char): Char;
Begin
    validarStatus := 'N';
End;

{ Interface para cadastro de um novo produto }
Procedure incluirProduto();
Begin
    seek(arqProdutos, filesize(arqProdutos));

    menuCabecalho('ADICIONAR PRODUTO');

    produtoMem.cod := validarNegativoInt('Código: ');
    produtoMem.nome := validarCaracteres('Nome: ', 80);
    produtoMem.valor := validarNegativoDouble('Preço R$ ');
    produtoMem.qtd := validarNegativoInt('Quantidade: ');
    produtoMem.status := validarStatus(listaDeStatus);

    gravarRegistro(); 
End;

{ Altera as informações de cadastro de um produto }
Procedure alterarProduto();
Begin

End;

{ Relatório dos produtos cadastrados }
Procedure relatorioProdutos();
Begin

End;

{ Informações sobre o programa}
Procedure sobre(); 
Begin

End;



BEGIN
    Repeat 
        inicializarGlobais();
        configArquivo();

        escolha := menuPrincipal;

        Case escolha of
            1: incluirProduto();
            2: alterarProduto();
            3: relatorioProdutos();
            4: sobre();
            5: encerrarPrograma();
        else
            opcaoInvalida();
        end;
        
    Until escolha = 5;
    
END.
