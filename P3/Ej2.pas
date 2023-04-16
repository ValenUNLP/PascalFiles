
program Ej2P3;
const
    valorAlto = 9999;
type
    palabra = string[20];
    
    Asistente = record
        cod: integer;
        apellido: palabra;
    end;
    
    ArchivoAsistentes = file of Asistente;
//////////////////////////////////////////////////
procedure CargarAsistente(var a: Asistente);
begin

    with a do begin
        
        readln(cod);
        
        if(cod <> -1) then readln(apellido);
    
    end;

end;

//////////////////////////////////////////////////
procedure CargarArchivo(var Archivo: ArchivoAsistentes);
var a:Asistente;
begin

    Assign(Archivo, 'Archivo.bi');
    Rewrite(Archivo);
    
    CargarAsistente(a);
    
    while (a.cod <> -1) do begin
        write(Archivo, a);
        CargarAsistente(a);
    end;
    
    Close(Archivo);

end;
//////////////////////////////////////////////////
procedure Leer(var Archivo: ArchivoAsistentes; var a: Asistente);
begin

    if(not eof(Archivo)) then read(Archivo, a)
                         else a.cod := valorAlto;

end;
//////////////////////////////////////////////////
procedure Borrar(var Archivo: ArchivoAsistentes);
var a: Asistente;
begin

    Reset(Archivo);
    
    Leer(Archivo, a);
    
    while (a.cod <> valorAlto) do begin
        if(a.cod < 10) then begin
            a.apellido := '@' + a.apellido;
            Seek(Archivo, filepos(Archivo)- 1);
            write(Archivo, a);
        end;
        Leer(Archivo, a);
    end;
    
    Close(Archivo);

end;
//////////////////////////////////////////////////
var Archivo: ArchivoAsistentes; a: Asistente;
begin
  CargarArchivo(Archivo);
  Borrar(Archivo);
  Reset(Archivo);
  
    while(not eof(Archivo)) do begin
        read(Archivo, a);
        writeln(a.cod, ' ', a.apellido);
    end;
  
  Close(Archivo);
  
end.
