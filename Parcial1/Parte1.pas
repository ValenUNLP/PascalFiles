program Parcial1;
const
    valorAlto = 9999;
    cantDetalles = 3;
type


venta = record
    cod_farmaco: integer;
    nombre: string;
    fecha: 1..31; //1-31
    cantVendido: integer;
    pago: string; //Contado o Tarjeta
end;

Detalle = file of venta;
Detalles = array[1..cantDetalles] of Detalle;
RegDetalles = array[1..cantDetalles] of venta;
Dias = array[1..31] of integer;
/////////////////////////////////////////////////
procedure CargarVenta(var v: venta); 
begin
    
    readln(v.cod_farmaco);
    
    if(v.cod_farmaco <> -1) then begin
        readln(v.nombre);
        readln(v.fecha);
        readln(v.cantVendido);
        readln(v.pago);
    end;

end;

/////////////////////////////////////////////////
procedure cargarDetalle(var Detalle: Detalle);
var v: venta;
begin
    Rewrite(Detalle);
    CargarVenta(v);
    while(v.cod_farmaco <> -1) do begin
        write(Detalle, v);
        CargarVenta(v);
    end;
    Close(Detalle);
end;
/////////////////////////////////////////////////
procedure inicializarDetalles(var Detalles: Detalles);
var i: integer;i_str: string;
begin
    
    for i:=1 to cantDetalles do begin
        Str(i, i_str);
        Assign(Detalles[i], 'Detalle-'+i_str);
        cargarDetalle(Detalles[i]);
    end;
end;
////////////////////////////////////////////////
procedure Leer(var Detalle: Detalle; var v: venta);
begin

if(not eof(Detalle)) then read(Detalle, v)
            else v.cod_farmaco := valorAlto;

end;

////////////////////////////////////////////////
procedure Minimo(var RegDetalles: RegDetalles; var Detalles: Detalles; var min: venta);
var i, pos: integer;
begin
    
    min.cod_farmaco := valorAlto;
    
    for i:=1 to cantDetalles do begin
        if((RegDetalles[i].cod_farmaco < min.cod_farmaco) or ((RegDetalles[i].cod_farmaco = min.cod_farmaco) and (RegDetalles[i].fecha < min.fecha))) then begin
            min := RegDetalles[i];
            pos := i;
        end;
    end;
    if(min.cod_farmaco <> valorAlto) then begin
        Leer(Detalles[pos], RegDetalles[pos]);
    end;
end;

////////////////////////////////////////////////
procedure farmacoMasComprado(var Detalles: Detalles);
var i, max, total: integer; RegDet: RegDetalles; maxFarmaco, act: string; min: venta;
begin
    max := -1;
    
    for i:= 1 to cantDetalles do begin
        Reset(Detalles[i]);
        Leer(Detalles[i], RegDet[i]);
    end;
    Minimo(RegDet, Detalles, min);

    while(min.cod_farmaco <> valorAlto) do begin
        total := 0;
        act := min.nombre;
        
        while((valorAlto <> min.cod_farmaco) and (act = min.nombre)) do begin
        
            total := total + min.cantVendido;
            Minimo(RegDet, Detalles, min);
            
        end;
        if(total > max) then begin
            max := total;
            maxFarmaco := act;
        end;
        
    end;
    writeln('El farmaco mas vendido es: ', maxFarmaco, ' con una cantidad de ', max,' unidades');
end;

////////////////////////////////////////////////
procedure inicializarDias(var arr: Dias);
var i: integer;
begin

for i:=1 to 31 do begin
    arr[i] := 0;
end;

end;
///////////////////////////////////////////////
procedure fechaMasCompras(var Dets: Detalles);
var arrDias: Dias; i, max, maxDia: integer; v:venta;
begin
    max := -1;
    
    inicializarDias(arrDias);
    
    for i:= 1 to cantDetalles do begin
        Reset(Dets[i]);
    end;
    
    for i:=1 to cantDetalles do begin  //En este caso, no necesito utilizar minimo, debido a que no me importa el orden con el que los elementos vienen, ya que voy a acceder de manera directa al arreglo, no necesito perder tiempo validando el orden.
    
        Leer(Dets[i], v);
        while(v.cod_farmaco <> valorAlto) do begin
            if(v.pago = 'Contado') then arrDias[v.fecha] := arrDias[v.fecha] + v.cantVendido;
            Leer(Dets[i], v);
        end;
    
    end;
    for i:=1 to 31 do begin
        if(arrDias[i] > max) then begin
            max := arrDias[i];
            maxDia := i;
        end;
    end;
    writeln('El dia con mas ventas al contado fue: ', maxDia, ' con una cantidad de ', max, ' unidades');
end;
///////////////////////////////////////////////
procedure crearTxT(var Dets: Detalles);
var RegDet: RegDetalles; i: integer;min, act: venta; txt: text;
begin
    Assign(txt, 'txt');
    Rewrite(txt);
    for i:= 1 to cantDetalles do begin
        Reset(Dets[i]);
        Leer(Dets[i], RegDet[i]);
    end;
    
    Minimo(RegDet, Dets, min);
    while(min.cod_farmaco <> valorAlto) do begin
        act:= min;
        act.cantVendido := 0;
        while((min.fecha = act.fecha) and (min.cod_farmaco = act.cod_farmaco)) do begin
            act.cantVendido := act.cantVendido + min.cantVendido;
            Minimo(RegDet, Dets, min);
        end;
        writeln(txt, act.cod_farmaco, ' ', act.nombre, ' ', act.fecha, ' ', act.cantVendido);
    end;
    
    Close(txt);
    for i:= 1 to cantDetalles do begin
        Close(Dets[i]);
    end;
end;
///////////////////////////////////////////////
var
    Dets: Detalles;
begin
  inicializarDetalles(Dets);
  ////////// PROCEDIMIENTOS DEL PARCIAL:
  farmacoMasComprado(Dets);
  fechaMasCompras(Dets);
  crearTxT(Dets);
end.
