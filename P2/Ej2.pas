program Ej2P2;
const
valorAlto = 9999;

type
    palabra = string[20];
    
    Alumno = record
        cod: integer;
        nombre: palabra;
        apellido: palabra;
        cursadas: integer;
        finales: integer;
    end;
    
    AlumnoDetalle = record
        cod: integer;
        estado: palabra;
    end;
    ArchAlumnosDetalle = file of AlumnoDetalle;
    ArchAlumnos = file of Alumno;
/////////////////////////////////////////////////////
procedure CargarAlumno(var a: Alumno);
begin
    with a do begin
        readln(cod);
        if(cod <> -1) then begin
            readln(nombre);
            readln(apellido);
            readln(cursadas);
            readln(finales);
        end;
    end;
end;
/////////////////////////////////////////////////////
procedure CargarAlumnoDetalle(var a: AlumnoDetalle);
begin
    with a do begin
        readln(cod);
        if(cod <> -1) then begin
            readln(estado);
        end;
    end;
end;
/////////////////////////////////////////////////////
procedure CrearArchivo(var Archivo: ArchAlumnos);
var a: Alumno;
begin

    Assign(Archivo, 'Alumnos.bi');
    Rewrite(Archivo);

    CargarAlumno(a);
    
    while(a.cod <> -1)do begin
        write(Archivo, a);
        CargarAlumno(a);
    end;

    Close(Archivo);

end;
/////////////////////////////////////////////////////
procedure CrearArchivoDetalle(var Archivo: ArchAlumnosDetalle);
var a: AlumnoDetalle;
begin

    Assign(Archivo, 'AlumnosDetalle.bi');
    Rewrite(Archivo);

    CargarAlumnoDetalle(a);
    
    while(a.cod <> -1)do begin
        write(Archivo, a);
        CargarAlumnoDetalle(a);
    end;

    Close(Archivo);

end;
/////////////////////////////////////////////////////
procedure TestingArchivo(var Archivo: ArchAlumnos);
var txt: text; a: Alumno;
begin
    Assign(txt, 'Prueba.txt');
    Rewrite(txt);
    Reset(Archivo);
    
    while(not eof(Archivo)) do begin
        read(Archivo, a);
        
        with a do begin
            writeln(txt, cod, ' ', nombre, ' ', apellido, ' ', cursadas, ' ', finales);
        end;
    end;
    
    Close(txt);
    Close(Archivo);
end;
/////////////////////////////////////////////////////
procedure LeerDetalle(var Detalle: ArchAlumnosDetalle; var aD: AlumnoDetalle);
begin
    if(not eof(Detalle)) then read(Detalle, aD)
                         else aD.cod := valorAlto;
end;
/////////////////////////////////////////////////////
procedure ActualizarMaestro(var Master: ArchAlumnos; var Detalle: ArchAlumnosDetalle);
var aD: AlumnoDetalle; aM: Alumno; codActual: integer; 
begin
    Reset(Master);
    Reset(Detalle);
    
        read(Master, aM);
        LeerDetalle(Detalle, aD);
    while (aD.cod <> valorAlto) do begin
    
        while (aM.cod <> aD.cod) do read(Master, aM);
        
        codActual := aD.cod;
        while(aD.cod = codActual) do begin
       
            if(aD.estado = 'Cursada') then aM.cursadas := aM.cursadas + 1
                                      else aM.finales := aM.finales + 1;
            Seek(Master, filepos(Master) - 1);
            write(Master, aM);
            LeerDetalle(Detalle, aD);
        end;

    end;
    
    Close(Master);
    Close(Detalle);
end;
/////////////////////////////////////////////////////
procedure MasDe4Cursadas(var Archivo: ArchAlumnos);
var a: Alumno;
begin
    
    Reset(Archivo);
    
    while (not eof(Archivo)) do begin
        read(Archivo, a);
        if(a.cursadas > 4) then begin
        
        with a do writeln(cod, ' ', nombre, ' ', apellido, ' ', cursadas, ' ', finales);
        
        end;
    end;
    Close(Archivo);
end;
/////////////////////////////////////////////////////
var AlumnosMaster: ArchAlumnos; AlumnosDetalle: ArchAlumnosDetalle;
begin
  CrearArchivo(AlumnosMaster);
  CrearArchivoDetalle(AlumnosDetalle);
  ActualizarMaestro(AlumnosMaster, AlumnosDetalle);
  
  MasDe4Cursadas(AlumnosMaster);
end.
