program Ej8P3;

type
    Distribucion = record
        
        nombre: string;
        anoLanzamiento: integer;
        version: integer;
        cantDev: integer;
        
    end;
    
    ArchDistribuciones = file of Distribucion;

///////////////////////////////////////////////////////////
procedure CargarDistribucion(var d: Distribucion);
begin

    with d do begin
    
        readln(nombre);
        
        if(nombre <> 'fin') then begin
        
            readln(anoLanzamiento);
            readln(version);
            readln(cantDev);
        
        end;
    
    end;

end;
///////////////////////////////////////////////////////////
procedure InicializarArchivo(var a: ArchDistribuciones);
var d:Distribucion;
begin
    Assign(a, 'Archivo.bi');
    Rewrite(a);
    
    d.nombre := 'Cabecera';
    d.anoLanzamiento := -1;
    d.version := -1;
    d.cantDev := 0;
    
    write(a, d);
    
    Close(a);
end;
///////////////////////////////////////////////////////////
function ExisteDistribucion(var a:ArchDistribuciones; distribucion: string): boolean;
var d:Distribucion; Encontrado: boolean;
begin
    Encontrado := false;
    Reset(a);
    while(not eof(a) and (not Encontrado)) do begin
        read(a, d);
        
        if(d.nombre = distribucion) then begin
            if(d.cantDev > 0) then Encontrado := true;
        end;
    end;
    
    Close(a);
    ExisteDistribucion := Encontrado;

end;
///////////////////////////////////////////////////////////
procedure AltaDistribucion(var a:ArchDistribuciones);
var d, aux:Distribucion; cabecera: integer;
begin

    CargarDistribucion(d);
    while(d.nombre <> 'fin') do begin

        if(ExisteDistribucion(a, d.nombre)) then begin
            writeln('Esa distribucion ya existe');
        end
        else begin
    
            Reset(a);
            read(a, aux);
            //writeln(aux.nombre);
            cabecera := aux.cantDev;
            if(cabecera <> 0) then begin
                //writeln(cabecera);
                Seek(a, -cabecera);
                read(a, aux);
                Seek(a, filepos(a)-1);
                write(a, d);
                Seek(a, 0);
                write(a, aux);
            end else begin
                Seek(a, filesize(a));
                write(a, d);
            end;
        
        
            Close(a);
    
        end;
        CargarDistribucion(d);
    end;
end;
///////////////////////////////////////////////////////////
procedure BajaDistribucion(var a: ArchDistribuciones);
var d, cabecera: Distribucion; nombre: string;

begin

    readln(nombre);
    
        while(nombre <> 'fin') do begin
            if(ExisteDistribucion(a, nombre)) then begin
                Reset(a);
                read(a, d);
                cabecera := d;
                while(d.nombre <> nombre) do read(a, d);
            
                Seek(a, filepos(a)-1);
                write(a, cabecera);
                cabecera.cantDev := -(filepos(a)-1);
                Seek(a, 0);
                write(a, cabecera);
            end else begin
                writeln('No existe pa');
            end;
            readln(nombre);
            Close(a)
        end;

end;
///////////////////////////////////////////////////////////
var a: ArchDistribuciones; d:Distribucion;
begin
    InicializarArchivo(a);
    AltaDistribucion(a);
    BajaDistribucion(a);
    Reset(a);
    
    
    while(not eof(a)) do begin
        read(a, d);
        if(d.cantDev >0) then
        writeln(d.nombre, ' ', d.cantDev);
    
    end;
    
    Close(a);
    
end.
