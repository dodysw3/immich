#!/usr/bin/env node

import { copyFile, mkdir } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const rootDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const sourceDir = path.join(rootDir, 'node_modules', 'pdfjs-dist', 'wasm');
const targetDir = path.join(rootDir, 'static', 'pdfjs', 'wasm');

const files = ['jbig2.wasm', 'openjpeg.wasm', 'openjpeg_nowasm_fallback.js', 'qcms_bg.wasm'];

await mkdir(targetDir, { recursive: true });

await Promise.all(
  files.map(async (fileName) => {
    const source = path.join(sourceDir, fileName);
    const target = path.join(targetDir, fileName);
    await copyFile(source, target);
  }),
);
