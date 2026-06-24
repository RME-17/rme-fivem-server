import React, { useState } from 'react';
import { useRecoilValue, useSetRecoilState } from 'recoil';
import { balanceAtom, activeModalAtom, themeAtom } from '../atoms/banking';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import CheckIcon from '@mui/icons-material/Check';
import SettingsIcon from '@mui/icons-material/Settings';
import styled from '@emotion/styled';
import bhrpLogo from '../bhrplogo.png';

export const HEADER_HEIGHT = '3.5rem';

const Container = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: ${HEADER_HEIGHT};
  padding: 0 0.875rem 0 1rem;
  background-color: var(--bk-surface);
  border-bottom: 1px solid var(--bk-border);
  flex-shrink: 0;
`;

const BrandRow = styled.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
`;

const HexBadge = styled.div`
  width: 26px;
  height: 26px;
  background: var(--bk-grad);
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.68rem;
  font-weight: 800;
  color: var(--bk-bg);
  flex-shrink: 0;
`;

const AppTitle = styled.span`
  font-weight: 700;
  font-size: 0.88rem;
  color: var(--bk-text);
  letter-spacing: 0.01em;
`;

const AccountRow = styled.div`
  display: flex;
  align-items: center;
  gap: 0.3rem;
`;

const CitizenId = styled.span`
  font-size: 0.66rem;
  color: var(--bk-muted);
  font-family: monospace;
  letter-spacing: 0.04em;
`;

const CopyButton = styled.button`
  background: none;
  border: none;
  padding: 3px;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  border-radius: 4px;
  transition: all 0.2s;
  position: relative;

  &:hover {
    color: var(--bk-alt);
    background: var(--bk-p-a10);
  }
`;

const Tooltip = styled.span<{ visible: boolean }>`
  position: absolute;
  bottom: calc(100% + 4px);
  right: 0;
  background: var(--bk-alt);
  color: var(--bk-bg);
  font-size: 0.62rem;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 4px;
  white-space: nowrap;
  pointer-events: none;
  opacity: ${({ visible }) => (visible ? 1 : 0)};
  transition: opacity 0.15s;
`;

const Header: React.FC = () => {
  const balance = useRecoilValue(balanceAtom);
  const theme = useRecoilValue(themeAtom);
  const setModal = useSetRecoilState(activeModalAtom);
  const citizenId = balance?.citizenid;
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    if (!citizenId) return;
    navigator.clipboard.writeText(citizenId).catch(() => {});
    setCopied(true);
    setTimeout(() => setCopied(false), 1800);
  };

  return (
    <Container>
      <BrandRow>
        {theme === 'bhrp' ? (
          <img src={bhrpLogo} alt="BHRP" style={{ height: '32px', width: '32px', objectFit: 'contain' }} />
        ) : (
          <HexBadge>B</HexBadge>
        )}
        <AppTitle>{theme === 'bhrp' ? 'BeehiveRP Banking' : 'Banking'}</AppTitle>
      </BrandRow>

      <AccountRow>
        {citizenId && (
          <>
            <CitizenId>#{citizenId}</CitizenId>
            <CopyButton onClick={handleCopy} title="Copy account ID">
              {copied
                ? <CheckIcon sx={{ fontSize: '0.82rem', color: 'var(--bk-alt)' }} />
                : <ContentCopyIcon sx={{ fontSize: '0.82rem' }} />
              }
              <Tooltip visible={copied}>Copied!</Tooltip>
            </CopyButton>
          </>
        )}
        <CopyButton onClick={() => setModal('settings')} title="Settings">
          <SettingsIcon sx={{ fontSize: '0.9rem' }} />
        </CopyButton>
      </AccountRow>
    </Container>
  );
};

export default Header;
