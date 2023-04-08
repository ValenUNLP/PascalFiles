program Ej17P2;
const
    valorAlto = 9999;
    cantDetalles = 2;

type
    palabra = string[20];
    
    Moto = record
        cod: integer;
        nombre: palabra; 
        descripcion: palabra;
        modelo: integer;
        marca:palabra;
        stock:integer;
    end;
    
    Venta = record
        cod: integer;
        precio: integer;
    end;

    Maestro = file of Moto;
    Detalle = file of Venta;
    
    Detalles = array[1..cantDetalles] of Detalle;
    regDetalles = array[1..cantDetalles] of Venta;
/////////////////////////////////////////////////
procedure CargarMoto(var m: Moto);
begin

    with m do begin
    
        readln(cod);
        
        if(cod <> -1 ) then begin
        
            readln(nombre);
            readln(descripcion);
            readln(modelo);
            readln(marca);
            readln(stock);
        
        end;
    
    end;


end;
////////////////////////////////////////////
procedure CargarVenta(var v: Venta);
begin

    with v do begin
    
        readln(cod);
        
        if(cod <> -1 ) then begin
        
            readln(precio);
        
        end;
    
    end;


end;
////////////////////////////////////////////
procedure CargarDetalle(var Archivo: Detalle);
var v: Venta;
begin
    
    Rewrite(Archivo);
    
    CargarVenta(v);
    
    while(v.cod <> -1) do begin
        write(Archivo, v);
        CargarVenta(v);
    end;
    
    Close(Archivo);
    

end;
////////////////////////////////////////////
procedure CargarMaestro(var Archivo: Maestro);
var v: Moto;
begin
    Assign(Archivo, 'Maestro.bi');
    Rewrite(Archivo);
    
    CargarMoto(v);
    
    while(v.cod <> -1) do begin
        write(Archivo, v);
        CargarMoto(v);
    end;
    
    Close(Archivo);
    

end;
////////////////////////////////////////////
procedure CargarDatos(var m: Maestro;var  d: Detalles);
var i: integer; i_str: string;
begin

    CargarMaestro(m);
    
    for i:=1 to cantDetalles do begin
        Str(i, i_str);
        Assign(d[i], 'Detalle-' + i_str);
        CargarDetalle(d[i]);
    
    end;

end;
////////////////////////////////////////////
procedure Leer(var d: Detalle; var reg: Venta);
begin

    if(not eof(d)) then read(d, reg)
                   else reg.cod := valorAlto;

end;
////////////////////////////////////////////
procedure Minimo(var Detalles: Detalles; var Registros:regDetalles; var min: Venta);
begin

    if(Registros[1].cod <= Registros[2].cod) then begin
        min :=  Registros[1];
        Leer(Detalles[1], Registros[1]);
    end else begin
        min := Registros[2];
        Leer(Detalles[2], Registros[2]);
    end;

end;
////////////////////////////////////////////
procedure ActualizarMaestro(var m: Maestro; Detalles:Detalles);
var i: integer; Registros: regDetalles; min: Venta; regM: Moto; cod, cant, ganancia, max, motoMax: integer;
begin
    max := 0;
    Reset(m);
    
    for i:=1 to cantDetalles do begin
        Reset(Detalles[i]);
        Leer(Detalles[i], Registros[i]);
    end;
    
    Minimo(Detalles, Registros, min);
    read(m, regM);
    
    while(min.cod <> valorAlto) do begin
    
        while(min.cod <> regM.cod) do read(m, regM);
        
        cod := min.cod;
        cant := 0;
        ganancia := 0;
        while(min.cod = cod) do begin
            cant := cant + 1;
            Minimo(Detalles, Registros, min);
        end;
        
        if(cant >= max) then begin
            max :=cant;
            motoMax := cod;
        end;
        
        regM.stock := regM.stock - cant;
        
        Seek(m, filepos(m) - 1);
        write(m, regM);
        
    end;
     for i:=1 to cantDetalles do begin
        Close(Detalles[i]);
    end;
    Close(m);
    writeln('Codigo de moto mas comprada: ', motoMax, ' - Fue comprada: ', max, ' veces');
end;
////////////////////////////////////////////
var m: Maestro; d: Detalles; regM :Moto;
begin
    CargarDatos(m, d);
    ActualizarMaestro(m, d);
end.
