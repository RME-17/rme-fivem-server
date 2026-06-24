import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import topLevelAwait from 'vite-plugin-top-level-await';
import federation from '@originjs/vite-plugin-federation';
const packageJson = require('./package.json');
const { dependencies, name } = packageJson;

delete dependencies['@emotion/styled'];
delete dependencies['@mui/material'];
delete dependencies['@mui/styles'];

const patchRemoteEntry = {
  name: 'patch-remote-entry',
  generateBundle(_: unknown, bundle: Record<string, { type: string; code: string }>) {
    const remoteEntry = bundle['remoteEntry.js'];
    if (remoteEntry?.type === 'chunk') {
      // Replace preload-helper import (loaded as non-module by NPWD host)
      remoteEntry.code = remoteEntry.code.replace(
        /import\s*\{\s*_\s*as\s*(\w+)\s*\}\s*from\s*["'][^"']*preload-helper[^"']*["'];?\s*/,
        (_, varName) => `const ${varName} = (n) => n();\n`,
      );
      // Replace import.meta.url — syntax error when loaded as a non-module script
      remoteEntry.code = remoteEntry.code.replace(
        /import\.meta\.url/g,
        `(document.currentScript && document.currentScript.src || '')`,
      );
    }
  },
};

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    federation({
      name: 'mockapp',
      filename: 'remoteEntry.js',
      exposes: {
        './config': './npwd.config.ts',
      },
      shared: ['react', 'react-dom', '@emotion/react', 'react-router-dom', 'fivem-nui-react-lib'],
    }),
    topLevelAwait({
      promiseExportName: '__tla',
      promiseImportName: (i) => `__tla_${i}`,
    }),
    patchRemoteEntry,
  ],
  base: './',
  define: {
    process: {
      env: {
        VITE_REACT_APP_IN_GAME: process.env.VITE_REACT_APP_IN_GAME,
      },
    },
  },
  server: {
    port: 3002,
  },
  build: {
    outDir: 'web/dist',
    emptyOutDir: true,
    modulePreload: false,
    assetsDir: '',
  },
});
