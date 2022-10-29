PROGRAM EJER39;  
        USES CRT; 
        VAR importe_bruto:REAL; 
        VAR descuento, total:REAL; 
BEGIN 
        ClrScr; 
        WRITE ('Indique el importe de su factura pa
ra ver '); 
        WRITELN ('si le "descontamos" algo'); 
        WRITELN (''); 
        READLN (importe_bruto); 
        WRITELN (''); 
        {calcula el importe bruto con descuento del
 15%} 
        descuento:=importe_bruto * 0.15; 
        IF importe_bruto > 20000 THEN 
        BEGIN 
             WRITELN ('SE MERECE UN DESCUENTO DE: '
,descuento:5:2, 
                ' PTS'); 
             total:=importe_bruto - descuento; 
             WRITELN ('El total es de la factura es
 de: ',total:5:2, 
                ' pts') 
        END 
        ELSE 
             WRITE ('CON ESE DINERO NO SE MERECE UN
 DESCUENTO') 
END. 
