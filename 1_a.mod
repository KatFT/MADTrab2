param Meses;

set P;
set T;
set O;
set M:= 1..Meses;
set B:= 0..Meses;


param CustoViagem;
param PrecoInventarioTerra;
param Preco{P, T, M};
param CapacidadeFoguete;
param CapacidadeProducao{O, T};



var Ativado{P, M} binary;
var Produzido{T, M} >= 0;
var Exportado{P, T, M} >= 0;
var InventorioT{T, B} >= 0;

maximize Lucro:
  sum{p in P, t in T, m in M}
     (Exportado[p, t, m] * Preco[p, t, m])
  -
  PrecoInventarioTerra * sum {t in T, m in M}
                  InventorioT[t, m]
  -  CustoViagem * sum{p in P, m in M} Ativado[p,m];

subject to
  Foguete{m in M, p in P}:
     sum{t in T}
        Exportado[p, t, m] <= CapacidadeFoguete*Ativado[p,m];


  CapInventorioIniT{t in T}:
     InventorioT[t, 0] = 0;

  BalancoInventorioT{t in T, m in M}:
    InventorioT[t, m] = InventorioT[t, m-1] + Produzido[t, m] - sum{p in P} Exportado[p, t, m];

  CapacidadeLinhaProducao{o in O, m in M}:
     sum{t in T} (Produzido[t, m] / CapacidadeProducao[o, t]) <= 1;

  