import { useRecoilState, useSetRecoilState } from 'recoil';
import {
  atmLoadingAtom,
  atmLocationsAtom,
  balanceAtom,
  balanceLoadingAtom,
  toastsAtom,
  transactionsAtom,
  transactionsLoadingAtom,
} from '../atoms/banking';
import fetchNui from '../utils/fetchNui';
import { AtmLocation, Balance, NuiResponse, Transaction, TransferPayload } from '../types';
import { formatCurrency } from '../utils/currency';

let _toastId = 0;

export function useBanking() {
  const [balance, setBalance] = useRecoilState(balanceAtom);
  const setBalanceLoading     = useSetRecoilState(balanceLoadingAtom);
  const setTransactions       = useSetRecoilState(transactionsAtom);
  const setTransactionsLoading= useSetRecoilState(transactionsLoadingAtom);
  const setAtmLocations       = useSetRecoilState(atmLocationsAtom);
  const setAtmLoading         = useSetRecoilState(atmLoadingAtom);
  const setToasts             = useSetRecoilState(toastsAtom);

  const showToast = (message: string, type: 'success' | 'error') => {
    const id = ++_toastId;
    setToasts((prev) => [...prev, { id, message, type }]);
    setTimeout(() => setToasts((prev) => prev.filter((t) => t.id !== id)), 3500);
  };

  const dismissToast = (id: number) => setToasts((prev) => prev.filter((t) => t.id !== id));

  const fetchBalance = async () => {
    setBalanceLoading(true);
    try {
      const resp = await fetchNui<NuiResponse<Balance>>('getBalance', {});
      if (resp.ok && resp.data) setBalance(resp.data);
      else showToast(resp.error ?? 'Failed to load balance', 'error');
    } catch { showToast('Failed to load balance', 'error'); }
    finally { setBalanceLoading(false); }
  };

  const fetchTransactions = async () => {
    setTransactionsLoading(true);
    try {
      const resp = await fetchNui<NuiResponse<Transaction[]>>('getTransactions', {});
      if (resp.ok && resp.data) setTransactions(resp.data);
      else showToast(resp.error ?? 'Failed to load transactions', 'error');
    } catch { showToast('Failed to load transactions', 'error'); }
    finally { setTransactionsLoading(false); }
  };

  const fetchAtmLocations = async () => {
    setAtmLoading(true);
    try {
      const resp = await fetchNui<NuiResponse<AtmLocation[]>>('getAtmLocations', {});
      if (resp.ok && resp.data) setAtmLocations(resp.data);
      else showToast(resp.error ?? 'Failed to fetch ATM locations', 'error');
    } catch { showToast('Failed to fetch ATM locations', 'error'); }
    finally { setAtmLoading(false); }
  };

  const transfer = async (payload: TransferPayload): Promise<boolean> => {
    try {
      const resp = await fetchNui<NuiResponse<Balance>>('transfer', payload);
      if (resp.ok && resp.data) {
        setBalance(resp.data);
        showToast(`Transferred ${formatCurrency(payload.amount)}`, 'success');
        return true;
      }
      showToast(resp.error ?? 'Transfer failed', 'error');
      return false;
    } catch { showToast('Transfer failed', 'error'); return false; }
  };

  const lookupPhone = async (phoneNumber: string): Promise<{ ok: boolean; name?: string; error?: string }> => {
    try {
      const resp = await fetchNui<NuiResponse<{ name: string }>>('getPlayerByPhone', { phoneNumber });
      if (resp.ok && resp.data) return { ok: true, name: resp.data.name };
      return { ok: false, error: resp.error ?? 'Player not found' };
    } catch { return { ok: false, error: 'Lookup failed' }; }
  };

  return { balance, fetchBalance, fetchTransactions, fetchAtmLocations, transfer, lookupPhone, showToast, dismissToast };
}
