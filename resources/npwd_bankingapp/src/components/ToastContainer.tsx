import React from 'react';
import { useRecoilValue, useSetRecoilState } from 'recoil';
import { toastsAtom } from '../atoms/banking';
import { Collapse } from '@mui/material';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import ErrorIcon from '@mui/icons-material/Error';
import CloseIcon from '@mui/icons-material/Close';
import styled from '@emotion/styled';

const Container = styled.div`
  position: absolute;
  top: calc(3.5rem + 0.5rem);
  left: 0.625rem;
  right: 0.625rem;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  pointer-events: none;
`;

const ToastItem = styled.div<{ toastType: 'success' | 'error' }>`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.625rem 0.5rem 0.75rem;
  border-radius: 8px;
  font-size: 0.78rem;
  font-weight: 500;
  color: var(--bk-text);
  pointer-events: all;
  background: var(--bk-surface);
  border: 1px solid ${({ toastType }) =>
    toastType === 'success' ? 'var(--bk-crd-a30)' : 'var(--bk-dbt-a22)'};
  box-shadow: 0 4px 16px rgba(0,0,0,0.4);
`;

const IconWrap = styled.span<{ toastType: 'success' | 'error' }>`
  color: ${({ toastType }) => (toastType === 'success' ? 'var(--bk-credit)' : 'var(--bk-debit)')};
  display: flex;
  align-items: center;
  flex-shrink: 0;
`;

const Message = styled.span`
  flex: 1;
`;

const CloseBtn = styled.button`
  background: none;
  border: none;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  padding: 2px;
  border-radius: 4px;
  transition: all 0.15s;
  flex-shrink: 0;

  &:hover {
    color: var(--bk-text);
  }
`;

const ToastContainer: React.FC = () => {
  const toasts = useRecoilValue(toastsAtom);
  const setToasts = useSetRecoilState(toastsAtom);

  const dismiss = (id: number) => setToasts((prev) => prev.filter((t) => t.id !== id));

  if (toasts.length === 0) return null;

  return (
    <Container>
      {toasts.map((toast) => (
        <Collapse key={toast.id} in appear timeout={200}>
          <ToastItem toastType={toast.type}>
            <IconWrap toastType={toast.type}>
              {toast.type === 'success'
                ? <CheckCircleIcon style={{ fontSize: '1rem' }} />
                : <ErrorIcon style={{ fontSize: '1rem' }} />
              }
            </IconWrap>
            <Message>{toast.message}</Message>
            <CloseBtn onClick={() => dismiss(toast.id)}>
              <CloseIcon style={{ fontSize: '0.85rem' }} />
            </CloseBtn>
          </ToastItem>
        </Collapse>
      ))}
    </Container>
  );
};

export default ToastContainer;
