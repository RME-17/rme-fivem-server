import App from './src/App';
import { AppIcon } from './icon';

interface Settings {
  language: 'en';
}

export const path = '/bankingapp';
export default (settings: Settings) => ({
  id: 'BANKING_APP',
  path,
  nameLocale: 'Banking App',
  color: '#E2F4ED',
  backgroundColor: '#0D3D2B',
  icon: AppIcon,
  app: App,
});
