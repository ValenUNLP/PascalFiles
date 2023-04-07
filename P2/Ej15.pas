program Ej15P2;

const 
    valorAlto = 9999;
    cantDetalles = 2;

type 
    palabra = string[20];
    regMaestro = record
        codProvincia: integer;
        nombreProvincia: palabra;
        codLocalidad: integer;
        nombreLocalidad: palabra;
        sinLuz: integer;
        sinGas: integer;
        sinSanitario: integer;
        sinAgua: integer;
        sinTecho: integer;
    end;
    
    regDetalle = record
        codProvincia: integer;
        codLocalidad: integer;
        conLuz: integer;
        conGas: integer;
        conSanitario: integer;
        conAgua: integer;
        conTecho: integer;
    end;
    
    Maestro = file of regMaestro;
    Detalle = file of regDetalle;
    
    Detalles = array[1..cantDetalles] of Detalle;
    regDetalles = array[1..cantDetalles] of regDetalle;
////////////////////////////////////////////////////////////////
procedure CargarRegDetalle(var reg: regDetalle);
begin

    with reg do begin
    
        readln(codProvincia);
        
        if(codProvincia <> -1) then begin
    
            readln(codLocalidad);
            readln(conLuz);
            readln(conGas);
            readln(conSanitario);
            readln(conAgua);
            readln(conTecho);
        
        end;
    
    end;

end;
////////////////////////////////////////////////////////////////
procedure CargarRegMaestro(var reg: regMaestro);
begin

    with reg do begin
    
        readln(codProvincia);
        
        if(codProvincia <> -1) then begin
            
            readln(nombreProvincia);
            readln(codLocalidad);
            readln(nombreLocalidad);
            readln(sinLuz);
            readln(sinGas);
            readln(sinSanitario);
            readln(sinAgua);
            readln(sinTecho);
        
        end;
    
    end;

end;
////////////////////////////////////////////////////////////////
procedure CargarDetalle(var Archivo: Detalle);
var reg: regDetalle;
begin

    Rewrite(Archivo);
    
    CargarRegDetalle(reg);
    
    while (reg.codProvincia <> -1 ) do begin
    
        write(Archivo, reg);
        CargarRegDetalle(reg);
    
    end;
    
    Close(Archivo);

end;
////////////////////////////////////////////////////////////////
procedure CargarMaestro(var Archivo: Maestro);
var reg: regMaestro;
begin
    
    Assign(Archivo, 'Maestro.bi');
    Rewrite(Archivo);
    
    CargarRegMaestro(reg);
    
    while (reg.codProvincia <> -1 ) do begin
    
        write(Archivo, reg);
        CargarRegMaestro(reg);
    
    end;
    
    Close(Archivo);

end;
////////////////////////////////////////////////////////////////
procedure Leer(var Archivo: Detalle; var reg: regDetalle);
begin

    if(not eof(Archivo)) then read(Archivo, reg)
                         else reg.codProvincia := valorAlto;

end;
////////////////////////////////////////////////////////////////
procedure CargarDatos(var Maestro: Maestro; var Detalles: Detalles);
var i: integer; i_str: string;
begin

    CargarMaestro(Maestro);
    
    for i:=1 to cantDetalles do begin
    
        Str(i, i_str);
        Assign(Detalles[i], 'Detalle-'+ i_str);
        CargarDetalle(Detalles[i]);
    end;

end;
////////////////////////////////////////////////////////////////
procedure Minimo(var Detalles: Detalles; var Registros: regDetalles; var min: regDetalle);
begin

    if(Registros[1].codProvincia < Registros[2].codProvincia) then begin
        min := Registros[1];
        Leer(Detalles[1], Registros[1]);
    end else if(Registros[1].codProvincia > Registros[2].codProvincia) then begin
        min := Registros[2];
        Leer(Detalles[2], Registros[2]);
    end else begin
        if(Registros[1].codLocalidad <= Registros[2].codLocalidad) then begin
            min := Registros[1];
            Leer(Detalles[1], Registros[1]);
        end else begin
                min := Registros[2];
                Leer(Detalles[2], Registros[2]); 
        end;
    end;


end;
////////////////////////////////////////////////////////////////
procedure ActualizarMaestro(var Maestro: Maestro; var Detalles: Detalles);
var Registros: regDetalles; i: integer; regM: regMaestro; min: regDetalle;
begin

    Reset(Maestro);
    for i:=1 to cantDetalles do begin
    
        Reset(Detalles[i]);
        Leer(Detalles[i], Registros[i]);
        
    end;
    
    
    
    Minimo(Detalles, Registros, min);
    read(Maestro, regM);
    
    while (min.codProvincia <> valorAlto) do begin
    
        while((min.codProvincia <> regM.codProvincia) or (min.codLocalidad <> regM.codLocalidad)) do read(Maestro, regM);
        
        regM.sinTecho := regM.sinTecho - min.conTecho;
        regM.sinAgua:= regM.sinAgua - min.conAgua;
        regM.sinLuz := regM.sinLuz - min.conLuz;
        regM.sinSanitario := regM.sinSanitario - min.conSanitario;
        regM.sinGas := regM.sinGas - min.conGas;
        
        Seek(Maestro, filepos(Maestro) -1);
        write(Maestro, regM);
        
        Minimo(Detalles, Registros, min);
    end;
    
    
    
    for i:=1 to cantDetalles do begin
    
        Close(Detalles[i]);
        
    end;
    Close(Maestro);
end;
////////////////////////////////////////////////////////////////
var M: Maestro; Ds: Detalles; regM: regMaestro;
begin
  CargarDatos(M, Ds);  
  ActualizarMaestro(M, Ds);
  
  Reset(M);
  
  while(not eof(M)) do begin
  
    read(M, regM);
    writeln(regM.nombreLocalidad, ' ', regM.sinGas, ' ',regM.sinSanitario, ' ', regM.sinLuz, ' ', regM.sinAgua, ' ', regM.sinTecho );

  end;
  
  Close(M);
  
end.
