program Ej4P2;
const
    valorAlto = 9999;
    cantDetalles = 5;

type
    UsuarioMaestro = record
        cod: integer;
        fecha: integer;
        tiempoTotal: integer;
    end;
    
    UsuarioDetalle = record
        cod: integer;
        fecha: integer;
        tiempo: integer;
    end;
    
    ArchUsuarioMaestro = file of UsuarioMaestro;
    ArchUsuarioDetalle = file of UsuarioDetalle;
    
    DetallesReg = array[1..cantDetalles] of UsuarioDetalle;
    Detalles = array[1..cantDetalles] of ArchUsuarioDetalle;
    Dias = array[1..7] of integer;
///////////////////////////////////////////////////////////////
procedure CargarUsuarioDetalle(var User: UsuarioDetalle);
begin

    with User do begin
    
        readln(cod);
        
        if(cod <> -1) then begin
            readln(fecha);
            readln(tiempo);
        end;
    
    end;

end;
///////////////////////////////////////////////////////////////
procedure CargarDetalle(var Detalle: ArchUsuarioDetalle);
var User: UsuarioDetalle;
begin
    
    Rewrite(Detalle);
        
    CargarUsuarioDetalle(User);
    while (User.cod <> -1) do begin
    
        write(Detalle, User);
        CargarUsuarioDetalle(User);
    
    end;
        
    Close(Detalle);
    
end;
///////////////////////////////////////////////////////////////
procedure CargarDetalles(var Detalles: Detalles);
var i:integer; i_str: string;
begin
    
    for i:= 1 to cantDetalles do begin
        Str(i, i_str);
        Assign(Detalles[i], 'Detalle-' + i_str);
        CargarDetalle(Detalles[i]);
    end;
    
end;
///////////////////////////////////////////////////////////////
procedure Leer(var Detalle: ArchUsuarioDetalle; var User: UsuarioDetalle);
begin

    if(not eof(Detalle)) then read(Detalle, User)
                         else User.cod := valorAlto;
    
end;
///////////////////////////////////////////////////////////////
procedure Minimo(var Detalles: Detalles; var Registros: DetallesReg; var min: UsuarioDetalle);
begin
    if((Registros[1].cod <= Registros[2].cod) and (Registros[1].cod <= Registros[3].cod) and (Registros[1].cod <= Registros[4].cod) and (Registros[1].cod <= Registros[5].cod)) then begin
        min := Registros[1];
        Leer(Detalles[1], Registros[1]);
    end else
        if((Registros[2].cod <= Registros[3].cod) and (Registros[2].cod <= Registros[4].cod) and (Registros[2].cod <= Registros[5].cod)) then begin
            min := Registros[2];
            Leer(Detalles[2], Registros[2]);
        end else
            if((Registros[3].cod <= Registros[4].cod) and (Registros[3].cod <= Registros[5].cod)) then begin
                min := Registros[3];
                Leer(Detalles[3], Registros[3]);
            end else
                if((Registros[4].cod <= Registros[5].cod)) then begin
                    min := Registros[4];
                    Leer(Detalles[4], Registros[4]);
                end else begin
                        min := Registros[5];
                        Leer(Detalles[5], Registros[5]);
                    end;
end;
///////////////////////////////////////////////////////////////
procedure Merge(var Detalles: Detalles; var Maestro: ArchUsuarioMaestro);
var i: integer; Registros : DetallesReg; min, actual, actual2: UsuarioDetalle; aux: UsuarioMaestro; ArrDias: Dias; 
begin
    for i:= 1 to 7 do begin
        ArrDias[i] := 0;
    end;

    Assign(Maestro, 'Maestro.bi');
    Rewrite(Maestro);
    
    for i:= 1 to cantDetalles do begin
        Reset(Detalles[i]);
        Leer(Detalles[i], Registros[i]);
    end;
    
    Minimo(Detalles, Registros, min);
    
    while(min.cod <> valorAlto) do begin
    
        for i:= 1 to 7 do begin
            ArrDias[i] := 0;
        end;
        
        actual := min;
        while (actual.cod = min.cod) do begin
            ArrDias[min.fecha] := ArrDias[min.fecha] + min.tiempo; 
            Minimo(Detalles, Registros, min);
        end;
        aux.cod := actual.cod;
         
        for i:= 1 to 7 do begin
            if(ArrDias[i] <> 0) then begin
                aux.fecha := i;
                aux.tiempoTotal:= ArrDias[i];
                write(Maestro, aux);
            end;
        end;
    
    end;
    
    Close(Maestro);
    
end;
///////////////////////////////////////////////////////////////
var ArrDetalles: Detalles; Maestro: ArchUsuarioMaestro; User: UsuarioMaestro;
begin
  CargarDetalles(ArrDetalles);
  Merge(ArrDetalles, Maestro);
  
  Reset(Maestro);
  
  while(not eof(Maestro)) do begin
    read(Maestro, User);
    writeln(User.cod, ' ', User.fecha, ' ', User.tiempoTotal);
  end;
  
  Close(Maestro);
end.
