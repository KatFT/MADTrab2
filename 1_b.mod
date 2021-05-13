param Meses;

set P;
set T;
set O;
set M:= 1..Meses;
set B:= 0..Meses;

param CustoViagem;
param PrecoInventarioTerra;
param PrecoInventarioPlan;
param Preco{P, T, M};
param CapacidadeFoguete;
param CapacidadeProducao{O, T};


var Ativado{P, M} binary;
var Produzido{T, M} >= 0;
var Exportado{P, T, M} >= 0;
var InventorioT{T, B} >= 0;
var InventorioPlan{P,T,B} >=0;
var Entregue{P, T, M}>=0;


maximize Lucro:
  sum{p in P, t in T, m in M}
     (Entregue[p, t, m] * Preco[p, t, m])
  - PrecoInventarioTerra * sum {t in T, m in M} InventorioT[t, m]
  - CustoViagem * sum{p in P, m in M} Ativado[p,m]
  - PrecoInventarioPlan * sum {p in P,t in T, m in M} InventorioPlan[p,t, m];

subject to
  Foguete{m in M, p in P}:
     sum{t in T}
        Exportado[p, t, m] <= CapacidadeFoguete*Ativado[p,m];


  CapacidadeLinhaProducao{o in O, m in M}:
    sum{t in T} (Produzido[t, m] / CapacidadeProducao[o,t]) <= 1;

  CapInventorioIniT{t in T}:
     InventorioT[t, 0] = 0;

  BalancoInventorioT{t in T, m in M}:
    InventorioT[t, m] = InventorioT[t, m-1] + Produzido[t, m] - sum{p in P} Exportado[p, t, m];

  CapacidadeLinhaProdP{p in P,t in T}:
     InventorioPlan[p,t, 0] = 0;

  BalancoInventorioP{p in P,t in T, m in M}:
    InventorioPlan[p,t, m] = InventorioPlan[p,t, m-1] + Exportado[p,t,m] - Entregue[p,t,m];
