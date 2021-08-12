% Aquí va el código.


rata(remy).
rata(emile).
rata(django).

vive(remy, gusteaus).
vive(emile, chezMilleBar).
vive(django,pizzeriaJeSuis).


humano(linguini).
humano(colette).
humano(horst).

humano(Persona):-
    trabaja(Persona,_).

sabeCocinar(linguini,ratatouille,3).
sabeCocinar(linguini, sopa,5).
sabeCocinar(colette, salmonAsado,9).
sabeCocinar(horst,ensaladaRusa, 8).

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).


trabaja(linguini,gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie,cafe2Moulins).



tutor(skinner, amelie).

tutor(linguini, Tutor):-
    rata(Tutor),
    trabaja(linguini, Restaurante),
    vive(Tutor,Restaurante).





estaEnElMenu(Plato, Restaurante):-
    trabaja(Persona, Restaurante),
    sabeCocinar(Persona,Plato,_).

sabeCocinarBien(remy,_).


sabeCocinarBien(Persona, Plato):-
    tutor(Persona, Tutor),
    sabeCocinarBien(Tutor,Plato).

sabeCocinarBien(Persona, Plato):-
    sabeCocinar(Persona, Plato, Experiencia),
    muchaExperiencia(Experiencia).

muchaExperiencia(Experiencia):-
    Experiencia > 7.


esChefDe(Restaurante,Persona):-
    trabaja(Persona,Restaurante),
    forall(estaEnElMenu(Plato,Restaurante),sabeCocinarBien(Persona,Plato)).

esChefDe(Restaurante,Persona):-
    trabaja(Persona,Restaurante),
    findall(Experiencia, (estaEnElMenu(Plato, Restaurante), sabeCocinar(Persona,Plato,Experiencia)),Experiencias),
    sumlist(Experiencias, ExpTotal),
    ExpTotal >= 20.


encargadoDeCocinar(Persona,Plato,Restaurante):-
    trabaja(Persona,Restaurante),
    sabeCocinar(Persona,Plato,ExperienciaMayor),
    forall((trabaja(OtraPersona,Restaurante), sabeCocinar(OtraPersona,Plato,ExperienciaMenor)), 
    ExperienciaMenor < ExperienciaMayor).

encargadoDeCocinar(Persona,Plato, Restaurante):-
    trabaja(Persona,Restaurante),
    trabaja(OtraPersona, Restaurante),
    sabeCocinar(Persona,Plato,_),
    sabeCocinar(OtraPersona,Plato,_),
    OtraPersona = Persona.


caloriasQueAporta(pure, 20).
caloriasQueAporta(papasFritas,50).
caloriasQueAporta(ensalada,0).




calorias(Plato, Calorias):-
    caloriasEntrada(Plato,Calorias).

calorias(Plato, Calorias):-
    caloriasPlatoPrincipal(Plato,Calorias).

calorias(Plato, Calorias):-
    caloriasPostre(Plato,Calorias).


caloriasEntrada(Plato,Calorias):-
    plato(Plato, entrada(Ingredientes)),
    length(Ingredientes, Cant),
    Calorias is Cant * 15.

caloriasPlatoPrincipal(Plato,Calorias):-
    plato(Plato, principal(Guarnicion,MinutosCoccion)),
    caloriasQueAporta(Guarnicion, CaloriasGuarnicion),
    Calorias is CaloriasGuarnicion + (MinutosCoccion * 5).

caloriasPostre(Plato, Calorias):-
    plato(Plato, postre(Calorias)).


esSaludable(Plato):-
    calorias(Plato, Calorias),
    caloriasSaludables(Calorias).

caloriasSaludables(Calorias):-
    Calorias < 75.

not(daCriticaPositiva(gordonRamsey,_)).

daCriticaPositiva(Critico,Restaurante):-
    trabaja(_, Restaurante),
    not(vive(_,Restaurante)),
    criterioDeCritico(Critico,Restaurante).



criterioDeCritico(antonEgo, Restaurante):-
    esEspecialistaEn(ratatouille,Restaurante).


criterioDeCritico(cormillot,Restaurante):-
    forall((trabaja(Empleado,Restaurante),sabeCocinar(Plato,Empleado,_)), esSaludable(Plato)).


criterioDeCritico(martiniano, Restaurante):-
    esChefDe(Restaurante, Empleado),
    esChefDe(Restaurante, OtroEmpleado),
    Empleado = OtroEmpleado.


esEspecialistaEn(Plato,Restaurante):-
    estaEnElMenu(Plato,Restaurante),
    forall((trabaja(Persona,Restaurante),esChefDe(Restaurante,Persona)), sabeCocinarBien(Persona,Plato)). 