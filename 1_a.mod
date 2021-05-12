param Meses;

set Planetas;
set Tipo;
set Operacao;
set T:= 1..Meses;
set B:= 0..Meses;


param CustoViagem;

param PrecoInventarioTerra;
param Preco{Planetas, Tipo, T};
param CapacidadeFoguete;
param CapacidadeProducao{Operacao, Tipo};



var Ativado{Planetas, T} binary;
var Produzido{Tipo, T} >= 0;
var Exportado{Planetas, Tipo, T} >= 0;
var InventorioT{Tipo, B} >= 0;

maximize Lucro:
  sum{p in Planetas, t in Tipo, m in T}
     (Exportado[p, t, m] * Preco[p, t, m])
  -
  PrecoInventarioTerra * sum {t in Tipo, m in T}
                  InventorioT[t, m]
  -  CustoViagem * sum{p in Planetas, m in T} Ativado[p,m];

subject to
  Foguete{m in T, p in Planetas}:
     sum{t in Tipo}
        Exportado[p, t, m] <= CapacidadeFoguete*Ativado[p,m];


  CapInventorioIniT{t in Tipo}:
     InventorioT[t, 0] = 0;

  BalancoInventorioT{t in Tipo, m in T}:
    InventorioT[t, m] = InventorioT[t, m-1] + Produzido[t, m] - sum{p in Planetas} Exportado[p, t, m];

  CapacidadeLinhaProducao{o in Operacao, m in T}:
     sum{t in Tipo} (Produzido[t, m] / CapacidadeProducao[o, t]) <= 1;

  