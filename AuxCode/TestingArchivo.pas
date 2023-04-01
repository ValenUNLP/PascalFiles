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
