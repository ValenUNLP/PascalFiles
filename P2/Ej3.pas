program Ej3P2;
const 
    valorAlto = 9999;
    cantDetalles = 3;
type
    palabra = string[20];
    Producto = record
        cod: integer;
        nombre: palabra;
        descripcion: palabra;
        stock: integer;
        stockMin: integer;
        precio: integer;
    end;
    
    Venta = record
        cod: integer;
        cant: integer;
    end;
    
    ArchProducto = file of Producto;
    ArchVenta = file of Venta;
    
    Ventas = array[1..3] of ArchVenta;
    RegVentas = array[1..3] of Venta; 
/////////////////////////////////////////////////////
procedure CargarVenta(var v: venta);
begin
    readln(v.cod);
    if(v.cod <> -1) then begin
        readln(v.cant);
    end;
end;
/////////////////////////////////////////////////////
procedure CargarProducto(var p: Producto);
begin

    with p do begin 
        readln(cod);
        if(cod <> -1)then begin
            readln(nombre);
            readln(descripcion);
            readln(stock);
            readln(stockMin);
            readln(precio);
        end;
    end;

end;
/////////////////////////////////////////////////////
procedure CrearArchivo(var Archivo: ArchProducto);
var p: producto;
begin

    Assign(Archivo, 'Productos.bi');
    Rewrite(Archivo);
    
    CargarProducto(p);
    
    while(p.cod <> -1) do begin
        
        write(Archivo, p);
        CargarProducto(p);
        
    end;
    
    Close(Archivo);

end;
/////////////////////////////////////////////////////
procedure CargarDetalle(var Detalle:ArchVenta);
var v: venta;
begin
    Reset(Detalle);
    CargarVenta(v);
    
    while (v.cod <> -1) do begin
        write(Detalle, v);
        CargarVenta(v);
    end;
    Close(Detalle);
end;
/////////////////////////////////////////////////////
procedure CargarDetalles(var Detalles: Ventas);
var i:integer; i_str: string;
begin
    for i:=1 to cantDetalles do begin
        Str(i, i_str);
        Assign(Detalles[i], 'Detalle n' + i_str);
        Rewrite(Detalles[i]);
        CargarDetalle(Detalles[i]);
    end;
    
end;
/////////////////////////////////////////////////////
procedure Leer(var Detalle: ArchVenta; var v: Venta);
begin
    if(not eof(Detalle)) then read(Detalle, v)
                         else v.cod := valorAlto;
end;
/////////////////////////////////////////////////////
procedure Minimo(var r1, r2, r3: Venta; var min: Venta; Detalles: Ventas);
begin
    if((r1.cod <= r2.cod) and (r1.cod <= r3.cod)) then begin
        min := r1;
        Leer(Detalles[1], r1);
    end
    else if(r2.cod <= r3.cod) then begin
        min := r2;
        Leer(Detalles[2], r2);
    end else begin
        min := r3;
        Leer(Detalles[3], r3);
    end;

end;
/////////////////////////////////////////////////////
procedure ActualizarMaestro(var Productos: ArchProducto; var Detalles: Ventas; var Registros: RegVentas);
var min: Venta; i: integer; p: Producto;
begin
    Reset(Productos);
    
    for i:= 1 to cantDetalles do begin
        Reset(Detalles[i]);
        Leer(Detalles[i], Registros[i]);
    end;
    Minimo(Registros[1], Registros[2], Registros[3], min, Detalles);
    
    while (min.cod <> valorAlto) do begin
        
        read(Productos, p);
        while(p.cod <> min.cod) do read(Productos, p);
        
        while (p.cod = min.cod) do begin
            p.stock := p.stock - min.cant;
            Minimo(Registros[1], Registros[2], Registros[3], min, Detalles);
        
        end;
        Seek(Productos, filepos(Productos)- 1);
        write(Productos, p);
    end;
    for i:= 1 to cantDetalles do begin
        Close(Detalles[i]);
    end;
    Close(Productos);
end;
/////////////////////////////////////////////////////
procedure InformarStock(var Ps: ArchProducto);
var p: Producto; txt: text;
begin
    Assign(txt, 'stock.txt');
    Rewrite(txt);
    Reset(Ps);
    
    while(not eof(Ps)) do begin
        read(Ps, p);
        if(p.stock < p.stockMin) then write(txt, p.nombre, ' ', p.descripcion, ' ', p.stock, ' ', p.precio);
    end;
    
    Close(txt);
    Close(Ps);
end;
/////////////////////////////////////////////////////
var Productos: ArchProducto; Detalles: Ventas; VentasReg: RegVentas; p: Producto;
begin
  CrearArchivo(Productos);
  CargarDetalles(Detalles);
  ActualizarMaestro(Productos, Detalles, VentasReg);
  InformarStock(Productos);
end.
