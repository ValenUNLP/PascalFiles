program Ej4P3;

type
    reg_flor = record
        nombre: String[45];
        cod:integer;
    end;
    tArchFlores = file of reg_flor;


///////////////////////////////////////
procedure CargarFlor(var reg: reg_flor);
begin

    readln(reg.cod);
    if(reg.cod <> -1) then readln(reg.nombre);

end;
//////////////////////////////////////
procedure InicializarArchivo(var a: tArchFlores);
var flor: reg_flor;
begin
    Assign(a, 'Archivo.bi');
    Rewrite(a);
    
    flor.cod := 0;
    flor.nombre := 'cabecera';
    
    write(a, flor);
    
    Close(a);
end;
//////////////////////////////////////
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var cabecera, data: integer; aux, aux2:reg_flor;
begin
    Reset(a);
    
    read(a, aux);
    cabecera := aux.cod;
    aux2.nombre := nombre;
    aux2.cod := codigo;
    
    if(cabecera < 0) then begin
    
        seek(a, cabecera*-1);
        read(a, aux);
        seek(a, filepos(a)-1);
        write(a, aux2);
        seek(a, 0);
        write(a, aux);
    
    end else begin
        seek(a, filesize(a));
        write(a, aux2);
    end;
    
    Close(a);
end;

//////////////////////////////////////
procedure CargarArchivo(var a: tArchFlores);
var flor: reg_flor;
begin

    CargarFlor(flor);
    
    while(flor.cod <> -1) do begin
        agregarFlor(a, flor.nombre, flor.cod);
        CargarFlor(flor);
    end;
    
end;
//////////////////////////////////////
procedure BorrarFlor(var a: tArchFlores; cod: integer);
var flor,aux: reg_flor; pos:integer;
begin

    Reset(a);
    read(a, flor);
    aux := flor;
    
    while(flor.cod <> cod) do read(a, flor);
    
    seek(a, filepos(a) - 1);
    pos := -filepos(a);
    write(a, aux);
    seek(a, 0);
    
    flor.cod := pos;
    write(a, flor);
    
    Close(a);

end;
//////////////////////////////////////
procedure ListarFlores(var a: tArchFlores);
var flor: reg_flor;
begin

    Reset(a);
    
    while(not eof(a)) do begin
        read(a ,flor);
        if(flor.cod > 0) then writeln(flor.cod, ' ', flor.nombre);
    
    end;
    
    Close(a);

end;
//////////////////////////////////////
var a: tArchFlores; flor:reg_flor;
begin
  InicializarArchivo(a);
  CargarArchivo(a);
  BorrarFlor(a, 4);
  BorrarFlor(a, 5);
  agregarFlor(a,'AGREGAR', 19);
  ListarFlores(a);
end.
