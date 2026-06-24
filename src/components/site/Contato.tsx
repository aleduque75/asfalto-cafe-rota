import { useState } from "react";
import { Instagram, Mail, MapPin, MessageCircle, Send } from "lucide-react";
import { toast } from "sonner";

export function Contato() {
  const [sending, setSending] = useState(false);

  const onSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setSending(true);
    setTimeout(() => {
      setSending(false);
      toast.success("Mensagem enviada! A turma vai responder em breve. 🤝");
      (e.target as HTMLFormElement).reset();
    }, 700);
  };

  const inputCls =
    "w-full rounded-md border border-border bg-[color:var(--input)] px-4 py-3 text-sm text-cream placeholder:text-cream/40 outline-none focus:border-copper focus:ring-2 focus:ring-copper/30 transition";
  const labelCls =
    "block text-[11px] uppercase tracking-[0.22em] text-cream/70 mb-2";

  return (
    <section id="contato" className="relative py-24 md:py-32 border-t border-border/60" style={{ background: "var(--gradient-leather)" }}>
      <div className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-5 gap-10 lg:gap-16 items-start">
          <div className="lg:col-span-2">
            <p className="eyebrow mb-3">Fale conosco</p>
            <h2 className="section-title text-4xl md:text-5xl mb-6">
              Bora pegar essa estrada juntos?
            </h2>
            <p className="text-cream/75 mb-10 leading-relaxed">
              Quer entrar pro rolê, sugerir um destino ou só trocar uma ideia sobre a próxima
              parada de café? A turma do Café Moto e Asfalto responde — sempre.
            </p>

            <ul className="space-y-5">
              <li className="flex items-start gap-4">
                <div className="h-10 w-10 shrink-0 rounded-full bg-copper/15 text-copper inline-flex items-center justify-center">
                  <MapPin className="h-4 w-4" />
                </div>
                <div>
                  <p className="text-[10px] uppercase tracking-[0.28em] text-copper" style={{ fontFamily: "var(--font-display)" }}>Base</p>
                  <p className="text-cream">Atibaia — São Paulo — Brasil</p>
                </div>
              </li>
              <li className="flex items-start gap-4">
                <div className="h-10 w-10 shrink-0 rounded-full bg-copper/15 text-copper inline-flex items-center justify-center">
                  <Instagram className="h-4 w-4" />
                </div>
                <div>
                  <p className="text-[10px] uppercase tracking-[0.28em] text-copper" style={{ fontFamily: "var(--font-display)" }}>Instagram</p>
                  <a
                    href="https://www.instagram.com/cafe_moto_asfalto"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-cream hover:text-copper transition"
                  >
                    @cafe_moto_asfalto
                  </a>
                </div>
              </li>
              <li className="flex items-start gap-4">
                <div className="h-10 w-10 shrink-0 rounded-full bg-copper/15 text-copper inline-flex items-center justify-center">
                  <MessageCircle className="h-4 w-4" />
                </div>
                <div>
                  <p className="text-[10px] uppercase tracking-[0.28em] text-copper" style={{ fontFamily: "var(--font-display)" }}>WhatsApp</p>
                  <p className="text-cream">Solicite o contato pela mensagem ao lado</p>
                </div>
              </li>
              <li className="flex items-start gap-4">
                <div className="h-10 w-10 shrink-0 rounded-full bg-copper/15 text-copper inline-flex items-center justify-center">
                  <Mail className="h-4 w-4" />
                </div>
                <div>
                  <p className="text-[10px] uppercase tracking-[0.28em] text-copper" style={{ fontFamily: "var(--font-display)" }}>E-mail</p>
                  <p className="text-cream">contato@cafemotoasfalto.com.br</p>
                </div>
              </li>
            </ul>
          </div>

          <form onSubmit={onSubmit} className="lg:col-span-3 card-leather rounded-lg p-6 md:p-8 space-y-5">
            <div className="grid sm:grid-cols-2 gap-5">
              <div>
                <label className={labelCls} htmlFor="nome">Nome</label>
                <input id="nome" name="nome" required className={inputCls} placeholder="Seu nome completo" />
              </div>
              <div>
                <label className={labelCls} htmlFor="email">E-mail</label>
                <input id="email" name="email" type="email" required className={inputCls} placeholder="voce@email.com" />
              </div>
              <div>
                <label className={labelCls} htmlFor="whatsapp">WhatsApp</label>
                <input id="whatsapp" name="whatsapp" required className={inputCls} placeholder="(11) 99999-9999" />
              </div>
              <div>
                <label className={labelCls} htmlFor="cidade">Cidade / Estado</label>
                <input id="cidade" name="cidade" required className={inputCls} placeholder="Atibaia / SP" />
              </div>
              <div className="sm:col-span-2">
                <label className={labelCls} htmlFor="instagram">Instagram</label>
                <input id="instagram" name="instagram" className={inputCls} placeholder="@seuusuario" />
              </div>
              <div className="sm:col-span-2">
                <label className={labelCls} htmlFor="mensagem">Mensagem</label>
                <textarea
                  id="mensagem"
                  name="mensagem"
                  required
                  rows={5}
                  className={inputCls + " resize-y min-h-[120px]"}
                  placeholder="Conta pra gente — quer entrar no clube, sugerir um destino, ou só dar um alô?"
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={sending}
              className="btn-copper inline-flex items-center justify-center gap-2 rounded-md px-7 py-3.5 text-sm uppercase tracking-[0.2em] font-semibold w-full sm:w-auto disabled:opacity-70"
              style={{ fontFamily: "var(--font-display)" }}
            >
              <Send className="h-4 w-4" />
              {sending ? "Enviando..." : "Enviar mensagem"}
            </button>
          </form>
        </div>
      </div>
    </section>
  );
}