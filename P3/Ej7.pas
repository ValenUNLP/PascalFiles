program Ej7P3;
type
    Ave = record
        cod: integer;
        nombreEspecie: string;
        familia: string;
        desc: string;
        zona: string;
    end;
    
    Maestro = file of Ave;
///////////////////////////////////////
procedure CargarAve(var a: Ave);
begin
    readln(a.cod);
    if(a.cod <> -1) then begin
    
        readln(a.nombreEspecie);
        readln(a.familia);
        readln(a.desc);
        readln(a.zona);
    end;
end;
//////////////////////////////////////
procedure CargarMaestro(var M: Maestro);
var a: Ave;
begin

    Assign(M, 'Maestro.bi');
    Rewrite(M);

    CargarAve(a);
    
    while(a.cod <> -1) do begin
        write(M, a);
        CargarAve(a);
    end;


    Close(M);
end;
//////////////////////////////////////
procedure BorrarRegistros(var M:Maestro; especie: string);
var a: Ave;
begin

    Reset(M);
    
    while(not eof(M)) do begin
        read(M, a);
        if(a.nombreEspecie = especie) then begin 
            a.cod := -1;
            seek(M, filepos(M)-1);
            write(M, a);
        end;
    end;
    
    Close(M);

end;
//////////////////////////////////////
procedure Truncar(var M: Maestro);
var a: Ave; pos, i: integer;
begin
    i:= 1;
    Reset(M);
    read(M, a);
    
    while (not eof(M)) do begin
    
        while((a.cod <> -1) and (not eof(M))) do read(M, a);
        pos := filepos(M) - 1;
        
        if(not eof(M)) then begin
        
        
        Seek(M,filesize(M)-i);
        read(M, a);
        
        while ((a.cod = -1) and (i<> filesize(M))) do begin
            i := i + 1;
            Seek(M,filesize(M)-i);
            read(M, a);
        end;

        if(pos >= filepos(M)-1) then begin
            Seek(M, pos);
            truncate(M);
        
        end 
        else begin
            Seek(M, filepos(M) - 1);
            truncate(M);
        
            Seek(M ,pos);
            write(M, a);
        
            Seek(M, pos + 1);
        end;
    end else begin
        if(a.cod = -1) then begin
            Seek(M, pos);
            truncate(M);
        end;
    
    end;
    end;
    Close(M);
end;
//////////////////////////////////////
procedure Bajas(var M: Maestro);
var especie: string;
begin

    readln(especie);
    while(especie <> 'fin') do begin
        BorrarRegistros(M, especie);
        readln(especie);
    end;
    
    Truncar(M);
end;
//////////////////////////////////////
var M: Maestro; a: Ave;
begin
  CargarMaestro(M);
  Bajas(M);
  
  Reset(M);
  while(not eof(M)) do begin
    read(M, a);
    writeln(a.cod, ' ', a.nombreEspecie);
  
  end;

    Close(M);
end.
