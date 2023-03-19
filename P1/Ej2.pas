//Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
//creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
//promedio de los números ingresados. El nombre del archivo a procesar debe ser
//proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
//contenido del archivo en pantalla.



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
    procedure CargarArchivo(var archivo: numbersFile; var DimF: integer);
        var aux: integer;
        begin
            Rewrite(archivo);
            DimF := 0;
            IngresarNumero(aux);
            while(aux <> 30000) do begin
                Write(archivo, aux);
                DimF := DimF + 1;
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
    procedure ProcesarDatos(var archivo: numbersFile; var promedio: real; var DimF, cont: integer);
    var aux, total: integer;
    begin
        total := 0;
        Reset(archivo);
        
        writeln('Elementos:');
        while not eof(archivo) do begin
            Read(archivo, aux);
            writeln(aux);
            writeln('----------');
            total := total + aux;
            if(aux < 1500) then cont := cont + 1
        end;
        promedio := total / DimF;
        Close(archivo)
    end;
    ///////////////////////////////////////////////////////////
    var
        total, DimF, cont: integer;
        numbers: numbersFile;
        fileName: string;
        promedio: real;
    begin
        promedio := 0;
        cont := 0;
        writeln('Ingrese nombre del archivo a crear');
        readln(fileName);
        Assign(numbers, fileName);
        CargarArchivo(numbers, DimF);
        ProcesarDatos(numbers, promedio, DimF, cont);
        writeln('Promedio: ', promedio);
        writeln('Cantidad de elementos menores a 1500: ' ,cont);
        
end.