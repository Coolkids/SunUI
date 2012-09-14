-- Thanks to Phanx!

if GetLocale() ~= "ptBR" and GetLocale() ~= "ptPT" then
        return
end

local L = BUYEMALL_LOCALS

L.MAX         = "Máx"
L.STACK       = "Pilha"
L.CONFIRM     = "Tem certeza de que deseja comprar\n %d × %s?"
L.STACK_PURCH = "Comprar Pilha"
L.STACK_SIZE  = "Tamanho da pilha"
L.PARTIAL     = "Pilha parcial"
L.MAX_PURCH   = "Máximo de compra"
L.FIT         = "Tem espaço para"
L.AFFORD      = "Tem dinheiro para"
L.AVAILABLE   = "Comerciante tem"