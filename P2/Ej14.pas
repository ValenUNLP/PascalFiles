program Ej14P2;
const 
    valorAlto = 'zzz';
    cantDetalles = 2;    

type
    palabra = string[20];
    regMaestro = record
        destino: palabra;
        ano: integer;
        mes: integer;
        dia: integer;
        hora: integer;
        cantAsientosDisponibles: integer;
    end;

    regDetalle = record
        destino: palabra;
        ano: integer;
        mes: integer;
        dia: integer;
        hora: integer;
        cantAsientosComprados: integer;
    end;
    
    Maestro = file of regMaestro;
    Detalle = file of regDetalle;
    
    Detalles = array[1..cantDetalles] of Detalle;
    regDetalles = array[1..cantDetalles] of regDetalle;
//////////////////////////////////////////////////////////////////////
procedure CargarRegDetalle(var reg: regDetalle);
begin

    with reg do begin
    
        readln(destino);
        
        if(destino <> 'z') then begin
        
            readln(ano);
            readln(mes);
            readln(dia);
            readln(hora);
            readln(cantAsientosComprados);
        
        end;
    
    end;

end;
//////////////////////////////////////////////////////////////////////
procedure CargarRegMaestro(var reg: regMaestro);
begin

    with reg do begin
    
        readln(destino);
        
        if(destino <> 'z') then begin
        
            readln(ano);
            readln(mes);
            readln(dia);
            readln(hora);
            readln(cantAsientosDisponibles);
        
        end;
    
    end;

end;
//////////////////////////////////////////////////////////////////////
procedure CargarMaestro(var Archivo: Maestro);
var reg: regMaestro;
begin

    Assign(Archivo, 'Maestro.bi');
    Rewrite(Archivo);
    
    CargarRegMaestro(reg);
    
    while(reg.destino <> 'z') do begin
    
        write(Archivo, reg);
        CargarRegMaestro(reg);
    
    end;
    
    Close(Archivo);

end;
//////////////////////////////////////////////////////////////////////
procedure CargarDetalle(var Archivo: Detalle);
var reg: regDetalle;
begin

    Rewrite(Archivo);
    
    CargarRegDetalle(reg);
    
    while(reg.destino <> 'z') do begin
    
        write(Archivo, reg);
        CargarRegDetalle(reg);
    
    end;
    
    Close(Archivo);

end;
//////////////////////////////////////////////////////////////////////
procedure Leer(var Archivo: Detalle; var reg: regDetalle);
begin

    if(not eof(Archivo)) then read(Archivo, reg)
                         else reg.destino := valorAlto;

end;
//////////////////////////////////////////////////////////////////////
procedure CargarDatos(var Maestro: Maestro; var Detalles: Detalles);
var i:integer; i_str: string;
begin

    CargarMaestro(Maestro);
    
    for i:=1 to cantDetalles do begin
    
        Str(i, i_str);
        Assign(Detalles[i], 'Detalle-' + i_str);
        CargarDetalle(Detalles[i]);
        
    end;
    
end;
//////////////////////////////////////////////////////////////////////
procedure Minimo(var Detalles: Detalles; var Registros: regDetalles; var min: regDetalle);
begin
    if(min.destino = 'Niguno') then begin
        if(Registros[1].destino[1] <= Registros[2].destino[1]) then begin
            min := Registros[1];
            Leer(Detalles[1], Registros[1])
        end else begin
            min := Registros[2];
            Leer(Detalles[2], Registros[2])
        end;
    end else 
        if(min.destino = Registros[1].destino) then begin
            min := Registros[1];
            Leer(Detalles[1], Registros[1])
        end else
            if(min.destino = Registros[2].destino) then begin
                min := Registros[2];
                Leer(Detalles[2], Registros[2])
            end else begin
            
                if(Registros[1].destino[1] <= Registros[2].destino[1]) then begin
                    min := Registros[1];
                    Leer(Detalles[1], Registros[1])
                end else begin
                    min := Registros[2];
                    Leer(Detalles[2], Registros[2])
                end;
            
            end;

end;
//////////////////////////////////////////////////////////////////////
procedure ActualizarMaestro(var Maestro: Maestro; var Detalles: Detalles);
var i: integer; Registros: regDetalles; min, aux: regDetalle; regM: regMaestro;
begin
    Reset(Maestro);
    for i:=1 to cantDetalles do begin
    
        Reset(Detalles[i]);
        Leer(Detalles[i], Registros[i]);
    end;
    min.destino := 'Niguno';
    Minimo(Detalles, Registros, min);
    read(Maestro, regM);
    
    while min.destino <> valorAlto do begin
        
        //writeln(min.destino);
        //writeln(regM.destino);
        while((min.destino <> regM.destino) or (min.ano <> regM.ano) or (min.mes <> regM.mes) or (min.dia <> regM.dia) or (min.hora<> regM.hora)) do read(Maestro, regM);
        
        aux := min;
        aux.cantAsientosComprados := 0;
        while((min.destino <> valorAlto) and (min.destino = aux.destino) and (min.ano =  aux.ano) and (min.mes = aux.mes) and (min.dia = aux.dia) and (min.hora = aux.hora)) do begin
        
            aux.cantAsientosComprados := aux.cantAsientosComprados + min.cantAsientosComprados;
            Minimo(Detalles, Registros, min);
        end;
        
       regM.cantAsientosDisponibles := regM.cantAsientosDisponibles - aux.cantAsientosComprados;
       Seek(Maestro, filepos(Maestro)- 1);
       write(Maestro, regM);

    end;
    
    for i:=1 to cantDetalles do begin
        close(Detalles[i]);
    end;
end;
//////////////////////////////////////////////////////////////////////
var M: Maestro; arrDetalles: Detalles; regM: regMaestro;
begin
    CargarDatos(M, arrDetalles);
    ActualizarMaestro(M, arrDetalles);
    
    Reset(M);
    
    while not eof(M) do begin
        read(M, regM);
        if(regM.cantAsientosDisponibles = 150) then writeln(regM.destino, ' ', regM.ano, ' ', regM.mes, ' ', regM.dia, ' ', regM.hora, ' ', regM.cantAsientosDisponibles);
    
    end;
    
    Close(M);
end.
