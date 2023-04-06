program Ej10P2;

const
    valorAlto = 'zzz';

type
    palabra = string[20];
    Empleado = record
        Departamento: palabra;
        Division: palabra;
        cod: integer;
        categoria: 1..10;
        cantHoras: integer;
    end;

    ArchMaestro = file of Empleado;
    ArrCategorias = array[1..10] of integer;
/////////////////////////////////////////    
procedure CargarTxT(var txt : text);
var i: integer;
begin
    Assign(txt, 'CategoriasPrecio.txt');
    Rewrite(txt);
    
    for i:= 1 to 10 do begin
        writeln(txt, i, ' ', i*10);
    end;
    
    Close(txt);
end;
/////////////////////////////////////////
procedure CargarCategorias(var txt: text;var Categorias: ArrCategorias);
var pos, valor: integer;
begin
    
    CargarTxT(txt);
    
    Reset(txt);
    
    while(not eof(txt)) do begin
    
        readln(txt, pos, valor);
        Categorias[pos] := valor;
    
    end;
    
    Close(txt);

end;
/////////////////////////////////////////
procedure CargarEmpleado(var e: Empleado);
begin

    with e do begin
    
        readln(Departamento);
        
        if(Departamento <> 'z') then begin
        
            readln(Division);
            readln(cod);
            readln(Categoria);
            readln(cantHoras);
        
        end;
    
    end;

end;
/////////////////////////////////////////
procedure CargarMaestro(var m: ArchMaestro);
var e: Empleado;
begin
    Assign(m, 'Maestro.bi');
    Rewrite(m);
    
    CargarEmpleado(e);
    
    while(e.Departamento <> 'z') do begin
        write(m, e);
        CargarEmpleado(e);
    end;
    
    Close(m);
end;
/////////////////////////////////////////
procedure Leer(var m: ArchMaestro;var  e: Empleado);
begin

    if(not eof(m)) then read(m, e) 
                   else e.Departamento := valorAlto;

end;
/////////////////////////////////////////
procedure ProcesarDatos(var m: ArchMaestro; Categorias: ArrCategorias);
var e: Empleado; Departamento, Division: palabra; cod, importeEmpleado, horasEmpleado, importeDivision, horasDivision, importeDepartamento, horasDepartamento: integer;
begin

    Reset(m);
    Leer(m, e);
    
    while (e.Departamento <> valorAlto) do begin
    
        Departamento := e.Departamento;
        writeln(Departamento);
        importeDepartamento := 0;
        horasDepartamento := 0;
        while ((e.Departamento <> valorAlto) and (Departamento = e.Departamento)) do begin
        
            Division := e.Division;
            writeln(Division);
            importeDivision := 0;
            horasDivision := 0;
            while (((e.Departamento <> valorAlto) and (Departamento = e.Departamento)) and (Division = e.Division)) do begin
            
                cod :=  e.cod;
                importeEmpleado := 0;
                horasEmpleado := 0;
                while(((e.Departamento <> valorAlto) and (Departamento = e.Departamento)) and (Division = e.Division) and (cod = e.cod)) do begin
                    horasEmpleado := horasEmpleado + e.cantHoras;
                    importeEmpleado := importeEmpleado + (Categorias[e.Categoria]*e.cantHoras);
                    Leer(m, e);
                end;
                    horasDivision := horasDivision + horasEmpleado;
                    importeDivision := importeDivision + importeEmpleado;
                    writeln('Empleado ', cod, ' - Total Hs:  ', horasEmpleado, ' - Importe: ', importeEmpleado);
                
            end;
                writeln('Horas Division: ', horasDivision, ' - Importe Division: ', importeDivision);
                writeln();
                horasDepartamento := horasDepartamento + horasDivision;
                importeDepartamento := importeDepartamento + importeDivision;
        end;
        writeln('Horas Departamento: ', horasDepartamento, ' - Importe Departamento: ', importeDepartamento);     
        writeln('-----------');
    end;
    
    
    Close(m);

end;
/////////////////////////////////////////
var txt: text; Categorias : ArrCategorias; m: ArchMaestro;
begin
    CargarCategorias(txt, Categorias);
    CargarMaestro(m);
    ProcesarDatos(m, Categorias);
end.
