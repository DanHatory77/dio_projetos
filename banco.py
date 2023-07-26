
menu = """
==========BANCO 777===========
Olá usuário! O que gostaria de fazer?

[d]Depósito
[s]Saque
[e]Extrato
[q]Sair


=>"""

saldo = 0
limite = 500
extrato = ""
numero_saques = 0
LIMITE_SAQUES = 3

while True:
    
    opcao = input(menu)
    
    if opcao == "d":
        valor = float(input("Informe o valor do depósito:"))
        
        if valor > 0:
            saldo += valor
            extrato += f"Deposito: R$ {valor:.2f}\n"
            print(f'Valor {valor} depositado com sucesso!')
        else:
            print("Operação falhou! O valor informado é inválido!")
    
    elif opcao == "s":
        valor = float(input("Informe o valor do saque:"))
        excedeu_saldo = valor > saldo
        excedeu_limite = valor > limite
        excedeu_saques = numero_saques >= LIMITE_SAQUES
        if excedeu_saldo:
            print("Operação falhou! Você não tem saldo suficiente.")
        elif excedeu_limite:
            print("Oparação falhou! O valor do saldo excede o limite.")
        elif excedeu_saques:
            print("Operação falhou! O número máximo de saques foi excedido.")
        elif valor > 0:
            saldo -= valor
            extrato += f"Saque R$ {valor:.2f}\n"
            numero_saques += 1
            print(f'Valor {valor} sacado com sucesso!')
        
        else:
            print("Operação falhou! O valor informado é inválido.")
            
    elif opcao == "e":
        print("\n=======EXTRATO=======")
        print("Não foram realizadas movimentações." if not extrato else extrato)
        print(f"\nSaldo: R$ {saldo:.2f}")
        print("=========================")
        
    elif opcao == "q":
        print("O banco 777 agradece sua visita!")
        break
        
    
    else:
        print('Operação invalida, por favor selecione novamente a operação desejada.')
        
   