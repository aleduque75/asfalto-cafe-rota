import { createFileRoute } from "@tanstack/react-router";
import { Navbar } from "@/components/site/Navbar";
import { Footer } from "@/components/site/Footer";

export const Route = createFileRoute("/politica-de-privacidade")({
  component: PoliticaDePrivacidade,
});

function PoliticaDePrivacidade() {
  return (
    <div className="min-h-screen scroll-smooth bg-cream text-coffee">
      <Navbar />
      <main className="container mx-auto px-4 py-32 max-w-4xl">
        <h1 className="text-4xl font-display mb-8">Política de Privacidade</h1>
        
        <div className="space-y-6 text-leather leading-relaxed">
          <p>
            O <strong>Café Moto e Asfalto</strong> valoriza a sua privacidade e se compromete a proteger os
            seus dados pessoais. Esta Política de Privacidade explica como coletamos, usamos e protegemos
            as suas informações quando você utiliza o nosso aplicativo.
          </p>

          <h2 className="text-2xl font-display text-copper pt-4">1. Informações que Coletamos</h2>
          <p>
            Para o funcionamento do nosso motoclube e aplicativo, coletamos os seguintes dados:
          </p>
          <ul className="list-disc pl-6 space-y-2">
            <li><strong>Informações de Cadastro:</strong> Nome, e-mail, telefone e data de nascimento.</li>
            <li><strong>Informações da Motocicleta:</strong> Marca, modelo, ano, placa e quilometragem para controle de manutenção e histórico da garagem.</li>
            <li><strong>Informações de Viagem:</strong> Presença confirmada em rotas, eventos e registros do planejamento financeiro de custos associados aos passeios.</li>
          </ul>

          <h2 className="text-2xl font-display text-copper pt-4">2. Como Usamos as Informações</h2>
          <p>
            Utilizamos seus dados para:
          </p>
          <ul className="list-disc pl-6 space-y-2">
            <li>Autenticar e manter a sua conta de membro segura.</li>
            <li>Gerenciar as atividades do motoclube (rotas, calendário, enquetes).</li>
            <li>Notificar sobre vencimentos de manutenção da sua moto, revisão e seguro.</li>
            <li>Facilitar a comunicação entre os membros e a organização de eventos.</li>
          </ul>

          <h2 className="text-2xl font-display text-copper pt-4">3. Compartilhamento de Dados</h2>
          <p>
            Nós não vendemos, alugamos ou comercializamos as suas informações pessoais. Seus dados são visíveis apenas
            dentro do ecossistema do motoclube, sendo acessíveis aos administradores para gestão interna e, em alguns
            casos (como aniversário ou presença em passeios), aos demais membros cadastrados.
          </p>

          <h2 className="text-2xl font-display text-copper pt-4">4. Segurança dos Dados</h2>
          <p>
            Seus dados são armazenados de forma segura através da plataforma Supabase, com criptografia em trânsito
            (HTTPS) e políticas de segurança rígidas que restringem o acesso indevido às suas informações.
          </p>

          <h2 className="text-2xl font-display text-copper pt-4">5. Seus Direitos</h2>
          <p>
            Você pode, a qualquer momento, acessar, editar ou solicitar a exclusão da sua conta e dos seus
            dados entrando em contato com os administradores do motoclube através do próprio aplicativo ou dos nossos canais oficiais.
          </p>

          <h2 className="text-2xl font-display text-copper pt-4">6. Alterações nesta Política</h2>
          <p>
            Esta política pode ser atualizada ocasionalmente. Notificaremos você sobre mudanças significativas no
            aplicativo ou através dos nossos canais de comunicação interna.
          </p>

          <p className="pt-8 text-sm opacity-80">
            Última atualização: {new Date().toLocaleDateString("pt-BR")}
          </p>
        </div>
      </main>
      <Footer />
    </div>
  );
}
