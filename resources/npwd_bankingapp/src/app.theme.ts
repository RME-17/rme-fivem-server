import { ThemeOptions } from '@mui/material';
import { BankingThemeName } from './appConfig';

const bhrpTheme: ThemeOptions = {
  palette: {
    mode: 'dark',
    primary:    { main: '#F07B1F', light: '#F5A623', dark: '#C05A0F', contrastText: '#1C1208' },
    secondary:  { main: '#F5A623', light: '#f7b74a', dark: '#c17f10', contrastText: '#1C1208' },
    error:      { main: '#E03E2D', light: '#e96b5e', dark: '#b02d1f', contrastText: '#FFF5E6' },
    success:    { main: '#F5A623', light: '#f7b74a', dark: '#c17f10', contrastText: '#1C1208' },
    warning:    { main: '#F5A623', contrastText: '#1C1208' },
    background: { default: '#1C1208', paper: '#2A1A0A' },
    text:       { primary: '#FFF5E6', secondary: '#A87E52', disabled: '#4A3020' },
    divider:    '#3D2510',
    action: {
      active: '#F07B1F', hover: 'rgba(240,123,31,0.08)', selected: 'rgba(240,123,31,0.12)',
      disabled: '#4A3020', disabledBackground: 'rgba(240,123,31,0.06)',
    },
  },
  shape: { borderRadius: 12 },
  components: {
    MuiPaper:       { styleOverrides: { root: { backgroundImage: 'none' } } },
    MuiDialog:      { styleOverrides: { paper: { backgroundColor: '#2A1A0A', border: '1px solid #3D2510', boxShadow: '0 0 40px rgba(240,123,31,0.08), 0 8px 32px rgba(0,0,0,0.7)', borderRadius: '16px' } } },
    MuiDialogTitle: { styleOverrides: { root: { color: '#FFF5E6', borderBottom: '1px solid #3D2510', fontWeight: 700 } } },
    MuiDialogContent: { styleOverrides: { root: { paddingTop: '16px !important' } } },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': { backgroundColor: '#1C1208', borderRadius: '8px', '& fieldset': { borderColor: '#3D2510' }, '&:hover fieldset': { borderColor: '#F07B1F' }, '&.Mui-focused fieldset': { borderColor: '#F07B1F', borderWidth: '2px' } },
          '& .MuiInputLabel-root': { color: '#A87E52' },
          '& .MuiInputLabel-root.Mui-focused': { color: '#F07B1F' },
          '& .MuiInputBase-input': { color: '#FFF5E6' },
          '& .MuiFormHelperText-root': { color: '#A87E52' },
          '& .MuiFormHelperText-root.Mui-error': { color: '#E03E2D' },
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: { borderRadius: '8px', textTransform: 'none', fontWeight: 600, transition: 'all 0.2s' },
        containedPrimary: { background: 'linear-gradient(135deg, #F07B1F, #F5A623)', color: '#1C1208', '&:hover': { background: 'linear-gradient(135deg, #f28b35, #f7b74a)', transform: 'scale(1.02)', boxShadow: '0 2px 10px rgba(240,123,31,0.3)' }, '&.Mui-disabled': { background: 'rgba(240,123,31,0.12)', color: '#4A3020' } },
        text: { color: '#A87E52', '&:hover': { color: '#F5A623', backgroundColor: 'rgba(240,123,31,0.08)' } },
      },
    },
    MuiStepIcon:      { styleOverrides: { root: { color: '#3D2510', '&.Mui-active': { color: '#F07B1F' }, '&.Mui-completed': { color: '#F5A623' } } } },
    MuiStepLabel:     { styleOverrides: { label: { color: '#A87E52', '&.Mui-active': { color: '#F07B1F' }, '&.Mui-completed': { color: '#F5A623' } } } },
    MuiStepConnector: { styleOverrides: { line: { borderColor: '#3D2510' } } },
    MuiAlert: {
      styleOverrides: {
        root: { borderRadius: '8px' },
        filledSuccess: { backgroundColor: 'rgba(245,166,35,0.15)', border: '1px solid rgba(245,166,35,0.3)', color: '#FFF5E6' },
        filledError:   { backgroundColor: 'rgba(224,62,45,0.15)',  border: '1px solid rgba(224,62,45,0.3)',  color: '#FFF5E6' },
        standardError: { backgroundColor: 'rgba(224,62,45,0.1)',   border: '1px solid rgba(224,62,45,0.25)', color: '#FFF5E6' },
      },
    },
    MuiIconButton:    { styleOverrides: { root: { color: '#A87E52', transition: 'all 0.2s', '&:hover': { color: '#F5A623', backgroundColor: 'rgba(240,123,31,0.08)' } } } },
    MuiSkeleton:      { styleOverrides: { root: { backgroundColor: 'rgba(240,123,31,0.08)' } } },
    MuiBackdrop:      { styleOverrides: { root: { backgroundColor: 'rgba(0,0,0,0.8)' } } },
    MuiInputAdornment:{ styleOverrides: { root: { color: '#A87E52' } } },
  },
};

