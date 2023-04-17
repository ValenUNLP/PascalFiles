program Ej6P3;

type
    Ropa = record
        cod: integer;
        descripcion: string;
        colores: string;
        tipo_prenda: string;
        stock: integer;
        precio: integer;
    end;
    Maestro = file of Ropa;
    Bajas = file of integer;

////////////////////////////////////////
procedure CargarRopa(var r: Ropa);
begin

    with r do begin
    
        readln(cod);
        if(cod <> -1) then begin
        
            readln(descripcion);
            readln(colores);
            readln(tipo_prenda);
            readln(stock);
            readln(precio);
        
        end;
    
    end;

end;
////////////////////////////////////////
procedure CargarDatos(var Maestro: Maestro; var Bajas: Bajas);
var r: Ropa; n: integer;
begin
    Assign(Maestro, 'Maestro.bi');
    Assign(Bajas, 'Bajas.bi');
    Rewrite(Maestro);
    Rewrite(Bajas);
    
    
    CargarRopa(r);
    while(r.cod <> -1) do begin
        write(Maestro, r);
        CargarRopa(r);
    end;
    
    readln(n);
    while(n <> -1) do begin
        write(Bajas, n);
        readln(n);
    end;
    
    Close(Maestro);
    Close(Bajas);

end;
////////////////////////////////////////
procedure DarDeBaja(var Maestro: Maestro; var Bajas: Bajas);
var newMaestro: Maestro; r: Ropa; codBaja: integer;
begin
    Assign(newMaestro, 'Archivo.bi');
    Rewrite(newMaestro);
    
    Reset(Bajas);
    
    while(not eof(Bajas)) do begin
        
        Reset(Maestro);
        read(Maestro, r);
        read(Bajas, codBaja);
        while(codBaja <> r.cod) do read(Maestro, r);
        Seek(Maestro, filepos(Maestro)- 1);
        r.stock := -1;
        write(Maestro, r);
        
    end;
    Reset(Bajas);
    
    Reset(Maestro);
    
    while(not eof(Maestro)) do begin
        read(Maestro, r);
        if(r.stock > 0) then write(newMaestro, r);
    end;
    Close(newMaestro);
    Close(Maestro);
    
    Erase(Maestro);
    Rename(newMaestro, 'Maestro.bi');
end;
////////////////////////////////////////
var M: Maestro; B: Bajas; r: Ropa;
begin
    CargarDatos(M, B);
    DarDeBaja(M,B);
    
    Reset(M);
    
    while(not eof(M)) do begin
        read(M, r);
        writeln(r.cod, ' ', r.stock, ' ', r.precio);
    end;
    
    Close(M);
end.
