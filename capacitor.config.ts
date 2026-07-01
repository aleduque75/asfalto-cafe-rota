import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'br.com.cafemotoasfalto.app',
  appName: 'Cafe Moto Asfalto',
  webDir: 'android_assets',
  server: {
    url: 'https://cafemotoasfalto.e-sal.app.br',
    cleartext: true
  }
};

export default config;
