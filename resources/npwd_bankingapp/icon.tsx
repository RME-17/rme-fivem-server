import React from 'react';

export const AppIcon = () => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="24"
    height="24"
    fill="none"
    viewBox="0 0 24 24"
    stroke="currentColor"
    strokeWidth={2}
  >
    {/* Pillars */}
    <line x1="6"  y1="10" x2="6"  y2="17" strokeLinecap="round" />
    <line x1="10" y1="10" x2="10" y2="17" strokeLinecap="round" />
    <line x1="14" y1="10" x2="14" y2="17" strokeLinecap="round" />
    <line x1="18" y1="10" x2="18" y2="17" strokeLinecap="round" />
    {/* Base */}
    <line x1="4" y1="17" x2="20" y2="17" strokeLinecap="round" />
    {/* Plinth */}
    <line x1="3" y1="20" x2="21" y2="20" strokeLinecap="round" strokeWidth={2.5} />
    {/* Roof */}
    <polyline points="2,10 12,3 22,10" strokeLinecap="round" strokeLinejoin="round" />
    <line x1="4" y1="10" x2="20" y2="10" strokeLinecap="round" />
  </svg>
);
