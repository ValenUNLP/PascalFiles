program Ej5;
type
    Celular = record
    cod: integer;
    nombre: string[10];
    descripcion: string;
    marca: string;
    precio: real;
    stockMin: integer;
    stock:integer;
    end;

    ArchCelulares = file of Celular;
procedure CargarCelular(var c: Celular);
begin
    readln(c.cod);
    if(c.cod <> -1) then begin
        readln(c.nombre);
        readln(c.descripcion);
        readln(c.marca);
        readln(c.precio);
        readln(c.stockMin);
        readln(c.stock);
    end;
end;
    
procedure CargarCelularesTxT(var Cels: text);
var
c: Celular;
begin
    Assign(Cels, 'Celulares.txt');
    Rewrite(Cels);
    
    CargarCelular(c);
    while(c.cod <> -1) do begin
        Writeln(Cels,c.cod,' ',c.precio,' ',c.marca);
        Writeln(Cels,c.stock,' ',c.stockMin,' ',c.descripcion);
        Writeln(Cels,c.nombre);
        CargarCelular(c);
    end;
    Close(Cels);
end;

procedure CargarCelularesBi(var Celstxt: text; var CelsBi: ArchCelulares);
var
c: Celular;
begin
    Reset(Celstxt);
    Rewrite(CelsBi);
    while not eof(Celstxt) do begin
        with c do begin
            Readln(Celstxt, cod,precio,marca);
            Readln(Celstxt, stock,stockMin,descripcion);
            Readln(Celstxt, nombre);
        end;
            Write(CelsBi, c);
    end;
            Close(CelsBi);
            Close(Celstxt);
end;
///////////////////////////////////
procedure StockMenor(var Cels: ArchCelulares);
var
c: Celular;
begin
    Reset(Cels);
    while not eof(Cels) do begin
        read(Cels, c);
        if(c.stock < c.stockMin) then writeln(c.cod, ' ', c.nombre, ' ', c.descripcion, ' ', c.marca, ' ', c.precio, ' ', c.stock, ' ', c.stockMin );
    end;
    Close(Cels);
end;
///////////////////////////////////
procedure BuscarDescripcion(var Cels: ArchCelulares; cadena: string);
var
c: Celular;
begin
    Reset(Cels);
    while not eof(Cels) do begin
        read(Cels, c);
        if(c.descripcion = ' '+ cadena) then writeln(c.cod, ' ', c.nombre, ' ', c.descripcion, ' ', c.marca, ' ', c.precio, ' ', c.stock, ' ', c.stockMin );
    end;
    Close(Cels);
end;
///////////////////////////////////
procedure ExportarArchivo(var txt: text; var Cels: ArchCelulares);
var c: Celular;
begin
    Rewrite(txt);
    Reset(Cels);
    
    while not eof(Cels) do begin
        
        Read(Cels, c);
        with c do begin
            Writeln(txt,cod,' ',precio,' ',marca);
            Writeln(txt,stock,' ',stockMin,' ',descripcion);
            Writeln(txt,nombre);
        end;
        
    end;
    
    Close(txt);
    Close(Cels);
end;
///////////////////////////////////
var
    Celularestxt: text; CelularesBi: ArchCelulares; aux: Celular;
begin
    //CargarCelularesTxT(Celularestxt);
    //Assign(CelularesBi, 'Celulares.bi');
    //CargarCelularesBi(Celularestxt, CelularesBi);
    //StockMenor(CelularesBi);
    //BuscarDescripcion(CelularesBi,'CELULARRR');
    //ExportarArchivo(Celularestxt, CelularesBi);
end.
