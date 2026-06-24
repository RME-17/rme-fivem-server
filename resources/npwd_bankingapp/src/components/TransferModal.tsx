import React, { useState } from 'react';
import {
  Dialog, DialogTitle, DialogContent, DialogActions,
  Button, TextField, InputAdornment, CircularProgress,
  Typography, Box, Stepper, Step, StepLabel, Alert,
} from '@mui/material';
import SendIcon from '@mui/icons-material/Send';
import { useSetRecoilState } from 'recoil';
import { activeModalAtom } from '../atoms/banking';
import { useBanking } from '../hooks/useBanking';
import { formatCurrency } from '../utils/currency';

type TransferStep = 'phone' | 'amount' | 'confirm';
const STEP_LABELS = ['Recipient', 'Amount', 'Confirm'];
const STEP_INDEX: Record<TransferStep, number> = { phone: 0, amount: 1, confirm: 2 };

const CANCEL_SX = {
  borderColor: 'var(--bk-border)',
  color: 'var(--bk-muted)',
  '&:hover': { borderColor: 'var(--bk-alt)', color: 'var(--bk-alt)', bgcolor: 'var(--bk-p-a06)' },
};

const TransferModal: React.FC = () => {
  const setModal = useSetRecoilState(activeModalAtom);
  const { balance, transfer, lookupPhone, fetchTransactions } = useBanking();

  const [step, setStep] = useState<TransferStep>('phone');
  const [phone, setPhone] = useState('');
  const [amountStr, setAmountStr] = useState('');
  const [recipientName, setRecipientName] = useState('');
  const [lookingUp, setLookingUp] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');

  const parsedAmount = parseInt(amountStr, 10);
  const maxBank = balance?.bank ?? 0;
  const isAmountValid = !isNaN(parsedAmount) && parsedAmount > 0 && parsedAmount <= maxBank;
  const showAmountError = amountStr !== '' && !isNaN(parsedAmount) && parsedAmount > maxBank;

  const handleClose = () => { if (submitting || lookingUp) return; setModal(null); };

  const handlePhoneNext = () => { if (!phone.trim()) return; setError(''); setStep('amount'); };

  const handleAmountNext = async () => {
    if (!isAmountValid) return;
    setLookingUp(true); setError('');
    const result = await lookupPhone(phone.trim());
    setLookingUp(false);
    if (result.ok && result.name) { setRecipientName(result.name); setStep('confirm'); }
    else setError(result.error ?? 'Player not found');
  };

  const handleConfirmSubmit = async () => {
    setSubmitting(true);
    const ok = await transfer({ phoneNumber: phone.trim(), amount: parsedAmount });
    if (ok) await fetchTransactions();
    setSubmitting(false);
    if (ok) setModal(null);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key !== 'Enter') return;
    if (step === 'phone')   handlePhoneNext();
    if (step === 'amount')  handleAmountNext();
    if (step === 'confirm') handleConfirmSubmit();
  };

  return (
    <Dialog open onClose={handleClose} fullWidth maxWidth="xs">
      <DialogTitle sx={{ pb: 1 }}>Transfer Funds</DialogTitle>

      <DialogContent>
        <Stepper activeStep={STEP_INDEX[step]} sx={{ mb: 2.5, mt: 0.5 }} alternativeLabel>
          {STEP_LABELS.map((label) => (
            <Step key={label}><StepLabel>{label}</StepLabel></Step>
          ))}
        </Stepper>

        {step === 'phone' && (
          <TextField
            autoFocus label="Recipient Phone Number" fullWidth value={phone}
            onChange={(e) => { setPhone(e.target.value); setError(''); }}
            onKeyDown={handleKeyDown} margin="dense" inputMode="tel"
            placeholder="e.g. 555-1234" helperText="Enter the recipient's phone number"
          />
        )}

        {step === 'amount' && (
          <>
            <TextField
              autoFocus label="Amount" fullWidth value={amountStr}
              onChange={(e) => { setAmountStr(e.target.value.replace(/\D/g, '')); setError(''); }}
              onKeyDown={handleKeyDown} margin="dense" inputMode="numeric"
              error={showAmountError}
              helperText={
                showAmountError
                  ? `Maximum is ${formatCurrency(maxBank)}`
                  : balance !== null ? `Available bank: ${formatCurrency(maxBank)}` : ' '
              }
              InputProps={{ startAdornment: <InputAdornment position="start">$</InputAdornment> }}
            />
            {error && <Alert severity="error" sx={{ mt: 1, py: 0.25 }}>{error}</Alert>}
          </>
        )}

        {step === 'confirm' && (
          <Box py={0.5}>
            <Typography variant="body1" gutterBottom sx={{ color: 'var(--bk-text)' }}>
              Send{' '}
              <Box component="span" fontWeight={700} sx={{ color: 'var(--bk-primary)' }}>
                {formatCurrency(parsedAmount)}
              </Box>{' '}
              to{' '}
              <Box component="span" fontWeight={700} sx={{ color: 'var(--bk-text)' }}>
                {recipientName}
              </Box>?
            </Typography>
            <Typography variant="caption" sx={{ color: 'var(--bk-muted)' }}>
              This amount will be deducted from your bank balance. Transfers cannot be reversed.
            </Typography>
          </Box>
        )}
      </DialogContent>

      <DialogActions sx={{ px: 2.5, pb: 2, gap: 0.75 }}>
        {step === 'phone' && (
          <>
            <Button onClick={handleClose} variant="outlined" sx={CANCEL_SX}>Cancel</Button>
            <Button variant="contained" color="primary" onClick={handlePhoneNext} disabled={!phone.trim()}>Next</Button>
          </>
        )}
        {step === 'amount' && (
          <>
            <Button onClick={() => { setStep('phone'); setError(''); }} disabled={lookingUp} variant="outlined" sx={CANCEL_SX}>Back</Button>
            <Button variant="contained" color="primary" onClick={handleAmountNext} disabled={!isAmountValid || lookingUp}
              startIcon={lookingUp ? <CircularProgress size={16} color="inherit" /> : undefined}>
              {lookingUp ? 'Looking up…' : 'Next'}
            </Button>
          </>
        )}
        {step === 'confirm' && (
          <>
            <Button onClick={() => setStep('amount')} disabled={submitting} variant="outlined" sx={CANCEL_SX}>Back</Button>
            <Button variant="contained" color="primary" onClick={handleConfirmSubmit} disabled={submitting}
              startIcon={submitting ? <CircularProgress size={16} color="inherit" /> : <SendIcon />}>
              {submitting ? 'Sending…' : 'Send Money'}
            </Button>
          </>
        )}
      </DialogActions>
    </Dialog>
  );
};

export default TransferModal;
