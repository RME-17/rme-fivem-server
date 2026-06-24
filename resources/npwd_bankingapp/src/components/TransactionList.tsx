import React, { useEffect } from 'react';
import { useRecoilValue, useRecoilState } from 'recoil';
import {
  transactionsAtom,
  transactionsLoadingAtom,
  activeTabAtom,
  atmLocationsAtom,
  atmLoadingAtom,
} from '../atoms/banking';
import { Skeleton } from '@mui/material';
import RefreshIcon from '@mui/icons-material/Refresh';
import RoomIcon from '@mui/icons-material/Room';
import TransactionItem from './TransactionItem';
import styled from '@emotion/styled';
import { formatCurrency } from '../utils/currency';
import { useBanking } from '../hooks/useBanking';

interface Props {
  onRefresh: () => void;
}

const Wrapper = styled.div`
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
`;

const SectionHeader = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.4rem;
  flex-shrink: 0;
`;

const SectionTitle = styled.span`
  font-size: 0.65rem;
  font-weight: 700;
  letter-spacing: 0.07em;
  text-transform: uppercase;
  color: var(--bk-muted);
`;

const RefreshBtn = styled.button<{ spinning?: boolean }>`
  background: none;
  border: none;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  padding: 3px;
  border-radius: 6px;
  transition: all 0.2s;

  & svg {
    transition: transform 0.4s;
    ${({ spinning }) => spinning && `transform: rotate(180deg);`}
  }

  &:hover {
    color: var(--bk-alt);
    background: var(--bk-p-a08);
  }
`;

const ScrollArea = styled.div`
  flex: 1;
  overflow-y: auto;
  min-height: 0;
`;

const EmptyState = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem 1rem;
  gap: 0.625rem;
`;

const EmptyHex = styled.div`
  width: 36px;
  height: 36px;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  background: var(--bk-p-a10);
`;

const EmptyText = styled.p`
  color: var(--bk-muted);
  font-size: 0.78rem;
  margin: 0;
  text-align: center;
`;

const SpendingSummary = styled.div`
  display: flex;
  gap: 0.5rem;
  padding-top: 0.5rem;
  margin-top: 0.375rem;
  border-top: 1px solid var(--bk-border);
  flex-shrink: 0;
`;

const StatCard = styled.div`
  flex: 1;
  background: var(--bk-surface);
  border: 1px solid var(--bk-border);
  border-radius: 10px;
  padding: 0.45rem 0.625rem;
`;

const StatLabel = styled.div`
  font-size: 0.58rem;
  font-weight: 700;
  letter-spacing: 0.07em;
  text-transform: uppercase;
  color: var(--bk-muted);
  margin-bottom: 0.1rem;
`;

const StatValue = styled.div<{ credit?: boolean }>`
  font-size: 0.85rem;
  font-weight: 700;
  color: ${({ credit }) => (credit ? 'var(--bk-credit)' : 'var(--bk-debit)')};
`;

const AtmCard = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.625rem 0.25rem;
  border-bottom: 1px solid var(--bk-border);

  &:last-of-type {
    border-bottom: none;
  }
`;

const AtmLeft = styled.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
`;

const AtmIcon = styled.div`
  width: 28px;
  height: 28px;
  border-radius: 8px;
  background: var(--bk-p-a10);
  border: 1px solid var(--bk-p-a14);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  color: var(--bk-primary);
`;

const AtmName = styled.div`
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--bk-text);
`;

const AtmArea = styled.div`
  font-size: 0.66rem;
  color: var(--bk-muted);
  margin-top: 0.1rem;
`;

const AtmDistance = styled.div<{ near: boolean }>`
  font-size: 0.72rem;
  font-weight: 700;
  color: ${({ near }) => (near ? 'var(--bk-credit)' : 'var(--bk-muted)')};
  background: ${({ near }) => (near ? 'var(--bk-crd-a10)' : 'var(--bk-p-a08)')};
  border: 1px solid ${({ near }) => (near ? 'var(--bk-crd-a22)' : 'var(--bk-border)')};
  padding: 2px 8px;
  border-radius: 999px;
  flex-shrink: 0;
`;

