program Parcial2;
type
    dinosaurio = record
       cod: integer;
       tipo: string;
       altura: integer;
       peso: integer;
       descripcion: string;
       zona: string;
    end;
    
    Archivo = file of dinosaurio;
//////////////////////////////////////////////
procedure cargarDinosaurio(var d: dinosaurio);
begin

    readln(d.cod);
    if(d.cod <> -1) then begin
    
        readln(d.tipo);
        readln(d.altura);
        readln(d.peso);
        readln(d.descripcion);
        readln(d.zona);
    
    end;

end;
//////////////////////////////////////////////
procedure cargarArchivoDinosaurios(var Archivo: Archivo);
var d: dinosaurio;
begin
    Rewrite(Archivo);
    
    d.cod := 0;
    d.tipo := 'a';
    d.altura := 0;
    d.peso := 0;
    d.descripcion := 'a';
    d.zona := 'a';
    
    write(Archivo, d);
    cargarDinosaurio(d);
    while(d.cod <> -1) do begin
        write(Archivo, d);
        cargarDinosaurio(d);
    end;

    Close(Archivo);
end;
//////////////////////////////////////////////
procedure eliminarDinosaurio(var Arch: Archivo);
var codElim: integer; d, cabecera: dinosaurio;
begin
    
    readln(codElim);
    
    while(codElim <> -1) do begin
        Reset(Arch);    
        read(Arch, cabecera);
        read(Arch, d);
        
        while(d.cod <> codElim) and (not eof(Arch)) do read(Arch, d);
        
        if(d.cod <> codElim) then begin
            writeln('Ese codigo no existe, porfavor ingrese uno existente');
        end else begin
        
        d.cod := ((filepos(Arch) - 1)*-1);
        seek(Arch, filepos(Arch) - 1);
        write(Arch, cabecera);
        seek(Arch, 0);
        write(Arch, d);
            
        end;
        
        readln(codElim);
    end;
    
    
    Close(Arch);

end;

//////////////////////////////////////////////
procedure agregarDinosaurios(var a: Archivo; registro: dinosaurio);
var d: dinosaurio; posAgregar: integer;
begin
    Reset(a);
    read(a, d);
    if(d.cod = 0) then begin
        seek(a, filesize(a));
        write(a, registro);
    
    end else begin
    
        posAgregar := (d.cod * -1);
        seek(a, posAgregar);
        read(a, d);
        Seek(a, filepos(a)- 1);
        write(a, registro);
        Seek(a, 0);
        write(a, d);
    end;
    
    
    
    Close(a);
end;
//////////////////////////////////////////////
procedure insertarDinosaurios(var a: Archivo);
var d: dinosaurio;
begin

    cargarDinosaurio(d);
    
    while(d.cod <> -1) do begin
        agregarDinosaurios(a, d);
        cargarDinosaurio(d);
    end;

end;
//////////////////////////////////////////////
procedure reporte(var a: Archivo; var txt: text);
var d: dinosaurio;
begin
    Reset(a);
    Rewrite(txt);
    
    while(not eof(a)) do begin
        read(a, d);
        if(d.cod > 0) then begin
        
        writeln(txt, d.cod, ' ', d.tipo, ' ', d.altura, ' ', d.peso, ' ', d.descripcion, ' ', d.zona);
        
        end;
    
    end;
    
    Close(a);
    Close(txt);

end;
//////////////////////////////////////////////
var ArchivoDinosaurios: Archivo; txt: text;
begin
  Assign(ArchivoDinosaurios, 'Archivo.bi');
  Assign(txt, 'text');
  cargarArchivoDinosaurios(ArchivoDinosaurios);
  ////Parcial2
  eliminarDinosaurio(ArchivoDinosaurios);
  insertarDinosaurios(ArchivoDinosaurios);
  reporte(ArchivoDinosaurios, txt);

  
end.
