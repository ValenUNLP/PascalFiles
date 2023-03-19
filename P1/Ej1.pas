//1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
//incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
//archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
//se ingrese el número 30000, que no debe incorporarse al archivo.


Program P1EJ1(output);
    type
        numbersFile = file of integer;
    ///////////////////////////////////////////////////////////
    procedure IngresarNumero(var n: integer);
        begin
            writeln('Ingrese un digito al archivo');
            readln(n); 
        end;
    ///////////////////////////////////////////////////////////
    procedure CargarArchivo(var archivo: numbersFile);
        var aux: integer;
        begin
            Rewrite(archivo);
            IngresarNumero(aux);
            while(aux <> 30000) do begin
                Write(archivo, aux);
                IngresarNumero(aux);
            end;
            Close(archivo);
        end;
    ///////////////////////////////////////////////////////////
    procedure LeerArchivo(var archivo: numbersFile);
    var aux: integer;
    begin
        Reset(archivo);
        
        while not eof(archivo) do begin
            Read(archivo, aux);
            writeln(aux);
        end;
        Close(archivo);
    end;
    ///////////////////////////////////////////////////////////
    var
        aux: integer;
        numbers: numbersFile;
        fileName: string;
    begin
        writeln('Ingrese nombre del archivo a crear');
        readln(fileName);
        Assign(numbers, fileName);
        CargarArchivo(numbers);
        LeerArchivo(numbers);
        
end.