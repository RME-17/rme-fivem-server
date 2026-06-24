import React from 'react';
import { useRecoilState, useSetRecoilState } from 'recoil';
import { activeModalAtom, activeTabAtom } from '../atoms/banking';
import styled from '@emotion/styled';
import ReceiptLongIcon from '@mui/icons-material/ReceiptLong';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import SendIcon from '@mui/icons-material/Send';

interface ActionButtonsProps {
  disabled?: boolean;
}

const Row = styled.div`
  display: flex;
  gap: 0.4rem;
  margin-bottom: 0.75rem;
  flex-shrink: 0;
`;

const TabBtn = styled.button<{ active: boolean; isDisabled?: boolean }>`
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.28rem;
  padding: 0.52rem 0;
  border-radius: 8px;
  border: 1px solid ${({ active }) => (active ? 'var(--bk-primary)' : 'var(--bk-border)')};
  background: ${({ active }) => (active ? 'var(--bk-p-a12)' : 'transparent')};
  color: ${({ active, isDisabled }) => (isDisabled ? 'var(--bk-disabled)' : active ? 'var(--bk-primary)' : 'var(--bk-muted)')};
  cursor: ${({ isDisabled }) => (isDisabled ? 'not-allowed' : 'pointer')};
  font-weight: 600;
  font-size: 0.7rem;
  letter-spacing: 0.01em;
  transition: all 0.18s;

  &:hover {
    ${({ isDisabled, active }) =>
      !isDisabled && !active &&
      `border-color: var(--bk-primary); color: var(--bk-primary); background: var(--bk-p-a08);`
    }
  }
`;

const TransferBtn = styled.button<{ isDisabled?: boolean }>`
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.3rem;
  padding: 0.56rem 0;
  border-radius: 10px;
  border: 1px solid ${({ isDisabled }) => (isDisabled ? 'transparent' : 'var(--bk-p-a30)')};
  background: ${({ isDisabled }) => (isDisabled ? 'var(--bk-p-a10)' : 'var(--bk-grad)')};
  color: ${({ isDisabled }) => (isDisabled ? 'var(--bk-disabled)' : '#ffffff')};
  cursor: ${({ isDisabled }) => (isDisabled ? 'not-allowed' : 'pointer')};
  font-weight: 700;
  font-size: 0.7rem;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  box-shadow: ${({ isDisabled }) => isDisabled ? 'none' : '0 2px 8px var(--bk-p-a30)'};
  transition: all 0.18s ease;

  &:hover {
    ${({ isDisabled }) =>
      !isDisabled &&
      `background: var(--bk-grad-h); transform: translateY(-1px); box-shadow: 0 4px 14px var(--bk-p-a30);`
    }
  }

  &:active {
    ${({ isDisabled }) => !isDisabled && `transform: translateY(0); box-shadow: 0 1px 4px var(--bk-p-a30);`}
  }
`;

const ActionButtons: React.FC<ActionButtonsProps> = ({ disabled = false }) => {
  const [activeTab, setActiveTab] = useRecoilState(activeTabAtom);
  const setModal = useSetRecoilState(activeModalAtom);

  return (
    <Row>
      <TabBtn
        active={activeTab === 'transactions'}
        isDisabled={disabled}
        onClick={() => !disabled && setActiveTab('transactions')}
      >
        <ReceiptLongIcon style={{ fontSize: '0.9rem' }} />
        History
      </TabBtn>
      <TabBtn
        active={activeTab === 'atm'}
        isDisabled={disabled}
        onClick={() => !disabled && setActiveTab('atm')}
      >
        <LocationOnIcon style={{ fontSize: '0.9rem' }} />
        ATM Locator
      </TabBtn>
      <TransferBtn
        isDisabled={disabled}
        onClick={() => !disabled && setModal('transfer')}
      >
        <SendIcon style={{ fontSize: '0.85rem' }} />
        Transfer
      </TransferBtn>
    </Row>
  );
};

export default ActionButtons;
