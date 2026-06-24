import React from 'react';
import { useRecoilValue } from 'recoil';
import { balanceAtom, balanceLoadingAtom, balanceHiddenAtom } from '../atoms/banking';
import { Skeleton } from '@mui/material';
import styled from '@emotion/styled';
import { formatCurrency } from '../utils/currency';

const Card = styled.div`
  position: relative;
  padding: 1.125rem 1.25rem 1rem;
  background: var(--bk-surface);
  border-radius: 16px;
  margin-bottom: 0.75rem;
  flex-shrink: 0;
  overflow: hidden;
  box-shadow:
    0 0 0 1px var(--bk-border),
    0 0 28px var(--bk-p-a10),
    0 2px 8px rgba(0,0,0,0.5);
  border-bottom: 2px solid var(--bk-alt);
`;

const HexWatermark = styled.div`
  position: absolute;
  right: -20px;
  bottom: -22px;
  width: 120px;
  height: 120px;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  background: var(--bk-p-a06);
  pointer-events: none;
`;

const HexWatermarkSm = styled.div`
  position: absolute;
  right: 72px;
  bottom: 16px;
  width: 44px;
  height: 44px;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  background: var(--bk-p-a06);
  pointer-events: none;
`;

const Label = styled.div`
  font-size: 0.6rem;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--bk-muted);
  margin-bottom: 0.15rem;
`;

const GradientAmount = styled.div`
  background: var(--bk-grad-text);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 800;
  font-size: 2rem;
  line-height: 1.15;
  letter-spacing: -0.01em;
`;

const Divider = styled.div`
  height: 1px;
  background: linear-gradient(90deg, transparent, var(--bk-border) 30%, var(--bk-border) 70%, transparent);
  margin: 0.75rem 0;
`;

const CashRow = styled.div`
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
`;

const CashLabel = styled.span`
  font-size: 0.6rem;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--bk-muted);
`;

const CashAmount = styled.span`
  font-size: 1rem;
  font-weight: 600;
  color: var(--bk-muted);
`;

const HIDDEN = '•••••';

const BalanceCard: React.FC = () => {
  const balance = useRecoilValue(balanceAtom);
  const loading = useRecoilValue(balanceLoadingAtom);
  const hidden = useRecoilValue(balanceHiddenAtom);
  const ready = !loading && balance !== null;

  return (
    <Card>
      <HexWatermark />
      <HexWatermarkSm />

      <Label>Bank Balance</Label>
      {ready ? (
        <GradientAmount>{hidden ? HIDDEN : formatCurrency(balance!.bank)}</GradientAmount>
      ) : (
        <Skeleton variant="text" width={150} height={46} />
      )}

      <Divider />

      <CashRow>
        <CashLabel>Cash on Hand</CashLabel>
        {ready ? (
          <CashAmount>{hidden ? HIDDEN : formatCurrency(balance!.cash)}</CashAmount>
        ) : (
          <Skeleton variant="text" width={80} height={22} />
        )}
      </CashRow>
    </Card>
  );
};

export default BalanceCard;
