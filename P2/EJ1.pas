program Ej1P2;
const 
    valorAlto = 9999;
type
palabra = string[20];
    
    Empleado = record
        cod: integer;
        nombre: palabra;
        monto: integer;
    end;
    ArchEmpleados = file of Empleado;
//////////////////////////////////////////////////// 
procedure CargarRegistro(var e: Empleado);
begin
    readln(e.cod);
    if(e.cod <> -1) then begin
    readln(e.nombre);
    readln(e.monto);
    end;
end;
////////////////////////////////////////////////////
procedure CrearArchivo(var Archivo: ArchEmpleados);
var e: Empleado;
begin

    Assign(Archivo, 'EmpleadosDetalle.bi');
    Rewrite(Archivo);
    CargarRegistro(e);
  
    while (e.cod <> -1) do begin
        write(Archivo, e);
        CargarRegistro(e);
    end;
    Close(Archivo);
end;
////////////////////////////////////////////////////
procedure Leer(var Archivo: ArchEmpleados; var e: Empleado);
begin
    if(not eof(Archivo)) then read(Archivo, e)
    else e.cod := valorAlto;
end;
////////////////////////////////////////////////////
procedure TestingArchivo(var Archivo: ArchEmpleados);
var txt: text; e: Empleado;
begin
    Assign(txt, 'Prueba.txt');
    Rewrite(txt);
    Reset(Archivo);
    
    while(not eof(Archivo)) do begin
        read(Archivo, e);
        
        with e do begin
            writeln(txt, cod, ' ', nombre, ' ', monto);
        end;
    end;
    
    Close(txt);
    Close(Archivo);
end;
////////////////////////////////////////////////////
procedure Compactar(var Detalle: ArchEmpleados; var Master: ArchEmpleados);
var e, actual: Empleado;
begin
    Assign(Master, 'Master.bi');
    Rewrite(Master);
    Reset(Detalle);
    
    Leer(Detalle, e);
    
    while (e.cod <> valorAlto) do begin
        actual := e;
        actual.monto := 0;
        
        while (e.cod = actual.cod) do begin
            actual.monto := actual.monto + e.monto;
            Leer(Detalle, e);
        end;
    write(Master, actual);
    end;
    
  
    Close(Master);
    Close(Detalle);
end;
////////////////////////////////////////////////////
var EmpleadosDetalle, EmpleadosMaster: ArchEmpleados;
begin
    CrearArchivo(EmpleadosDetalle);
    
    Compactar(EmpleadosDetalle, EmpleadosMaster);
    //TestingArchivo(EmpleadosDetalle);
    TestingArchivo(EmpleadosMaster);
end.
