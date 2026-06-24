import React, { useEffect } from 'react';
import { Theme, StyledEngineProvider } from '@mui/material';
import { i18n } from 'i18next';
import styled from '@emotion/styled';
import { RecoilRoot, useRecoilValue } from 'recoil';
import ThemeSwitchProvider from './ThemeSwitchProvider';
import Header, { HEADER_HEIGHT } from './components/Header';
import BalanceCard from './components/BalanceCard';
import ActionButtons from './components/ActionButtons';
import TransactionList from './components/TransactionList';
import TransferModal from './components/TransferModal';
import SettingsModal from './components/SettingsModal';
import ToastContainer from './components/ToastContainer';
import { activeModalAtom, balanceAtom, themeAtom } from './atoms/banking';
import { useBanking } from './hooks/useBanking';
import { useNuiEvent } from './hooks/useNuiEvent';
import { themeVars } from './themes/tokens';
import './index.css';

const Container = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  max-height: 100%;
  position: relative;
  overflow: hidden;
  background-color: var(--bk-bg);
`;

const Content = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  padding: 0.875rem;
  max-height: calc(100% - ${HEADER_HEIGHT});
  overflow: hidden;
`;

const FreezeBanner = styled.div`
  background: linear-gradient(135deg, rgba(224,62,45,0.95), rgba(176,45,31,0.95));
  color: #FFF5E6;
  padding: 0.45rem 1rem;
  text-align: center;
  font-weight: 700;
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  border-bottom: 1px solid var(--bk-debit);
  flex-shrink: 0;
`;

interface AppProps {
  theme: Theme;
  i18n: i18n;
  settings: any;
}

function BankingApp() {
  const activeModal = useRecoilValue(activeModalAtom);
  const balance = useRecoilValue(balanceAtom);
  const theme = useRecoilValue(themeAtom);
  const { fetchBalance, fetchTransactions } = useBanking();
  const isFrozen = balance?.isFrozen ?? false;

  useEffect(() => {
    fetchBalance();
    fetchTransactions();
  }, []);

  useNuiEvent('BANKING_APP', 'incomingTransfer', (_data: { amount: number; from: string }) => {
    fetchBalance();
    fetchTransactions();
  });

  return (
    <Container style={themeVars[theme] as React.CSSProperties}>
      <Header />
      {isFrozen && <FreezeBanner>⚠ Account Frozen — Contact Support</FreezeBanner>}
      <ToastContainer />
      <Content>
        <BalanceCard />
        <ActionButtons disabled={isFrozen} />
        <TransactionList onRefresh={() => { fetchBalance(); fetchTransactions(); }} />
      </Content>
      {activeModal === 'transfer' && <TransferModal />}
      {activeModal === 'settings' && <SettingsModal />}
    </Container>
  );
}

export function App(props: AppProps) {
  return (
    <StyledEngineProvider injectFirst>
      <ThemeSwitchProvider mode={props.theme.palette.mode}>
        <BankingApp />
      </ThemeSwitchProvider>
    </StyledEngineProvider>
  );
}

export default function WithProviders(props: AppProps) {
  return (
    <RecoilRoot override key="bankingapp">
      <App {...props} />
    </RecoilRoot>
  );
}
