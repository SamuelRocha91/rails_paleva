# <img src="https://cdn-icons-png.flaticon.com/128/82/82667.png" alt="Rails Projects Logo" width="40" height="30" /> Rails "Pá Levá" <img src="https://cdn-icons-png.flaticon.com/128/82/82667.png" alt="Rails Projects Logo" width="40" height="30" /> 


![Em Desenvolvimento](https://img.shields.io/badge/status-Em%20Desenvolvimento-yellow)

<details>

<summary> <h2>Visão Geral</h2> </summary>

Este projeto está sendo desenvolvido como requisito avaliativo do programa <a href="https://treinadev.com.br/">Treina Dev</a> da <a href="https://www.campuscode.com.br/">Campus Code</a>. O projeto consiste num **Sistema de Gerenciamento de Estabelecimentos que Comercializam Alimentos** desenvolvido com Ruby on Rails.

</details>

<details>

<summary> <h2>Estrutura do banco de dados<h2> </summary>

![Diagrama](./public/diagrama.png)

</details>

<details>

<summary> <h2>Instruções de uso</h2> </summary>

---
## Configuração do Ruby
Este projeto requer o Ruby na versão `3.2.2`. Recomendamos usar [RVM](https://rvm.io/) ou [rbenv](https://github.com/rbenv/rbenv) para gerenciar versões do Ruby.

### Com RVM:
```bash
rvm install 3.2.2
rvm use 3.2.2
```

### Com rbenv:
```bash
rbenv install 3.2.2
rbenv local 3.2.2
```
Outra opção é inserir a sua versão do ruby diretamente no gemfile da aplicação.

Aqui está um exemplo de texto para o seu README, explicando como configurar o ambiente para atender ao requisito da versão do Rails:

---

### Requisitos de Versão do Rails

Este projeto utiliza o **Rails ~> 7.1.3**, o que significa que ele é compatível com qualquer versão **>= 7.1.3 e < 7.2.0**. 

#### Verificando a Versão do Rails

Para verificar a versão do Rails instalada no seu ambiente, execute:

```bash
rails -v
```

Se a versão instalada não atender ao requisito, siga as etapas abaixo para instalar a versão correta.

#### Instalando a Versão do Rails

1. **Comando para instalar uma versão específica do Rails:**

   Certifique-se de ter o RubyGems configurado corretamente e execute o seguinte comando:

   ```bash
   gem install rails -v '~> 7.1.3'
   ```

2. **Atualizando o projeto para usar a versão correta do Rails:**

   Após instalar a versão do Rails, você pode usar o Bundler para garantir que a versão correta seja utilizada:

   ```bash
   bundle install
   ```

3. **Confirmando a versão no projeto:**

   Verifique se o arquivo `Gemfile.lock` contém a versão correta:

   ```bash
   cat Gemfile.lock | grep 'rails ('
   ```

   O resultado deve incluir algo como:

   ```plaintext
   rails (7.1.3)
   ```


## 1. Clonando o Repositório

Primeiro, você precisa clonar o repositório para o seu ambiente local. Abra o terminal e execute o seguinte comando:

```bash
git clone git@github.com:SamuelRocha91/rails_paleva.git
cd rails_paleva
```

## 2. Instalando as Dependências

Antes de rodar a aplicação, é necessário instalar as dependências. Para isso, use o Bundler:

```bash
bundle install
```

Isso irá instalar todas as gems necessárias para a aplicação.

## 3. Configurando o Banco de Dados

A aplicação utiliza o banco de dados para armazenar os dados. Siga os passos abaixo para configurar e migrar o banco de dados.

### Criar o Banco de Dados

Execute o seguinte comando para criar o banco de dados:

```bash
rails db:create
```

### OBS: Em caso de erro no procedimento anterior, não sendo a questão inicialmente tratada da versão do ruby no gemfile x local, pode ser preciso rodar: 
```bash
bundle install
bundle pristine
rails db:create
```

### Rodar as Migrações

Agora, você deve rodar as migrações para garantir que a estrutura do banco de dados esteja atualizada:

```bash
rails db:migrate
```

### Rodando as Seeds

Após as migrações, você pode rodar as *seeds* para popular o banco de dados com dados iniciais, como usuários e registros do sistema. Para isso, execute:

```bash
rails db:seed
```

Isso irá criar usuários e outros dados necessários para começar a testar a aplicação.

## 4. Usuários Preexistentes

Para facilitar a navegação e testes no sistema, preparamos alguns usuários padrão que você pode usar para se autenticar na aplicação:

### Usuários Administradores

- **Email**: urso@gmail.com
- **Senha**: 1234567891234

Este usuário tem acesso completo ao sistema e pode gerenciar todos os aspectos da aplicação.

### Usuários Comuns

- **Email**: boimanso@gmail.com
- **Senha**: 1234567891234

Este usuário pode acessar as funcionalidades limitadas da aplicação, mas não tem permissões administrativas.

## 5. Rodando a Aplicação

Agora que o banco de dados foi configurado e as seeds foram aplicadas, você pode rodar a aplicação localmente. Execute o seguinte comando para iniciar o servidor:

```bash
rails server
```

Isso irá iniciar o servidor localmente. Você pode acessar a aplicação através do navegador, indo para [http://localhost:3000](http://localhost:3000).

## 6. Testando a Aplicação

Com o servidor em funcionamento, use as credenciais dos usuários fornecidos para navegar pela aplicação. O usuário administrador pode acessar todas as funcionalidades, enquanto o usuário comum pode testar funcionalidades limitadas.

É possível também rodar os testes de sistema, unitários e de request da aplicação a partir do seguinte comando:

```bash
bundle exec rspec
```

</details>


