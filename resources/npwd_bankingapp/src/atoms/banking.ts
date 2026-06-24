import { atom } from 'recoil';
import { AtmLocation, Balance, Transaction } from '../types';
import { BankingThemeName } from '../appConfig';

export interface Toast {
  id: number;
  message: string;
  type: 'success' | 'error';
}

export type ModalType = 'transfer' | 'settings' | null;
export type ActiveTab = 'transactions' | 'atm';

const localStorageEffect = (key: string, fallback: any) =>
  ({ setSelf, onSet }: any) => {
    try {
      const saved = localStorage.getItem(key);
      if (saved != null) setSelf(JSON.parse(saved));
    } catch {}
    onSet((val: any, _: any, isReset: boolean) => {
      isReset ? localStorage.removeItem(key) : localStorage.setItem(key, JSON.stringify(val));
    });
  };

export const themeAtom = atom<BankingThemeName>({
  key: 'bankingapp_theme',
  default: 'bhrp',
  effects: [localStorageEffect('bankingapp_theme', 'bhrp')],
});

export const balanceHiddenAtom = atom<boolean>({
  key: 'bankingapp_balanceHidden',
  default: false,
  effects: [localStorageEffect('bankingapp_balanceHidden', false)],
});

export const balanceAtom = atom<Balance | null>({
  key: 'bankingapp_balance',
  default: null,
});

export const balanceLoadingAtom = atom<boolean>({
  key: 'bankingapp_balanceLoading',
  default: false,
});

export const transactionsAtom = atom<Transaction[]>({
  key: 'bankingapp_transactions',
  default: [],
});

export const transactionsLoadingAtom = atom<boolean>({
  key: 'bankingapp_transactionsLoading',
  default: false,
});

export const atmLocationsAtom = atom<AtmLocation[]>({
  key: 'bankingapp_atmLocations',
  default: [],
});

export const atmLoadingAtom = atom<boolean>({
  key: 'bankingapp_atmLoading',
  default: false,
});

export const toastsAtom = atom<Toast[]>({
  key: 'bankingapp_toasts',
  default: [],
});

export const activeModalAtom = atom<ModalType>({
  key: 'bankingapp_activeModal',
  default: null,
});

export const activeTabAtom = atom<ActiveTab>({
  key: 'bankingapp_activeTab',
  default: 'transactions',
});