const defaultTheme: ThemeOptions = {
  palette: {
    mode: 'dark',
    primary:    { main: '#58A6FF', light: '#79C0FF', dark: '#1F6FEB', contrastText: '#0D1117' },
    secondary:  { main: '#79C0FF', light: '#a5d3ff', dark: '#1F6FEB', contrastText: '#0D1117' },
    error:      { main: '#F85149', light: '#ff7b75', dark: '#da3633', contrastText: '#E6EDF3' },
    success:    { main: '#3FB950', light: '#56d364', dark: '#238636', contrastText: '#0D1117' },
    warning:    { main: '#E3B341', contrastText: '#0D1117' },
    background: { default: '#0D1117', paper: '#161B22' },
    text:       { primary: '#E6EDF3', secondary: '#8B949E', disabled: '#30363D' },
    divider:    '#21262D',
    action: {
      active: '#58A6FF', hover: 'rgba(88,166,255,0.08)', selected: 'rgba(88,166,255,0.12)',
      disabled: '#30363D', disabledBackground: 'rgba(88,166,255,0.06)',
    },
  },
  shape: { borderRadius: 12 },
  components: {
    MuiPaper:       { styleOverrides: { root: { backgroundImage: 'none' } } },
    MuiDialog:      { styleOverrides: { paper: { backgroundColor: '#161B22', border: '1px solid #21262D', boxShadow: '0 0 40px rgba(88,166,255,0.06), 0 8px 32px rgba(0,0,0,0.6)', borderRadius: '16px' } } },
    MuiDialogTitle: { styleOverrides: { root: { color: '#E6EDF3', borderBottom: '1px solid #21262D', fontWeight: 700 } } },
    MuiDialogContent: { styleOverrides: { root: { paddingTop: '16px !important' } } },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': { backgroundColor: '#0D1117', borderRadius: '8px', '& fieldset': { borderColor: '#21262D' }, '&:hover fieldset': { borderColor: '#58A6FF' }, '&.Mui-focused fieldset': { borderColor: '#58A6FF', borderWidth: '2px' } },
          '& .MuiInputLabel-root': { color: '#8B949E' },
          '& .MuiInputLabel-root.Mui-focused': { color: '#58A6FF' },
          '& .MuiInputBase-input': { color: '#E6EDF3' },
          '& .MuiFormHelperText-root': { color: '#8B949E' },
          '& .MuiFormHelperText-root.Mui-error': { color: '#F85149' },
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: { borderRadius: '8px', textTransform: 'none', fontWeight: 600, transition: 'all 0.2s' },
        containedPrimary: { background: 'linear-gradient(135deg, #1F6FEB, #58A6FF)', color: '#0D1117', '&:hover': { background: 'linear-gradient(135deg, #388bfd, #79C0FF)', transform: 'scale(1.02)', boxShadow: '0 2px 10px rgba(88,166,255,0.3)' }, '&.Mui-disabled': { background: 'rgba(88,166,255,0.12)', color: '#30363D' } },
        text: { color: '#8B949E', '&:hover': { color: '#58A6FF', backgroundColor: 'rgba(88,166,255,0.08)' } },
      },
    },
    MuiStepIcon:      { styleOverrides: { root: { color: '#21262D', '&.Mui-active': { color: '#1F6FEB' }, '&.Mui-completed': { color: '#58A6FF' } } } },
    MuiStepLabel:     { styleOverrides: { label: { color: '#8B949E', '&.Mui-active': { color: '#1F6FEB' }, '&.Mui-completed': { color: '#58A6FF' } } } },
    MuiStepConnector: { styleOverrides: { line: { borderColor: '#21262D' } } },
    MuiAlert: {
      styleOverrides: {
        root: { borderRadius: '8px' },
        filledSuccess: { backgroundColor: 'rgba(63,185,80,0.15)',  border: '1px solid rgba(63,185,80,0.3)',  color: '#E6EDF3' },
        filledError:   { backgroundColor: 'rgba(248,81,73,0.15)',  border: '1px solid rgba(248,81,73,0.3)',  color: '#E6EDF3' },
        standardError: { backgroundColor: 'rgba(248,81,73,0.10)',  border: '1px solid rgba(248,81,73,0.25)', color: '#E6EDF3' },
      },
    },
    MuiIconButton:    { styleOverrides: { root: { color: '#8B949E', transition: 'all 0.2s', '&:hover': { color: '#58A6FF', backgroundColor: 'rgba(88,166,255,0.08)' } } } },
    MuiSkeleton:      { styleOverrides: { root: { backgroundColor: 'rgba(88,166,255,0.08)' } } },
    MuiBackdrop:      { styleOverrides: { root: { backgroundColor: 'rgba(0,0,0,0.8)' } } },
    MuiInputAdornment:{ styleOverrides: { root: { color: '#8B949E' } } },
  },
};

export const APP_PRIMARY_COLOR = '#F07B1F';
export const muiThemes: Record<BankingThemeName, ThemeOptions> = {
  bhrp: bhrpTheme,
  default: defaultTheme,
};
export const lightTheme = bhrpTheme;
export const darkTheme  = bhrpTheme;
export const themes: Record<'dark' | 'light', ThemeOptions> = {
  light: bhrpTheme,
  dark:  bhrpTheme,
};
