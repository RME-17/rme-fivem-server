import React from 'react';
import { Transaction } from '../types';
import styled from '@emotion/styled';
import { formatCurrency } from '../utils/currency';

const TYPE_META: Record<Transaction['type'], { label: string; incoming: boolean }> = {
  deposit:      { label: 'Deposit',      incoming: true  },
  withdrawal:   { label: 'Withdrawal',   incoming: false },
  transfer_in:  { label: 'Transfer In',  incoming: true  },
  transfer_out: { label: 'Transfer Out', incoming: false },
};

const formatDate = (ts: string): string => {
  const d = new Date(ts);
  return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
};

const Row = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.575rem 0;
  border-bottom: 1px solid var(--bk-border);

  &:last-of-type {
    border-bottom: none;
  }
`;

const Left = styled.div`
  display: flex;
  flex-direction: column;
  gap: 0.18rem;
  min-width: 0;
`;

const Badge = styled.span<{ incoming: boolean }>`
  display: inline-block;
  align-self: flex-start;
  font-size: 0.58rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  padding: 2px 7px;
  border-radius: 999px;
  background: ${({ incoming }) => (incoming ? 'var(--bk-crd-a13)' : 'var(--bk-dbt-a13)')};
  color:      ${({ incoming }) => (incoming ? 'var(--bk-credit)' : 'var(--bk-debit)')};
  border: 1px solid ${({ incoming }) => (incoming ? 'var(--bk-crd-a22)' : 'var(--bk-dbt-a22)')};
`;

const Description = styled.span`
  font-size: 0.73rem;
  color: var(--bk-muted);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 175px;
  display: block;
`;

const Timestamp = styled.span`
  font-size: 0.6rem;
  color: var(--bk-dim);
`;

const Amount = styled.span<{ incoming: boolean }>`
  font-size: 0.86rem;
  font-weight: 700;
  white-space: nowrap;
  margin-left: 0.5rem;
  flex-shrink: 0;
  color: ${({ incoming }) => (incoming ? 'var(--bk-credit)' : 'var(--bk-debit)')};
`;

interface Props {
  tx: Transaction;
}

const TransactionItem: React.FC<Props> = ({ tx }) => {
  const { label, incoming } = TYPE_META[tx.type];

  return (
    <Row>
      <Left>
        <Badge incoming={incoming}>{label}</Badge>
        <Description>{tx.description}</Description>
        <Timestamp>{formatDate(tx.timestamp)}</Timestamp>
      </Left>
      <Amount incoming={incoming}>
        {incoming ? '+' : '−'}{formatCurrency(tx.amount)}
      </Amount>
    </Row>
  );
};

export default TransactionItem;
