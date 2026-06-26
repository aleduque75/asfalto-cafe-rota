# Café Moto e Asfalto 🏍️

Plataforma oficial do moto clube "Café Moto e Asfalto". Este repositório contém o site público, blog de notícias e a plataforma administrativa (SaaS) restrita aos membros e administradores do clube.

## 🛠 Tecnologias Utilizadas

O sistema foi construído utilizando as melhores e mais modernas práticas do ecossistema JavaScript/TypeScript:

- **Frontend:** React com Vite
- **Roteamento:** TanStack Router (File-based routing para melhor performance e organização)
- **Estilização:** Tailwind CSS + Componentes Shadcn UI
- **Backend (BaaS):** Supabase (Banco de Dados PostgreSQL, Autenticação, Row Level Security)
- **Armazenamento de Mídia:** Amazon S3 (Upload via Presigned URLs)
- **Automação:** n8n (Integração automática do feed do Instagram com a Galeria)

## 📌 Funcionalidades Principais

### Site Público (Landing Page)
- **Hero & Institucional:** Apresentação do moto clube, valores e estética de "estrada".
- **Galeria Automática (`/galeria`):** Galeria de fotos alimentada automaticamente pelo feed do Instagram oficial da marca. Conta com um carrossel estilo "Stories" responsivo para mobile usando `embla-carousel`.
- **Blog de Diário de Bordo (`/noticias`):** Relatos das viagens, encontros e roteiros do clube.

### Área do Membro (`/dashboard`)
- **Autenticação:** Login e cadastro seguro com Supabase Auth.
- **Minha Garagem:** Área restrita para os membros cadastrarem as próprias motocicletas (Modelo, Ano, Placa, Foto). Gerenciamento com regras de RLS (apenas o dono pode editar sua moto).

### Painel Administrativo (`/admin`)
- **Construtor de Artigos (News Builder):** Um editor visual inteligente em blocos para a criação de postagens do blog. Administradores podem mesclar blocos de texto, subtítulos e uploads diretos de fotos em qualquer ordem, além de configurar datas retroativas para relatos de viagens passadas.
- **Aprovação de Conteúdo:** Gerenciamento seguro para manter a estética e coerência da plataforma.

## 🚀 Como Rodar o Projeto

1. **Clone o repositório:**
```bash
git clone https://github.com/aleduque75/asfalto-cafe-rota.git
cd asfalto-cafe-rota
```

2. **Instale as dependências:**
```bash
npm install
```

3. **Configure as Variáveis de Ambiente:**
Crie um arquivo `.env` na raiz do projeto e preencha as variáveis referentes ao Supabase e ao bucket da AWS S3 (conforme as integrações do sistema).

4. **Inicie o Servidor de Desenvolvimento:**
```bash
npm run dev
```

5. Acesse `http://localhost:8080` no seu navegador.

## 📖 Arquitetura Detalhada
Se você é um desenvolvedor explorando o código, consulte o arquivo `DOCUMENTACAO.md` na raiz do projeto para um mapeamento completo da arquitetura de banco de dados, regras de segurança RLS (Row Level Security) e fluxos de automação do n8n.

---
*"Mais do que combustível, o café é o pretexto pra conversa, pra rever a rota e pra deixar a estrada esperar mais um pouco."*