const SkeletonRow: React.FC = () => (
  <div style={{ padding: '0.55rem 0', borderBottom: '1px solid var(--bk-border)' }}>
    <Skeleton variant="rounded" width={66} height={15} sx={{ mb: 0.5 }} />
    <Skeleton variant="text" width={140} height={14} />
    <Skeleton variant="text" width={80} height={12} />
  </div>
);

const TransactionList: React.FC<Props> = ({ onRefresh }) => {
  const transactions = useRecoilValue(transactionsAtom);
  const loading      = useRecoilValue(transactionsLoadingAtom);
  const atmLocations = useRecoilValue(atmLocationsAtom);
  const atmLoading   = useRecoilValue(atmLoadingAtom);
  const [activeTab]  = useRecoilState(activeTabAtom);
  const { fetchAtmLocations } = useBanking();

  useEffect(() => {
    if (activeTab === 'atm' && atmLocations.length === 0) {
      fetchAtmLocations();
    }
  }, [activeTab]);

  const totalReceived = transactions
    .filter((tx) => tx.type === 'deposit' || tx.type === 'transfer_in')
    .reduce((sum, tx) => sum + tx.amount, 0);

  const totalSpent = transactions
    .filter((tx) => tx.type === 'withdrawal' || tx.type === 'transfer_out')
    .reduce((sum, tx) => sum + tx.amount, 0);

  return (
    <Wrapper>
      {activeTab === 'transactions' ? (
        <>
          <SectionHeader>
            <SectionTitle>Recent Transactions</SectionTitle>
            <RefreshBtn spinning={loading} onClick={loading ? undefined : onRefresh} title="Refresh">
              <RefreshIcon style={{ fontSize: '1rem' }} />
            </RefreshBtn>
          </SectionHeader>

          <ScrollArea>
            {loading ? (
              Array.from({ length: 4 }).map((_, i) => <SkeletonRow key={i} />)
            ) : transactions.length === 0 ? (
              <EmptyState>
                <EmptyHex />
                <EmptyText>No transactions yet</EmptyText>
              </EmptyState>
            ) : (
              transactions.map((tx) => <TransactionItem key={tx.id} tx={tx} />)
            )}
          </ScrollArea>

          {!loading && transactions.length > 0 && (
            <SpendingSummary>
              <StatCard>
                <StatLabel>Received</StatLabel>
                <StatValue credit>+{formatCurrency(totalReceived)}</StatValue>
              </StatCard>
              <StatCard>
                <StatLabel>Spent</StatLabel>
                <StatValue>−{formatCurrency(totalSpent)}</StatValue>
              </StatCard>
            </SpendingSummary>
          )}
        </>
      ) : (
        <>
          <SectionHeader>
            <SectionTitle>Nearest ATMs</SectionTitle>
            <RefreshBtn onClick={atmLoading ? undefined : fetchAtmLocations} title="Refresh distances">
              <RefreshIcon style={{ fontSize: '1rem' }} />
            </RefreshBtn>
          </SectionHeader>

          <ScrollArea>
            {atmLoading ? (
              Array.from({ length: 5 }).map((_, i) => (
                <div key={i} style={{ padding: '0.625rem 0', borderBottom: '1px solid var(--bk-border)', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                  <Skeleton variant="rounded" width={28} height={28} sx={{ borderRadius: '8px', flexShrink: 0 }} />
                  <div style={{ flex: 1 }}>
                    <Skeleton variant="text" width={120} height={16} />
                    <Skeleton variant="text" width={80} height={13} />
                  </div>
                  <Skeleton variant="rounded" width={55} height={22} sx={{ borderRadius: '999px' }} />
                </div>
              ))
            ) : atmLocations.length === 0 ? (
              <EmptyState>
                <EmptyHex />
                <EmptyText>No ATMs found</EmptyText>
              </EmptyState>
            ) : (
              atmLocations.map((atm) => (
                <AtmCard key={atm.id}>
                  <AtmLeft>
                    <AtmIcon>
                      <RoomIcon style={{ fontSize: '0.9rem' }} />
                    </AtmIcon>
                    <div>
                      <AtmName>{atm.name}</AtmName>
                      <AtmArea>{atm.area}</AtmArea>
                    </div>
                  </AtmLeft>
                  <AtmDistance near={atm.distance <= 100}>
                    {atm.distance}m
                  </AtmDistance>
                </AtmCard>
              ))
            )}
          </ScrollArea>
        </>
      )}
    </Wrapper>
  );
};

export default TransactionList;
