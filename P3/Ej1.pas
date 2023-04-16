program Ej1P3;
const
    valorAlto = 9999;
type
    palabra = string[20];
    Empleado = record
        cod: integer;
        apellido: palabra;
        nombre: palabra;
        edad: integer;
        dni: integer;
    end;
    
    ArchivoEmpleados = file of Empleado;
////////////////////////////////////////////
procedure CargarEmpleado(var e: Empleado);
begin

    with e do begin
    
        readln(apellido);
        
        if(apellido <> 'fin') then begin
        
            readln(nombre);
            readln(cod);
            readln(edad);
            readln(dni);
        
        end;
    
    end;

end;
////////////////////////////////////////////
procedure CargarArchivoEmpleados(var Archivo: ArchivoEmpleados);
var e: Empleado;
begin

    Assign(Archivo, 'ArchivoEmpleados.bi');
    Rewrite(Archivo);
    
    CargarEmpleado(e);
    
    while(e.apellido <> 'fin') do begin
        write(Archivo, e);
        CargarEmpleado(e);
    end;
    
    Close(Archivo);
end;
////////////////////////////////////////////
procedure Leer(var Archivo: ArchivoEmpleados; var e: Empleado);
begin
    if(not eof(Archivo)) then read(Archivo, e)
                         else e.cod := valorAlto;
end;
////////////////////////////////////////////
procedure AgregarEmpleado(var Archivo: ArchivoEmpleados);
var e, aux: Empleado; codAct: integer; ok: boolean;
begin
    ok := true;
    
    CargarEmpleado(e);
    
    while (e.apellido <> 'fin') do begin
        Reset(Archivo);
        Leer(Archivo, aux);
        
        codAct := e.cod;
        while ((aux.cod <> valorAlto) and ok) do begin
            if(codAct = aux.cod) then ok := false;
            Leer(Archivo, aux);
        end;
    
        if(ok) then write(Archivo, e);
        CargarEmpleado(e);
    end;
    
    Close(Archivo);

end;
////////////////////////////////////////////
procedure Borrar(var Archivo: ArchivoEmpleados; cod: integer);
var  e: Empleado; pos: integer;
begin

    Reset(Archivo);
    
    read(Archivo, e);
    
    while (e.cod <> cod) do read(Archivo, e);
    
    pos := filepos(Archivo) - 1;
    
    Seek(Archivo, filesize(Archivo) - 1);
    read(Archivo, e);
    Seek(Archivo, pos);
    write(Archivo, e);
    
    
    Seek(Archivo, filesize(Archivo) - 1);
    truncate(Archivo);

end;
////////////////////////////////////////////
var Archivo: ArchivoEmpleados;e: Empleado;
begin
  CargarArchivoEmpleados(Archivo);
  AgregarEmpleado(Archivo);
  Borrar(Archivo, 3);
  
  Reset(Archivo);
  
  while (not eof (Archivo)) do begin
        read(Archivo, e);
        writeln(e.cod);
  end;
  
  Close(Archivo);
  
end.
