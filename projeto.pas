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
    ClrScr();
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

{ Valição de números inteiros negativos }
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

{ Validação de números reais negativos }
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

{ Valida a quantidade de caracateres no nome do produto }
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

{ Valida a entrada do status do produto }
Function validarStatus(lista: Array of Char): Char;
Var
    entrada: Char;
    confirmacao: Boolean;
    i: Integer;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write('Status do produto [A-Ativo/I-nativo]: ');
        readln(entrada);

        for i := 0 to length(lista) do
        Begin
            if lista[i] = entrada then
                confirmacao := true;
        End;

        if not confirmacao then
        Begin
            writeln('Status inválido. Utilize "I" ou "A"');
            mensagemContinuar();
        End;

    Until confirmacao = true;

    validarStatus := UpCase(entrada);

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

{ Imprime o produto da variável produtoMem }
Procedure imprimeProduto();
Begin
    menuLinha();
    writeln('Código: ', produtoMem.cod);
    writeln('Nome..: ', produtoMem.nome);
    writeln('Valor.: ', produtoMem.valor:2:2);
    writeln('Qtd...: ', produtoMem.qtd);
    writeln('Status: ', produtoMem.status);
End;


{ Verifica se um produto existe no arquivo e carrega para a memória }
Function encontrarProduto(codigo: Integer): Boolean;
Begin
    seek(arqProdutos, 0);

    while (not eof(arqProdutos)) do
    Begin
        read(arqProdutos, produtoMem);

        if produtoMem.cod = codigo then
        begin
            encontrarProduto := true;
            break;
        End;

    End;

    encontrarProduto := false;
End;

Procedure editarProduto();
Begin
    ClrScr();
    menuCabecalho('Você editará o produto ');
    writeln('Código: ', produtoMem.cod);
    mensagemContinuar();

    produtoMem.nome := validarCaracteres('Nome: ', 80);
    produtoMem.valor := validarNegativoDouble('Preço R$ ');
    produtoMem.qtd := validarNegativoInt('Quantidade: ');
    produtoMem.status := validarStatus(listaDeStatus);

    gravarRegistro();
End;

{ Altera as informações de cadastro de um produto }
Procedure alterarProduto();
Var
    opcaoValida, produtoEncontrado: Boolean;
    codigo: Integer;
    escolha: Char;
Begin
    opcaoValida := false;

    Repeat
        ClrScr();
        menuCabecalho('ALTERAR PRODUTO');
        
        codigo := validarNegativoInt('Código do produto: ');
        produtoEncontrado := encontrarProduto(codigo);
        
        if not produtoEncontrado then
            opcaoValida := true
        else
            begin
                writeln('Produto não encontrado. Deseja procurar outro? S/N');
                read(escolha);

                if (escolha = 'n') OR (escolha = 'N') then
                    opcaoValida := true;
            end;
    Until opcaoValida = true;


    if produtoEncontrado then
        editarProduto();

    menuLinha();
    mensagemContinuar();
End;


{ Relatório dos produtos cadastrados }
Procedure relatorioProdutos();
Begin
    seek(arqProdutos, 0);

    ClrScr();
    menuCabecalho('PRODUTOS CADASTRADOS');

    while not eof(arqProdutos) do
    Begin
        read(arqProdutos, produtoMem);
        imprimeProduto();
    End;
    menuLinha();
    mensagemContinuar();
End;

{ Informações sobre o programa}
Procedure sobre(); 
Begin
    writeln('Acadêmico: Nathanael Cavalcanti Bonfim - 2020');
    writeln('Disciplina: Algoritmos');

End;

BEGIN

    inicializarGlobais();
    configArquivo();

    Repeat 
        
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
