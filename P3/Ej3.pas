
program Ej2P3;
const
    valorAlto = 9999;
type
    palabra = string[20];
    
    Pelicula = record
        cod: integer;
        nombre: palabra;
    end;
    
    ArchivoPeliculas = file of Pelicula;
//////////////////////////////////////////////////
procedure CargarAsistente(var a: Pelicula);
begin

    with a do begin
        
        readln(cod);
        
        if(cod <> -1) then readln(nombre);
    
    end;

end;

//////////////////////////////////////////////////
procedure CargarArchivo(var Archivo: ArchivoPeliculas);
var a:Pelicula;
begin

    Assign(Archivo, 'Archivo.bi');
    Rewrite(Archivo);
    a.cod := 0;
    a.nombre := '';
    write(Archivo, a);
    CargarAsistente(a);
    
    while (a.cod <> -1) do begin
        write(Archivo, a);
        CargarAsistente(a);
    end;
    
    Close(Archivo);

end;
//////////////////////////////////////////////////
procedure Leer(var Archivo: ArchivoPeliculas; var a: Pelicula);
begin

    if(not eof(Archivo)) then read(Archivo, a)
                         else a.cod := valorAlto;

end;
//////////////////////////////////////////////////
procedure Borrar(var Archivo: ArchivoPeliculas; num: integer);
var a: Pelicula; pos,cabecera: integer;
begin

    Reset(Archivo);
    
    Leer(Archivo, a);
    cabecera := a.cod;
    
    while(a.cod <> num) do Leer(Archivo, a);
    pos := filepos(Archivo )-1;
    Seek(Archivo, filepos(Archivo)- 1);
    a.cod := cabecera;
    write(Archivo, a);
    Seek(Archivo, 0);
    a.cod := pos * -1;
    write(Archivo, a);
    Close(Archivo);

end;
//////////////////////////////////////////////////
procedure AgregarPelicula(var Archivo: ArchivoPeliculas; pe: Pelicula);
var p: Pelicula; pos, cabecera : integer;
begin
    
    Reset(Archivo);
    
    Leer(Archivo, p);
    
    if(p.cod < 0) then begin
    
        cabecera := p.cod;
        
        Seek(Archivo, cabecera*-1);
        read(Archivo, p);
        cabecera := p.cod;
        Seek(Archivo, filepos(Archivo) -1);
        write(Archivo, pe);
        Seek(Archivo, 0);
        p.cod := cabecera;
        write(Archivo, p);
    
    end else begin
        Seek(Archivo, filesize(Archivo));
        write(Archivo, pe);
    end;
    
    Close(Archivo);
end;
//////////////////////////////////////////////////
procedure ModificarPelicula(var Archivo: ArchivoPeliculas);
var newPelicula, aux: Pelicula;
begin
    Reset(Archivo);
    
    CargarAsistente(newPelicula);
    
    Leer(Archivo, aux);
    
    while(aux.cod <> newPelicula.cod) do Leer(Archivo, aux);
    
    Seek(Archivo, filepos(Archivo) - 1);
    
    write(Archivo, newPelicula);
    
    Close(Archivo);

end;
//////////////////////////////////////////////////
var Archivo: ArchivoPeliculas; a: Pelicula;
begin
  CargarArchivo(Archivo);
  Borrar(Archivo, 10);
  Borrar(Archivo, 3); 
  
  a.cod := 13;
  a.nombre := 'monster';
  
  AgregarPelicula(Archivo, a);
  AgregarPelicula(Archivo, a);
  AgregarPelicula(Archivo, a);
  
  ModificarPelicula(Archivo);
  
  Reset(Archivo);
  
    while(not eof(Archivo)) do begin
        read(Archivo, a);
        writeln(a.cod, ' ', a.nombre);
    end;
  
  Close(Archivo);
  
end.
