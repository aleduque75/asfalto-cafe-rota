# Histórico de Migração e Configuração: Café Moto e Asfalto

Este documento registra todo o histórico de configuração, comandos e soluções aplicadas para a migração do sistema **Café Moto e Asfalto** para a sua VPS autohospedada. Ele serve como um manual de resgate caso você precise recriar o ambiente no futuro.

---

## 1. Estrutura do Ambiente (VPS)
O projeto deixou de depender do ecossistema Lovable na nuvem e passou a rodar 100% de forma soberana na sua VPS, utilizando a seguinte arquitetura:
- **Frontend:** React + Vite (Porta `8081`)
- **Backend/Banco de Dados:** Supabase Local via Docker (Porta `54321`)
- **Gerenciador de Tráfego:** Nginx Proxy Manager (NPM) para gerenciar domínios e certificados SSL (Let's Encrypt).

---

## 2. Configuração do Banco de Dados (Supabase)

No início, o sistema de login estava falhando (Erro 500) porque o banco de dados interno de autenticação estava corrompido ou ausente.

**Solução Aplicada:**
1. Paramos o Supabase completamente e limpamos os volumes antigos:
   ```bash
   npx supabase stop --no-backup
   ```
2. Iniciamos o Supabase do zero para reconstruir as tabelas de segurança do zero:
   ```bash
   npx supabase start
   ```
3. **Desativação de Confirmação de E-mail:**
   Para facilitar os testes, alteramos o arquivo `/supabase/config.toml` e definimos:
   ```toml
   [auth.email]
   enable_confirmations = false
   ```

---

## 3. Configuração do Frontend (Vite)

Para permitir que o frontend fosse acessado de fora da VPS através do Nginx Proxy Manager, fizemos duas mudanças cruciais:

1. **Abertura do Servidor (`vite.config.ts`):**
   Adicionamos a permissão para que o Vite aceitasse tráfego do domínio público.
   ```typescript
   server: {
     allowedHosts: true,
     host: "::",
     port: 8080,
   }
   ```
2. **Script de Inicialização Seguro:**
   O servidor foi colocado para rodar na porta 8081 para não conflitar com outros sistemas que você possui, utilizando o comando:
   ```bash
   npm run dev -- --host
   ```

---

## 4. O Desafio do "Failed to Fetch" (CORS e SSL)

Um dos maiores desafios foi fazer o aplicativo rodar perfeitamente tanto no Computador quanto no Celular usando conexão segura (`https://`).

### O Problema:
Quando você acessava `https://cafemotoasfalto.e-sal.app.br` (com SSL), o navegador bloqueava a comunicação com a API do Supabase porque ela estava apontando para o IP direto (`http://76.13.229.204:54321`), caracterizando erro de **Conteúdo Misto (Mixed Content)**.

### A Solução Definitiva (Nginx Proxy Manager):
Foi necessário criar um domínio exclusivo com SSL para a API do Supabase e vinculá-lo ao código fonte.

**Passo a passo realizado:**
1. Criamos um novo domínio no Nginx Proxy Manager chamado: `api-cafemotoasfalto.e-sal.app.br`.
2. Apontamos ele para o IP interno do Docker `172.17.0.1` na porta `54321`.
3. Geramos o certificado Let's Encrypt na aba SSL.
4. Alteramos o arquivo `.env` do projeto para refletir a nova realidade segura:
   ```env
   SUPABASE_URL="https://api-cafemotoasfalto.e-sal.app.br"
   VITE_SUPABASE_URL="https://api-cafemotoasfalto.e-sal.app.br"
   ```

> [!NOTE] 
> **Propagação de DNS:** Durante a troca de domínio, identificamos o erro "Servidor não encontrado" na guia anônima. Isso ocorreu apenas porque a internet local precisa de cerca de 15 a 30 minutos para "aprender" o novo domínio registrado no Cloudflare. 

---

## 5. Melhorias de Interface e Usabilidade (UI/UX)

Durante a validação visual, notamos problemas de contraste causados pelas cores globais do tema.

1. **Página de Login (`auth.tsx`):**
   - Melhoramos o contraste dos rótulos (labels) de "E-mail" e "Senha".
   - Adicionamos cor de fundo aos campos de digitação (Inputs) para que eles não sumissem contra o fundo escuro do site.

2. **Cartões de Moto (`garagem.tsx`):**
   - Corrigimos o fundo transparente na metade inferior do card da moto, que estava engolindo o texto escuro (letras marrons em fundo marrom).
   - Aplicamos a classe `bg-cream` no `<Card>`, garantindo um visual elegante e leitura perfeita das informações (Km, placa, etc).
   - Adicionamos o botão de **"Editar moto"** na página de detalhes, criando um modal que puxa as informações atuais do banco e permite a atualização instantânea sem precisar apagar o registro.

---

## Próximos Passos Recomendados

Para transformar este ambiente de teste em uma **Produção Definitiva**, recomendo futuramente:
1. Em vez de usar `npm run dev`, compilar o aplicativo usando `npm run build`.
2. Servir os arquivos compilados (estáticos) diretamente através do próprio Nginx ou Node usando ferramentas como o `PM2`, o que consumirá muito menos memória RAM da VPS.
