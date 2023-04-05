program Ej7P2;

const 
    valorAlto = 9999;

type
    palabra = string[20];

    Producto = record
        cod: integer;
        nombre: palabra;
        precio: integer;
        stock: integer;
        stockMin: integer;
    
    end;
    
    Venta = record
        cod: integer;
        cant: integer;
    end;
    
    ArchDetalle = file of Venta;
    ArchMaestro = file of Producto;
    
///////////////////////////////////////////////////
procedure CargarVenta(var v: Venta);
begin
    with v do begin
    
        readln(cod);
        
        if(cod <> -1) then readln(cant);
        
    end;
end;
///////////////////////////////////////////////////
procedure CargarProducto(var p: Producto);
begin
    with p do begin
    
        readln(cod);
        
        if(cod <> -1) then begin
        
            readln(nombre);
            readln(precio);
            readln(stock);
            readln(stockMin);
        
        end;
    
    end;

end;
///////////////////////////////////////////////////
procedure CargarDetalle(var Detalle: ArchDetalle);
var  v: Venta;
begin

    Assign(Detalle, 'Detalle.bi');
    
    Rewrite(Detalle);
    
    CargarVenta(v);
    
    while (v.cod <> -1) do begin
        write(Detalle, v);
        CargarVenta(v);
    end;
    

end;
///////////////////////////////////////////////////
procedure CargarMaestro(var Maestro: ArchMaestro);
var  p: Producto;
begin

    Assign(Maestro, 'Maestro.bi');
    
    Rewrite(Maestro);
    
    CargarProducto(p);
    
    while (p.cod <> -1) do begin
        write(Maestro, p);
        CargarProducto(p);
    end;
    

end;
//////////////////////////////////////////////////
procedure Leer(var Detalle: ArchDetalle; var v: Venta);
begin

    if(not eof(Detalle)) then read(Detalle, v)
                         else v.cod := valorAlto;
    
end;
//////////////////////////////////////////////////
procedure ActualizarMaestro(var Maestro: ArchMaestro; var Detalle: ArchDetalle);
var v: Venta; total, cod: integer; p, aux: Producto;
begin
    Reset(Maestro);
    Reset(Detalle);
    
    Leer(Detalle,v);
    read(Maestro, p);
    
    while (v.cod <> valorAlto) do begin
        cod := v.cod;
        total := 0;
        
        while (cod <> p.cod) do read(Maestro, p);
        
        while (v.cod = cod) do begin
        
            total := total + v.cant;
            Leer(Detalle, v);
        end;
        
        aux.cod := cod;
        aux.nombre := p.nombre;
        aux.precio := p.precio;
        aux.stock := p.stock - total;
        aux.stockMin := p.stockMin;
        
        Seek(Maestro, filepos(Maestro) - 1);
        
        write(Maestro, aux);
    end;
    
    Close(Maestro);
    Close(Detalle);
end;
//////////////////////////////////////////////////
procedure ProblemasStock(var Maestro: ArchMaestro; var txt: text);
var p: Producto;
begin
    Assign(txt, 'stock_minimo.tx');
    Rewrite(txt);
    Reset(Maestro);
    
    while(not eof(Maestro)) do begin
    
        read(Maestro, p);
        if(p.stock < p.stockMin) then begin
            writeln(txt, p.cod, ' ', p.nombre, ' ', p.precio, ' ', p.stock, ' ', p.stockMin);
        end;
    
    end;
    
    
    Close(Maestro);
    Close(txt);
end;
//////////////////////////////////////////////////
var Maestro: ArchMaestro; Detalle: ArchDetalle; txt: text;
begin
    CargarMaestro(Maestro);
    CargarDetalle(Detalle);
    ActualizarMaestro(Maestro, Detalle);
    ProblemasStock(Maestro, txt);
    
end.
