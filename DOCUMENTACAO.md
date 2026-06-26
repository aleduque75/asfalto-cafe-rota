# Asfalto Café Rota - Documentação do Sistema e Arquitetura

Este documento serve como memória (RAG) para futuras interações com a IA (Antigravity). Ele contém o mapeamento completo de tudo o que foi construído até o momento para o sistema do moto clube.

## 1. Visão Geral e Stack Tecnológico
O sistema é uma plataforma completa (SaaS-like) para um Moto Clube, dividida entre um site público (Landing Page, Galeria, Blog de Notícias) e uma área restrita (Painel de Membros e Administração).

- **Frontend:** React com Vite, TypeScript.
- **Roteamento:** TanStack Router (File-based routing).
- **Estilização:** Tailwind CSS + Shadcn UI.
- **Backend & Banco de Dados:** Supabase (PostgreSQL, Auth, Storage).
- **Automação:** n8n rodando em background.
- **Infraestrutura:** VPS Linux (Hostinger), Nginx Proxy Manager (para HTTPS e roteamento de domínios). O app roda via processo Node/PM2.

## 2. Estrutura do Banco de Dados (Supabase)
O banco de dados relacional foi modelado para suportar todas as funcionalidades. As tabelas principais são:

### `profiles` (Membros)
Estende os usuários do Supabase Auth.
- Campos: `id` (references auth.users), `full_name`, `avatar_url`, `role` (user/admin), `bio`, `whatsapp`.
- RLS: Membros só podem editar o próprio perfil. Admins têm acesso total.

### `motorcycles` (Garagem)
Permite que os membros cadastrem suas motos.
- Campos: `id`, `profile_id`, `brand`, `model`, `year`, `plate`, `photo_url`, `is_verified` (booleano para aprovação do admin).
- RLS: Membros podem gerenciar as próprias motos.

### `gallery_items` (Galeria do Instagram)
- Campos: `id`, `title`, `caption`, `image_url`, `instagram_url`, `status` (draft/published), `sort_order`.
- Alimentada automaticamente via n8n.

### `news` (Blog / Diário de Bordo)
- Campos: `id`, `title`, `slug`, `excerpt`, `content` (Armazena os blocos do Construtor de Artigos em formato JSON *stringificado*), `cover_url`, `tag`, `status`, `published_at`.

### `site_content`
- Tabela Key-Value para configurações dinâmicas do site (ex: logo do clube na chave `general`).

## 3. Funcionalidades Desenvolvidas (Até Junho 2026)

### 3.1. Site Público (Rotas em `/`)
- **Landing Page Dinâmica:** Hero section, seção sobre o moto clube, e cards das últimas notícias.
- **Galeria (`/galeria` e âncora):** Possui um carrossel estilo "Instagram Stories" no mobile (com barras de progresso que enchem com o tempo) utilizando `embla-carousel-autoplay`.
- **Notícias (`/noticias` e `/noticias/$slug`):** Lista os artigos publicados. A página interna do artigo lê o JSON da coluna `content` e renderiza os blocos textuais, subtítulos e imagens no meio da tela com layout premium.

### 3.2. Área de Autenticação (`/auth`)
- Login/Cadastro direto integrado ao Supabase Auth.

### 3.3. Painel do Membro (`/dashboard`)
- Layout restrito apenas para usuários logados.
- **Minha Garagem:** O usuário pode adicionar, editar (formulário corrigido para RLS) e apagar suas próprias motos.

### 3.4. Painel de Administração (`/admin`)
- Acesso restrito a usuários com `role = 'admin'`.
- **Construtor de Artigos:** Criamos um editor visual para as Notícias. O administrador insere blocos (`+ Texto`, `+ Subtítulo`, `+ Foto`) que são salvos como JSON no banco, e escolhe a `Data do Relato` retroativa. As imagens fazem upload direto pro AWS S3 via rota assinada.

### 3.5. Automações n8n
- **Galeria Inteligente:** Um workflow no n8n foi criado para consumir o feed RSS do Instagram (via rss.app), limpar a URL da imagem usando Regex, e inserir automaticamente na tabela `gallery_items` usando a `SERVICE_ROLE_KEY` do Supabase para ter privilégios de administrador.

## 4. Notas de Arquitetura e Código
- **Upload de Arquivos:** Utiliza um módulo customizado em `src/lib/upload.ts` que gera Presigned URLs para o Amazon S3 e envia as imagens (usado em motos, notícias e blocos). Inclui também a função `slugify`.
- **Problemas Resolvidos Recentemente:**
  - O texto invisível no Admin de Notícias devido ao contraste escuro vs branco (`bg-white` alterado para `bg-black/20`).
  - Conflito de rotas antigas (`noticias.index.tsx` e `noticias.$slug.tsx` legados foram apagados para dar prioridade aos aninhados).
  - Configuração de links de navegação cruzada (`cross-page`) utilizando `Link hash="..."` do TanStack Router.

## 5. Próximos Passos (Sugestões/Ideias no backlog)
- Expandir a área de "Rotas" (`/rotas`), permitindo que administradores mapeiem rotas de viagens frequentes no mapa.
- Finalizar integrações pendentes de Meta Ads Pixel (se aplicável ao funil do clube).
- Sistema de verificação/aprovação de motos pelos admins.
