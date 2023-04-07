program Ej16P2;

const 
    valorAlto = 9999;
    cantDetalles = 2;

type 
    palabra = string[20];
    regMaestro = record
        ano:integer;
        mes:integer;
        dia:integer;
        codLibro: integer;
        nombreLibro: palabra;
        desc: palabra;
        precio: integer;
        total: integer;
        vendidos: integer;
    end;
    
    regDetalle = record
        ano:integer;
        mes:integer;
        dia:integer;
        codLibro: integer;
        vendidos: integer;
    end;
    
    Maestro = file of regMaestro;
    Detalle = file of regDetalle;
    
    Detalles = array[1..cantDetalles] of Detalle;
    regDetalles = array[1..cantDetalles] of regDetalle;
////////////////////////////////////////////////////////////////
procedure CargarRegDetalle(var reg: regDetalle);
begin

    with reg do begin
    
        readln(ano);
        
        if(ano <> -1) then begin
    
            readln(mes);
            readln(dia);
            readln(codLibro);
            readln(vendidos)
        
        end;
    
    end;

end;
////////////////////////////////////////////////////////////////
procedure CargarRegMaestro(var reg: regMaestro);
begin
    with reg do begin
    
        readln(ano);
        
        if(ano <> -1) then begin
    
            readln(mes);
            readln(dia);
            readln(codLibro);
            readln(nombreLibro);
            readln(desc);
            readln(precio);
            readln(total);
            readln(vendidos);
        
        end;
    
    end;

end;
////////////////////////////////////////////////////////////////
procedure CargarDetalle(var Archivo: Detalle);
var reg: regDetalle;
begin

    Rewrite(Archivo);
    
    CargarRegDetalle(reg);
    
    while (reg.ano <> -1 ) do begin
    
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
    
    while (reg.ano<> -1 ) do begin
    
        write(Archivo, reg);
        CargarRegMaestro(reg);
    
    end;
    
    Close(Archivo);

end;
////////////////////////////////////////////////////////////////
procedure Leer(var Archivo: Detalle; var reg: regDetalle);
begin

    if(not eof(Archivo)) then read(Archivo, reg)
                         else reg.ano := valorAlto;

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

    if(Registros[1].ano < Registros[2].ano) then begin
        min := Registros[1];
        Leer(Detalles[1], Registros[1]);
    end else
        if(Registros[2].ano < Registros[1].ano) then begin
            min := Registros[2];
            Leer(Detalles[2], Registros[2]);
        end else 
            if((Registros[1].mes < Registros[2].mes)) then begin
                min := Registros[1];
                Leer(Detalles[1], Registros[1]);
            end else 
                if(Registros[2].mes < Registros[1].mes) then begin
                    min := Registros[2];
                    Leer(Detalles[2], Registros[2]);
                end else
                    if((Registros[1].dia < Registros[2].dia)) then begin
                        min := Registros[1];
                        Leer(Detalles[1], Registros[1]);
                    end else 
                        if(Registros[2].dia < Registros[1].dia) then begin
                            min := Registros[2];
                            Leer(Detalles[2], Registros[2]);
                        end else
                            if(Registros[1].codLibro <= Registros[2].codLibro) then begin
                                min := Registros[1];
                                Leer(Detalles[1], Registros[1]);
                            end else begin
                                    min := Registros[2];
                                    Leer(Detalles[2], Registros[2]);
                                end;
                    


end;
////////////////////////////////////////////////////////////////
procedure ActualizarMaestro(var Maestro: Maestro; var Detalles: Detalles);
var Registros: regDetalles; i: integer; regM: regMaestro; min, aux: regDetalle;
begin
    Reset(Maestro);
    for i:=1 to cantDetalles do begin
    
        Reset(Detalles[i]);
        Leer(Detalles[i], Registros[i]);
        
    end;
    
    
    
    Minimo(Detalles, Registros, min);
    read(Maestro, regM);
    
    while (min.ano <> valorAlto) do begin
        
        while((min.ano <> regM.ano) or (min.mes <> regM.mes) or (min.dia <> regM.dia) or (min.codLibro <> regM.codLibro)) do read(Maestro, regM);
        
        aux := min;
        aux.vendidos := 0;
        while((min.ano <> valorAlto) and (min.ano = aux.ano) and (min.mes = aux.mes) and (min.dia = aux.dia) and (min.codLibro = aux.codLibro)) do begin
            aux.vendidos := aux.vendidos + min.vendidos;
            Minimo(Detalles, Registros, min);
        end;
        if(regM.total > regM.vendidos+aux.vendidos) then regM.vendidos := regM.vendidos + aux.vendidos
                                                    else regM.vendidos := regM.total;
        
        Seek(Maestro, filepos(Maestro)-1);
        write(Maestro, regM);
        
    end;
    
    
    
    for i:=1 to cantDetalles do begin
    
        Close(Detalles[i]);
        
    end;
    Close(Maestro);
end;
////////////////////////////////////////////////////////////////
var M: Maestro; Ds: Detalles; regM,max, min: regMaestro;
begin
    max.vendidos := -9999;
    min.vendidos := 999;
  CargarDatos(M, Ds);  
  ActualizarMaestro(M, Ds);
  
  Reset(M);
  
  while(not eof(M)) do begin
  
    read(M, regM);
    if(regM.vendidos > max.vendidos) then max := regM;
    if(regM.vendidos < min.vendidos) then min := regM;
    //writeln(regM.nombreLibro, ' ', regM.ano, ' ',regM.mes, ' ', regM.dia, ' ', regM.total, ' ', regM.vendidos);

  end;
    writeln('Max: ', max.nombreLibro, ' ', max.ano, ' ',max.mes, ' ', max.dia, ' ', max.total, ' ', max.vendidos);
    writeln('Min: ', min.nombreLibro, ' ', min.ano, ' ',min.mes, ' ', min.dia, ' ', min.total, ' ', min.vendidos);
  Close(M);
  
end.
