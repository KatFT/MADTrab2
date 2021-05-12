set Planetas;
set Tipo;
set Operacao;


param CustoViagem;
param Meses;
param PrecoInventarioTerra;
param Preco{Planetas, Tipo, {1..Meses}};
param CapacidadeFoguete;
param CapacidadeProducao{Operacao, Tipo};


var Ativado{Planetas, {1..Meses}} binary;
var Produzido{Tipo, {1..Meses}} >= 0;
var Exportado{Planetas, Tipo, {1..Meses}} >= 0;
var InventorioT{Tipo, {0..Meses}} >= 0;

maximize Lucro:
  sum{p in Planetas, t in Tipo, m in {1..Meses}}
     (Exportado[p, t, m] * Preco[p, t, m])
  -
  PrecoInventarioTerra * sum {t in Tipo, m in {1..Meses}}
                  InventorioT[t, m]
  -  CustoViagem * sum{p in Planetas, m in {1..Meses}} Ativado[p,m];

subject to
  Foguete{m in {1..Meses}, p in Planetas}:
     sum{t in Tipo}
        Exportado[p, t, m] <= CapacidadeFoguete*Ativado[p,m];


  CapInventorioIniT{t in Tipo}:
     InventorioT[t, 0] = 0;

  BalancoInventorioT{t in Tipo, m in {1..Meses}}:
    InventorioT[t, m] = InventorioT[t, m-1] + Produzido[t, m] - sum{p in Planetas} Exportado[p, t, m];

  CapacidadeLinhaProducao{o in Operacao, m in {1..Meses}}:
     sum{t in Tipo} (Produzido[t, m] / CapacidadeProducao[o, t]) <= 1;

  