> [!IMPORTANT]
> **PROJETO MIGRADO DA LOVABLE PARA VPS**
>
> Este projeto não está mais atrelado ao Lovable. Ele está implantado diretamente em uma VPS.
> 
> **CONTEXTO DO AMBIENTE (Sempre lembre disso nas próximas sessões):**
> 1. O frontend roda em Docker (como listado em `docker-compose.yml`) com o nome `asfalto-cafe-rota-preview`. Para fazer deploy das alterações do front, rode `docker compose up --build -d` na raiz.
> 2. O **Supabase é self-hosted** e está rodando em containers Docker locais nesta mesma VPS (ex: `supabase_db_dphpnagvizyphgehussx`).
> 3. Ao fazer alterações no banco de dados (migrations), NÃO dependa de sincronizações de plataformas. Você deve aplicar os scripts SQL diretamente no banco self-hosted via terminal (ou solicitar que o usuário aplique).
> 4. Não se preocupe mais com o alerta antigo de "Lovable Git History", mas sempre mantenha o código versionado no repositório GitHub.
