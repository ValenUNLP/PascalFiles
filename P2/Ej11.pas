program Ej11P2;

const
    cantDetalles = 2;
    valorAlto = 'zzz';

type
    palabra = string[20];
    Censo = record
        Provincia: palabra;
        codLocalidad: integer;
        alfabetizados: integer;
        encuestados: integer;
    end;

    regMaestro = record
        Provincia: palabra;
        alfabetizados: integer;
        encuestados: integer; 
    end;
    
    ArchMaestro = file of regMaestro;
    ArchDetalle = file of Censo;
    
    Detalles = array[1..cantDetalles] of ArchDetalle;
    RegDetalles = array[1..cantDetalles] of Censo;
//////////////////////////////////////////////////////////////
procedure CargarCenso(var c: Censo);
begin

    with c do begin
    
        readln(Provincia);
        
        if(Provincia <> 'z') then begin
        
            readln(codLocalidad);
            readln(alfabetizados);
            readln(encuestados);
        
        end;
    
    end;

end;
//////////////////////////////////////////////////////////////
procedure CargarRegMaestro(var c: regMaestro);
begin

    with c do begin
    
        readln(Provincia);
        
        if(Provincia <> 'z') then begin
        
            readln(alfabetizados);
            readln(encuestados);
        
        end;
    
    end;

end;
//////////////////////////////////////////////////////////////
procedure CargarDetalle(var d: ArchDetalle);
var c: Censo;
begin

    Rewrite(d);
    
    CargarCenso(c);
    
    while(c.Provincia <> 'z') do begin
    
        write(d, c);
        CargarCenso(c);
    
    end;
    
    Close(d);

end;
//////////////////////////////////////////////////////////////
procedure CargarMaestro(var d: ArchMaestro);
var c: regMaestro;
begin
    Assign(d, 'Maestro.bi');
    Rewrite(d);
    
    CargarRegMaestro(c);
    
    while(c.Provincia <> 'z') do begin
    
        write(d, c);
        CargarRegMaestro(c);
    
    end;
    
    Close(d);

end;
//////////////////////////////////////////////////////////////
procedure CargarData(var Detalles: Detalles; var Maestro: ArchMaestro);
var i: integer; i_str: string;
begin
    CargarMaestro(Maestro);
    
    
    for i:=1 to cantDetalles do begin
        Str(i, i_str);
        Assign(Detalles[i], 'Detalle-'+i_str);
        CargarDetalle(Detalles[i]);
    end;
    
    
    
end;
//////////////////////////////////////////////////////////////
procedure Leer(var d: ArchDetalle; var c:Censo);
begin
    if(not eof(d)) then read(d, c)
                   else c.Provincia := valorAlto;

end;
//////////////////////////////////////////////////////////////
procedure Minimo(var Detalles: Detalles; var Registros: RegDetalles; var min: Censo);
begin

    if(min.Provincia = 'Ninguna') then begin
    
        if(Registros[1].Provincia[1] <= Registros[2].Provincia[1]) then begin
            min := Registros[1];
            Leer(Detalles[1], Registros[1]);
        end else begin
            min := Registros[2];
            Leer(Detalles[2], Registros[2]);
        end;
        
    end else begin
        if(Registros[1].Provincia = min.Provincia) then begin
            min := Registros[1];
            Leer(Detalles[1], Registros[1]);
        end else
            if(Registros[2].Provincia = min.Provincia) then begin
                min := Registros[2];
                Leer(Detalles[2], Registros[2]);
            end else 
                if(Registros[1].Provincia[1] <= Registros[2].Provincia[1]) then begin
                    min := Registros[1];
                    Leer(Detalles[1], Registros[1]);
                end else begin
                    min := Registros[2];
                    Leer(Detalles[2], Registros[2]);
                    end;
    end;

end;
//////////////////////////////////////////////////////////////
procedure ActualizarMaestro(var Maestro: ArchMaestro; var Detalles: Detalles);
var Registros: RegDetalles; min: Censo; i, alfabetizadosProvincia, encuestadosProvincia: integer;
    Provincia: palabra; aux: regMaestro;
begin
    Reset(Maestro);
    for i:=1 to cantDetalles do begin
        Reset(Detalles[i]);
        Leer(Detalles[i], Registros[i]);
    end;
    
    read(Maestro, aux);
    Minimo(Detalles, Registros, min);
    while (min.Provincia <> valorAlto) do begin
    
        while (min.Provincia <> aux.Provincia) do read(Maestro, aux);
        
        Provincia := min.Provincia;
        alfabetizadosProvincia := 0;
        encuestadosProvincia := 0;
        
        
        while (Provincia = min.Provincia) do begin
        
            alfabetizadosProvincia := alfabetizadosProvincia + min.alfabetizados;
            encuestadosProvincia := encuestadosProvincia + min.encuestados;
            Minimo(Detalles, Registros, min);
        end;
            aux.alfabetizados := aux.alfabetizados + alfabetizadosProvincia;
            aux.encuestados := aux.encuestados + encuestadosProvincia;
            Seek(Maestro, filepos(Maestro) -1);
            write(Maestro, aux);
    end;
    
    Close(Maestro);
    for i:=1 to cantDetalles do begin
        Close(Detalles[i]);
    end;
end;
//////////////////////////////////////////////////////////////
var arrDetalles: Detalles; Maestro: ArchMaestro; a :regMaestro;
begin
    CargarData(arrDetalles, Maestro);
    
    ActualizarMaestro(Maestro, arrDetalles);

end.
