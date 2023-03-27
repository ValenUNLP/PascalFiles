program Ej7P1;
type
    Novela = record
        cod: integer;
        nombre: string;
        genero: string;
        precio: integer;
    end;
    ArchNovelas = file of Novela;
////////////////////////////////////////
procedure CargarNovela(var n: Novela);
begin
    readln(n.cod);
    if(n.cod <> -1) then begin
        readln(n.nombre);
        readln(n.genero);
        readln(n.precio);
    end;
end;
///////////////////////////////////////////
procedure CargarTxT(var txt: text);
var n: Novela;
begin
    Assign(txt, 'novelas.txt');
    Rewrite(txt);
    CargarNovela(n);
    
    while (n.cod <> -1) do begin
        with n do begin
            writeln(txt, cod,' ', precio,' ', genero);
            writeln(txt, nombre);
        end;
        CargarNovela(n);
    end;
    Close(txt);
end;
/////////////////////////////////////////////////////
procedure ImportarData(var Novelas: ArchNovelas; var txt: text);
var n: Novela;
begin
    Reset(txt);
    Reset(Novelas);
    
    while not eof(txt) do begin
        with n do begin
            readln(txt, cod, precio, genero);
            readln(txt, nombre);
        end;
            write(Novelas, n);
    end;
    
    
    Close(txt);
    Close(Novelas);
end;
/////////////////////////////////////////////////////
procedure ActualizarNovela(var Novelas: ArchNovelas; pos: integer; n: Novela);
begin
    Seek(Novelas, pos);
    write(Novelas, n);
end;
/////////////////////////////////////////////////////
procedure AgregarNovela(var Novelas: ArchNovelas; n: Novela);
begin
    Seek(Novelas, Filesize(Novelas));
    write(Novelas, n);
end;
/////////////////////////////////////////////////////
procedure AgregarActualizar(var Novelas: ArchNovelas);
var n, aux: Novela; ok: boolean;
begin
    ok := true;
    CargarNovela(n);
    
    while(n.cod <> -1) and ok do begin
        Reset(Novelas);
        while not eof(Novelas) do begin
               
            read(Novelas, aux);
            if(aux.cod = n.cod) then begin
                ActualizarNovela(Novelas, filePos(Novelas)-1, n);
                ok := false;
            end;
            
        end;
        
        if ok then begin
            AgregarNovela(Novelas, n);
        end;
        CargarNovela(n);
        ok := true;
    end;
    Close(Novelas);
end;
/////////////////////////////////////////////////////
var Novelas: ArchNovelas; NovelasTxT: text; aux: Novela;
begin
  Assign(Novelas, 'Novelas.bi');
  Rewrite(Novelas);
  CargarTxT(NovelasTxT);
  ImportarData(Novelas, NovelasTxT);
  AgregarActualizar(Novelas);
end.

