export interface Balance {
  bank: number;
  cash: number;
  isFrozen?: boolean;
  citizenid?: string;
}

export interface Transaction {
  id: number;
  type: 'deposit' | 'withdrawal' | 'transfer_in' | 'transfer_out';
  amount: number;
  description: string;
  other_party: string | null;
  timestamp: string;
}

export interface AtmLocation {
  id: number;
  name: string;
  area: string;
  distance: number;
}

export interface TransferPayload {
  phoneNumber: string;
  amount: number;
}

export interface NuiResponse<T> {
  ok: boolean;
  data?: T;
  error?: string;
}
