> [!IMPORTANT]
> **PROJETO MIGRADO DA LOVABLE PARA VPS**
>
> Este projeto não está mais atrelado ao Lovable. Ele está implantado diretamente em uma VPS.
> 
> **CONTEXTO DO AMBIENTE (Sempre lembre disso nas próximas sessões):**
> 1. O deploy do frontend é feito automaticamente via **GitHub Actions** (bastando commitar e fazer push do código).
> 2. O **Supabase é externo/remoto** (não é o da VPS local). Os containers do Supabase que rodavam localmente na VPS podem ser ignorados ou deletados para evitar confusão.
> 3. Ao fazer alterações no banco de dados (migrations), NÃO dependa de sincronizações de plataformas. Como o banco é externo, você não deve executar scripts SQL no banco local. Peça para o usuário rodar no Supabase dele ou oriente-o sobre o script.
> 4. Não se preocupe mais com o alerta antigo de "Lovable Git History", mas sempre mantenha o código versionado no repositório GitHub.
