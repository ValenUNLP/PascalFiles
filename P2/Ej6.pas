program Ej6P2;

const
    valorAlto = 9999;
    cantDetalles = 3;

type
    palabra = string[20];
    
    regContador = record
        cantActivos: integer;
        cantNuevos: integer;
        cantRecuperados: integer;
        cantFallecidos: integer;
    end;
    
    
    Municipio = record
        cod: integer;
        codCepa: integer;
        cantActivos: integer;
        cantNuevos: integer;
        cantRecuperados: integer;
        cantFallecidos: integer;
    end;
    
    regMaestro = record
        cod: integer;
        nombreLocalidad: palabra;
        codCepa: integer;
        nombreCepa: palabra;
        cantActivos: integer;
        cantNuevos: integer;
        cantRecuperados: integer;
        cantFallecidos: integer;
    end;
    
    ArchDetalle = file of Municipio;
    ArrDetalles = array[1..cantDetalles] of ArchDetalle;
    regDetalles = array[1..cantDetalles] of Municipio;
    
    ArchMaestro = file of regMaestro;
    
    arrContador = array[1..2] of regContador;
    Ciudadesdb = array[1..3] of palabra;
    Cepasdb = array[1..2] of palabra;
///////////////////////////////////////////////////////////////////
procedure Inicializar(var arr: arrContador);
var i: integer;
begin

    for i:= 1 to 2 do begin
        
        arr[i].cantActivos := 0;
        arr[i].cantNuevos := 0;
        arr[i].cantRecuperados:= 0;
        arr[i].cantFallecidos := 0;
    
    end;

end;
///////////////////////////////////////////////////////////////////
procedure CargarMunicipio(var m: Municipio);
begin

    with m do begin
    
        readln(cod);
        
        if(cod <> -1) then begin
        
            readln(codCepa);
            readln(cantActivos);
            readln(cantNuevos);
            readln(cantRecuperados);
            readln(cantFallecidos);
        
        end;
    
    end;

end;
//////////////////////////////////////////////////////////////////
procedure CargarRegMaestro(var reg: regMaestro);
begin
    
    with reg do begin
    
        readln(cod);
        
        
        if(cod <> -1) then begin
        
            readln(nombreLocalidad);
            readln(codCepa);
            readln(nombreCepa);
            readln(cantActivos);
            readln(cantNuevos);
            readln(cantRecuperados);
            readln(cantFallecidos);
        
        end;
    end;
end;
//////////////////////////////////////////////////////////////////
procedure CargarDetalle(var D: ArchDetalle);
var m: Municipio;
begin

    Reset(D);
    
    CargarMunicipio(m);
    
    while (m.cod <> -1) do begin
    
        write(D, m);
        CargarMunicipio(m);
    
    end;
    
    Close(D);

end;
//////////////////////////////////////////////////////////////////
procedure CargarMaestro(var M: ArchMaestro);
var reg: regMaestro;
begin

    Reset(M);
    
    CargarRegMaestro(reg);
    
    while (reg.cod <> -1) do begin
    
        write(M, reg);
        CargarRegMaestro(reg);
    
    end;
    
    Close(M);

end;
//////////////////////////////////////////////////////////////////
procedure LeerDetalle(var D: ArchDetalle; var reg: Municipio);
begin

    if(not eof(D)) then read(D, reg)
                   else reg.cod := valorAlto;

end;
//////////////////////////////////////////////////////////////////
procedure LeerMaestro(var M: ArchMaestro; var reg: regMaestro);
begin

    if(not eof(M)) then read(M, reg)
                   else reg.cod := valorAlto;

end;
//////////////////////////////////////////////////////////////////
procedure Minimo(var Detalles: ArrDetalles; var Registros: regDetalles; var min: Municipio);
begin

    if((Registros[1].cod <= Registros[2].cod) and (Registros[1].cod <= Registros[3].cod)) then begin
        min := Registros[1];
        LeerDetalle(Detalles[1], Registros[1]);
    end else 
         if(Registros[2].cod <= Registros[3].cod) then begin
            min := Registros[2];
            LeerDetalle(Detalles[2], Registros[2]);
         end else begin
            min := Registros[3];
            LeerDetalle(Detalles[3], Registros[3]);
         end;

