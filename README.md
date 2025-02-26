# API Pedido de Venda

<h3>Bem-vindo.</h3>
A API de Pedido de Venda, desenvolvida em Delphi com o framework Horse. Este projeto foi originalmente construído para atender a requisitos específicos de pedidos de venda. Embora a implementação não siga todos os princípios de design mais modernos e sólidos, ele continua funcional e útil para estudos ou para a construção de aplicações front-end que necessitem de uma API de backend básica porem com recursos mais elaborados.

## Motivação

Este projeto foi iniciado a muito tempo rsrsrs, antes de eu ter uma compreensão completa dos princípios de SOLID e da Clean Architecture. Com o tempo e a experiência, algumas das práticas aqui poderiam ser revisadas para uma melhor estruturação e modularidade. Apesar disso, a API cumpre seu propósito e pode servir de base para outros estudos e experimentos.

## Tecnologias Utilizadas

- **Linguagem:** Delphi
- **Framework:** Horse
- **Ferramenta de Teste:** Postman

## Estrutura e Organização

A API foi construída para oferecer funcionalidades básicas de pedidos de venda, com algumas regras de negócio específicas e validações simples. Portanto, evite julgar a forma como foi implementada; como mencionei, alguns processos foram feitos de maneiras que, com a experiência adquirida, eu certamente não utilizaria hoje.

## Funcionalidades

- Cadastro e edição de clientes
- Listagem de clientes
- Criação e atualização de pedidos de venda
- Listagem e exclusão de pedidos de venda
- Cadastro e edição de dados de usuários
- Login de usuário com autenticação JWT
- Notificação para usuário
- Consulta do horário do servidor
- Listagem e cadastro de condições de pagamento
- Listagem e cadastro de produtos
- Listagem e cadastro de fotos de produtos

### Importante

Essa API foi desenvolvida com propósitos específicos de negócio, com validações simplificadas. Não foram seguidos princípios avançados de arquitetura e design, mas a API está funcional e pode servir de ponto de partida para estudos.

## Requisitos

- Delphi
- Framework Horse
- Um cliente REST para testes (como Postman)

## Instalação e Execução

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/lucasdefreitasroberto/PedidoFacil
   ```

2. **Instale as dependências necessárias do Delphi e Horse.**

3. **Execute o projeto.**

4. **Utilize o Postman (ou outra ferramenta) para testar a API com os endpoints disponíveis.**

## Testes

Testes básicos foram realizados com o Postman para validar as funcionalidades da API. Ela está funcional para os endpoints básicos, mas devido ao propósito inicial, não foram implementados testes automatizados ou avançados.

## Considerações Finais

Deixo esta API disponível para estudos e explorações. Ela pode ser utilizada como uma base de exemplo para aqueles que desejam construir uma aplicação de pedidos de venda ou necessitam de uma estrutura simples de backend. A implementação pode ser refinada e ajustada para melhor atender aos princípios de Clean Architecture e SOLID.

---




## PedidoFacil

**PedidoFacil** é um aplicativo móvel completo, desenvolvido para gerenciar pedidos de venda e cadastro de clientes. 
<br>O aplicativo foi projetado para funcionar tanto online quanto offline, garantindo que os usuários possam continuar a registrar informações mesmo sem conexão com a internet. 
<br>Quando a conectividade é restaurada, o usuario poder realizar a sincronização dos registro realizados, e importando para sistema de gestão de dados.

### Funcionalidades Principais

- **Cadastro de Clientes:** Permite adicionar, editar e visualizar informações dos clientes.
- **Criação de Pedidos de Venda:** Fácil registro de novos pedidos com detalhes completos.
- **Sincronização de Dados:** Sincronização automática de dados entre o aplicativo offline e o banco de dados central quando a conexão com a internet é restabelecida.
- **Operação Offline:** Continue a usar o aplicativo sem interrupções, mesmo sem acesso à internet. Todos os dados serão armazenados localmente e sincronizados posteriormente.
- **Interface Intuitiva:** Design de interface de usuário simples e fácil de usar para garantir uma experiência fluida.

### Rotas
## **usuarios**

![image](https://github.com/user-attachments/assets/19bddcaf-6c01-4415-97ad-813c519b8eb7)

## **clientes**

![image](https://github.com/user-attachments/assets/98d60a69-abbc-4a7d-942e-34bbbe59def2)

## **produtos**

![image](https://github.com/user-attachments/assets/5e7c828d-30b6-4f21-9156-baa0304b5e26)

## **pedidos**

![image](https://github.com/user-attachments/assets/60fff954-a30b-458a-98b8-70daa624c60d)

## **notificacoes**

![image](https://github.com/user-attachments/assets/89417885-70d8-4d06-a2fb-133dfe54a315)

## **cond-pagto**
![image](https://github.com/user-attachments/assets/0f01206a-db88-4d80-8088-c55eb9984c91)

### Figma

```sh
https://www.figma.com/design/vaK0eDh7IOXFmFOM8DizPj/Pedido-F%C3%A1cil?node-id=2-3&t=Z5QYkotzkCBOJh0Q-1
```
```sh
https://www.figma.com/proto/vaK0eDh7IOXFmFOM8DizPj/Pedido-F%C3%A1cil?page-id=0%3A1&node-id=2-3&viewport=232%2C245%2C0.54&t=w7TcmXoiVZh2EeAc-1&scaling=scale-down&content-scaling=fixed&starting-point-node-id=2%3A3
```
