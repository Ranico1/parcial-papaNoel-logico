
% persona(nomobre, edad). 
persona(laura, 24). 
persona(federico, 31). 
persona(maria, 23). 
persona(jacobo, 45). 
persona(enrique,49 ). 
persona(andrea, 38). 
persona(gabriela, 4).
persona(gonzalo, 23).
persona(alejo, 20).
persona(andres, 11).
persona(ricardo, 39).
persona(ana, 7).
persona(juana, 15).

% quiere(Quien, Quiere)
quiere(andres, juguete(maxStell, 150)).
quiere(andres, bloques([piezaT, piezaL, cubo, piezaChata])).
quiere(maria, bloques([piezaT, piezaT])).
quiere(alejo, bloques([piezaT])).
quiere(juana, juguete(barbie, 175)).
quiere(federico, abrazo).
quiere(enrique, abrazo).
quiere(gabriela, juguete(gabeneitor2000, 5000)).
quiere(laura, abrazo).
quiere(gonzalo, abrazo).

% presupuesto(Quien, Presupuesto)

presupuesto(jacobo, 20).
presupuesto(enrique, 2311).
presupuesto(ricardo, 154).
presupuesto(andrea, 100).
presupuesto(laura, 2000).

% accion(Quien, Hizo)

accion(andres, travesura(3)).
accion(andres, ayudar(ana)).
accion(ana, golpear(andres)).
accion(ana, travesura(1)).
accion(maria, ayudar(federico)).
accion(maria, favor(juana)).
accion(juana, favor(maria)).
accion(federico, golpear(enrique)).
accion(gonzalo, golpear(alejo)).
accion(alejo, travesura(4)).

% padre(Padre o Madre, Hijo o Hija)

padre(jacobo, ana).
padre(jacobo, juana).
padre(enrique, federico).
padre(ricardo, maria).
padre(andrea, andres).
padre(laura, gabriela).


creeEnPapaNoel(Persona) :- 
    persona(Persona, Edad),
    Edad < 13. 

creeEnPapaNoel(federico). 

% Punto 1

buenaAccion(favor(_)).
buenaAccion(ayudar(_)).
buenaAccion(travesura(Nivel)) :- 
    Nivel =< 3. 


% Punto 2
sePortoBien(Persona) :- 
    accion(Persona, _),
    forall(accion(Persona, Accion), buenaAccion(Accion)). 


% Punto 3

malcriador(Padre) :- 
    padre(Padre,_),
    forall(padre(Padre,Hijo), malcriado(Hijo)).

malcriado(Persona) :-
    persona(Persona, _),
    not(creeEnPapaNoel(Persona)).

malcriado(Persona) :- 
    accion(Persona,_),
    forall(accion(Persona,Accion), malaAccion(Accion)).

malaAccion(Accion) :-
    accion(_,Accion), 
    not(buenaAccion(Accion)). 


% Punto 4

puedeCostear(Padre, Hijo) :- 
    padre(Padre, Hijo),
    costoRegalo(Hijo, Costo),
    leAlcanza(Padre, Costo).

costoRegalo(Hijo, Costo) :- 
    quiere(Hijo, _),
    findall(Costo, regalos(Hijo, Costo), Costos),
    sum_list(Costos, Costo). 
    
regalos(Hijo, Costo) :-
    quiere(Hijo, Regalo),
    precio(Regalo, Costo). 

precio(abrazo, 0).
precio(juguete(_,Costo), Costo). 
precio(bloques(ListaBloques), Costo) :- 
    length(ListaBloques, CantBloques),
    Costo is CantBloques * 3. 

leAlcanza(Padre, Costo) :-
    presupuesto(Padre, Presupuesto),
    Presupuesto >= Costo. 

% Punto 5

regaloCandidatoPara(Regalo, Persona) :- 
    creeEnPapaNoel(Persona), 
    sePortoBien(Persona),
    padre(Padre, Persona),
    puedeCostear(Padre, Persona),
    quiere(Persona, Regalo). 

% Punto 6

regalosQueRecibe(Persona, ListaDeRegalos) :- 
    persona(Persona,_),
    findall(Regalos, regalosQueQuiere(Persona, Regalos), ListaDeRegalos).

regalosQueQuiere(Persona, Regalo) :- 
    padre(Padre,Persona ),
    puedeCostear(Padre, Persona), 
    quiere(Persona, Regalo). 

regalosQueQuiere(Persona, Regalo) :- 
    padre(Padre,Persona),
    not(puedeCostear(Padre, Persona)), 
    regaloDePena(Persona, Regalo).

regaloDePena(Persona, medias) :- 
    sePortoBien(Persona).

regaloDePena(Persona, carbon) :-
    accion(Persona, Accion),
    malaAccion(Accion),
    accion(Persona, OtraAccion),
    malaAccion(OtraAccion),
    Accion \= OtraAccion. 

% Punto 7

sugarDaddy(Padre) :- 
    padre(Padre,_),
    forall(padre(Padre,Hijos), quiereAltoRegalo(Hijos)).

quiereAltoRegalo(Hijo) :- 
    quiere(Hijo,Regalo),
    regaloCaro(Regalo).

quiereAltoRegalo(Hijo) :- 
    quiere(Hijo,Regalo),
    valeLaPena(Regalo).

regaloCaro(Regalo) :-
    precio(Regalo, Costo),
    Costo > 500.

valeLaPena(juguete(buzz,_)).
valeLaPena(juguete(woody,_)).
valeLaPena(bloques(ListaBloques)) :-
    member(cubo,ListaBloques).
 


    
    

