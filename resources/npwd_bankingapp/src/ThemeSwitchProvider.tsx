import { createTheme, ThemeProvider } from '@mui/material';
import React from 'react';
import { ReactNode } from 'react';
import { muiThemes } from './app.theme';
import { BANKING_THEME } from './appConfig';

interface ThemeSwitchProviderProps {
  mode: 'light' | 'dark';
  children: ReactNode;
}

const ThemeSwitchProvider = ({ children }: ThemeSwitchProviderProps) => {
  const theme = createTheme(muiThemes[BANKING_THEME]);
  return <ThemeProvider theme={theme}>{children}</ThemeProvider>;
};

export default ThemeSwitchProvider;