end;
//////////////////////////////////////////////////////////////////
procedure CargarInfo(var Detalles: ArrDetalles;var Maestro: ArchMaestro);
var i: integer;i_str: string;
begin
    
    for i:= 1 to cantDetalles do begin
        Str(i, i_str);
        Assign(Detalles[i], 'Detalle-'+i_str);
        Rewrite(Detalles[i]);
        
        CargarDetalle(Detalles[i]);
    end;
    Assign(Maestro, 'Maestro.bi');
    Rewrite(Maestro);
    CargarMaestro(Maestro);
    
end;
//////////////////////////////////////////////////////////////////
procedure ActualizarCasos(var Maestro: ArchMaestro; var Detalles: ArrDetalles;Ciudades: Ciudadesdb; Cepas: Cepasdb );
var Registros: regDetalles; i: integer;min: Municipio; Contador : arrContador; aux: regMaestro;regM: regMaestro;
begin
    Reset(Maestro);
    for i:= 1 to cantDetalles do begin
        Reset(Detalles[i]);
        LeerDetalle(Detalles[i], Registros[i]);
        //writeln(Registros[i].cod, ' ',Registros[i].codCepa, ' ', Registros[i].cantFallecidos);
    end;
    
    
    Minimo(Detalles, Registros, min);
    read(Maestro, aux);
    
    
    while (min.cod <> valorAlto) do begin
        Inicializar(Contador);
        while(min.cod <> aux.cod) do read(Maestro, aux);
        
        while(min.cod = aux.cod) do begin
            Contador[min.codCepa].cantNuevos := min.cantNuevos;
            Contador[min.codCepa].cantActivos := min.cantActivos;
            Contador[min.codCepa].cantFallecidos := min.cantFallecidos;
            Contador[min.codCepa].cantRecuperados := min.cantRecuperados;
            
            Minimo(Detalles, Registros, min);
            //writeln(min.cod, ' ', min.codCepa, ' ', min.cantFallecidos);
        end;
        
        Seek(Maestro, filepos(Maestro) - 1);
        for i:=1 to 2 do begin
           regM.cod := aux.cod;
           regM.nombreLocalidad := Ciudades[aux.cod];
           regM.codCepa := i;
           regM.nombreCepa := Cepas[i];
           regM.cantNuevos := Contador[i].cantNuevos;
           regM.cantActivos := Contador[i].cantActivos;
           regM.cantFallecidos := aux.cantFallecidos + Contador[i].cantFallecidos;
           regM.cantRecuperados := aux.cantRecuperados + Contador[i].cantRecuperados;
           write(Maestro, regM);
        end;
        
        
    end;
    
    
    for i:= 1 to cantDetalles do begin
        Close(Detalles[i]);
    end;
    Close(Maestro);
end;
//////////////////////////////////////////////////////////////////
procedure CargarDB(var Ciudades: Ciudadesdb; var Cepas: Cepasdb);
begin

    Ciudades[1] := 'Bragado';
    Ciudades[2] := 'Junin';
    Ciudades[3] := 'Mechita';
    
    Cepas[1] := 'Delta';
    Cepas[2] := 'Manaos';

end;
//////////////////////////////////////////////////////////////////
var Maestro: ArchMaestro; Detalles: ArrDetalles; Ciudades: Ciudadesdb; Cepas: Cepasdb; m: regMaestro;
begin
    CargarDB(Ciudades, Cepas);
    CargarInfo(Detalles, Maestro);
    ActualizarCasos(Maestro,Detalles, Ciudades,Cepas);
    
    Reset(Maestro);
    
    while(not eof(Maestro)) do begin
        read(Maestro, m);
        if(m.cantActivos > 50) then  writeln(m.nombreLocalidad, ' ', m.nombreCepa, ' ', m.cantActivos);
        
    
    end;
    
    
    Close(Maestro);
end.
