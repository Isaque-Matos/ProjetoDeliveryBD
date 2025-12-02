# 🍔 Na Faixa Food
### Sistema de Gerenciamento de Entregas de Refeições — Projeto de Banco de Dados SQL Server
---
## 📋 Descrição do Projeto
O Na Faixa Food é um projeto acadêmico que simula o banco de dados de um sistema de entrega de refeições.  
O objetivo é permitir que o aluno projete, implemente e manipule um banco de dados relacional completo, aplicando conceitos de modelagem, normalização e lógica de negócio SQL.  
O projeto foi desenvolvido inteiramente em SQL Server, e o resultado final é um único arquivo `.sql` contendo todos os scripts necessários, devidamente comentados e organizados.

---
## 🎯 Objetivo Geral
Desenvolver um banco de dados relacional funcional que gerencie:
- Clientes
- Itens
- Entregadores
- Pedidos
- Avaliações
Simulando o fluxo completo de um sistema de delivery de refeições.  
O projeto abrange desde a criação das tabelas até a implementação de consultas complexas, views e stored procedures automatizadas.
---
## 🧩 Estrutura do Projeto
O arquivo final contém:
1. 🏗️ Criação de Tabelas (`CREATE TABLE`)
2. 📥 Inserção de Dados (`INSERT INTO`)
3. 🔍 Consultas (`SELECT`)
4. ✏️ Atualização de Dados (`UPDATE`)
5. 🔗 Junções (`JOIN`)
6. 👁️ Views (`CREATE VIEW`)
7. ⚙️ Stored Procedures (`CREATE PROCEDURE`)
---
## 🧱 Modelagem de Dados (Entidades Principais)
O banco de dados foi projetado com as seguintes entidades principais:

| Entidade      | Descrição                                                        |
|---------------|------------------------------------------------------------------|
| Clientes      | Informações dos usuários que fazem pedidos                      |
| Entregadores  | Responsáveis pela entrega das refeições                         |
| Pedidos       | Registros das solicitações feitas pelos clientes                |
| Itens         | Detalhamento dos produtos incluídos em cada pedido               |
| Avaliações    | Feedback dos clientes sobre os restaurantes e entregadores      |
