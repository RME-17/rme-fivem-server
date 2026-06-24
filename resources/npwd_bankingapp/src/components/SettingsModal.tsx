import React from 'react';
import { useRecoilState, useSetRecoilState } from 'recoil';
import { activeModalAtom, themeAtom, balanceHiddenAtom } from '../atoms/banking';
import styled from '@emotion/styled';
import CloseIcon from '@mui/icons-material/Close';
import PaletteIcon from '@mui/icons-material/Palette';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import VisibilityIcon from '@mui/icons-material/Visibility';

const Backdrop = styled.div`
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.55);
  z-index: 100;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
`;

const Sheet = styled.div`
  background: var(--bk-surface);
  border-top: 1px solid var(--bk-border);
  border-radius: 18px 18px 0 0;
  padding: 0 1rem 1.25rem;
  box-shadow: 0 -4px 24px rgba(0, 0, 0, 0.4);
`;

const Handle = styled.div`
  width: 36px;
  height: 4px;
  background: var(--bk-border);
  border-radius: 2px;
  margin: 0.65rem auto 1rem;
`;

const SheetHeader = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1.25rem;
`;

const SheetTitle = styled.span`
  font-weight: 700;
  font-size: 0.88rem;
  color: var(--bk-text);
  letter-spacing: 0.01em;
`;

const CloseBtn = styled.button`
  background: none;
  border: none;
  padding: 4px;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  border-radius: 6px;
  transition: all 0.15s;
  &:hover { color: var(--bk-text); background: var(--bk-p-a10); }
`;

const Section = styled.div`
  margin-bottom: 1.1rem;
`;

const SectionLabel = styled.div`
  font-size: 0.6rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--bk-muted);
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.35rem;
`;

const ThemeRow = styled.div`
  display: flex;
  gap: 0.5rem;
`;

const ThemeBtn = styled.button<{ active: boolean; accent: string }>`
  flex: 1;
  padding: 0.6rem 0.5rem;
  border-radius: 10px;
  border: 2px solid ${({ active, accent }) => (active ? accent : 'var(--bk-border)')};
  background: ${({ active, accent }) => (active ? `${accent}18` : 'transparent')};
  color: ${({ active, accent }) => (active ? accent : 'var(--bk-muted)')};
  cursor: pointer;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.02em;
  transition: all 0.18s;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.3rem;

  &:hover {
    border-color: ${({ accent }) => accent};
    color: ${({ accent }) => accent};
    background: ${({ accent }) => `${accent}10`};
  }
`;

const ThemeSwatch = styled.div<{ gradient: string }>`
  width: 28px;
  height: 10px;
  border-radius: 5px;
  background: ${({ gradient }) => gradient};
`;

const ToggleRow = styled.button`
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: var(--bk-bg);
  border: 1px solid var(--bk-border);
  border-radius: 10px;
  padding: 0.65rem 0.875rem;
  cursor: pointer;
  transition: border-color 0.18s;
  &:hover { border-color: var(--bk-primary); }
`;

const ToggleLabel = styled.span`
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--bk-text);
`;

const TogglePill = styled.div<{ on: boolean }>`
  width: 36px;
  height: 20px;
  border-radius: 10px;
  background: ${({ on }) => (on ? 'var(--bk-grad)' : 'var(--bk-border)')};
  position: relative;
  transition: background 0.2s;
  flex-shrink: 0;

  &::after {
    content: '';
    position: absolute;
    top: 3px;
    left: ${({ on }) => (on ? '19px' : '3px')};
    width: 14px;
    height: 14px;
    border-radius: 50%;
    background: #fff;
    transition: left 0.2s;
  }
`;

const SettingsModal: React.FC = () => {
  const setModal = useSetRecoilState(activeModalAtom);
  const [theme, setTheme] = useRecoilState(themeAtom);
  const [balanceHidden, setBalanceHidden] = useRecoilState(balanceHiddenAtom);

  return (
    <Backdrop onClick={() => setModal(null)}>
      <Sheet onClick={(e) => e.stopPropagation()}>
        <Handle />

        <SheetHeader>
          <SheetTitle>Settings</SheetTitle>
          <CloseBtn onClick={() => setModal(null)}>
            <CloseIcon sx={{ fontSize: '1rem' }} />
          </CloseBtn>
        </SheetHeader>

        <Section>
          <SectionLabel>
            <PaletteIcon sx={{ fontSize: '0.72rem' }} />
            Theme
          </SectionLabel>
          <ThemeRow>
            <ThemeBtn
              active={theme === 'bhrp'}
              accent="#F07B1F"
              onClick={() => setTheme('bhrp')}
            >
              <ThemeSwatch gradient="linear-gradient(135deg, #F07B1F, #F5A623)" />
              BHRP
            </ThemeBtn>
            <ThemeBtn
              active={theme === 'default'}
              accent="#1F6FEB"
              onClick={() => setTheme('default')}
            >
              <ThemeSwatch gradient="linear-gradient(135deg, #0A2463, #1F6FEB)" />
              Navy Blue
            </ThemeBtn>
          </ThemeRow>
        </Section>

        <Section>
          <SectionLabel>
            {balanceHidden
              ? <VisibilityOffIcon sx={{ fontSize: '0.72rem' }} />
              : <VisibilityIcon sx={{ fontSize: '0.72rem' }} />
            }
            Privacy
          </SectionLabel>
          <ToggleRow onClick={() => setBalanceHidden((v) => !v)}>
            <ToggleLabel>Hide Balance</ToggleLabel>
            <TogglePill on={balanceHidden} />
          </ToggleRow>
        </Section>
      </Sheet>
    </Backdrop>
  );
};

export default SettingsModal;
