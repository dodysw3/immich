import { describe, expect, it } from 'vitest';
import { ocrTokenBag, ocrTokenBagDiff } from 'src/utils/duplicate-ocr.js';

describe('ocrTokenBag', () => {
  it('lowercases and de-duplicates tokens', () => {
    expect(ocrTokenBag('Transfer Berhasil Transfer Rp 50.000')).toEqual(
      new Set(['transfer', 'berhasil', 'rp', '50.000']),
    );
  });

  it('collapses repeated punctuation runs', () => {
    expect(ocrTokenBag('…………9365')).toEqual(new Set(['…9365']));
    expect(ocrTokenBag('………………9365')).toEqual(new Set(['…9365']));
    expect(ocrTokenBag('mandiri -- livin"')).toEqual(new Set(['mandiri', '-', 'livin"']));
  });

  it('returns an empty bag for empty or whitespace text', () => {
    expect(ocrTokenBag('')).toEqual(new Set());
    expect(ocrTokenBag('   \n\t  ')).toEqual(new Set());
  });
});

describe('ocrTokenBagDiff', () => {
  it('is order-insensitive', () => {
    expect(ocrTokenBagDiff('alpha beta gamma', 'gamma alpha beta')).toBe(0);
  });

  it('returns 0 for identical bags', () => {
    const text = 'Keterangan Transaksi Bank Mandiri Rekening Sumber Rp 350.000';
    expect(ocrTokenBagDiff(text, text)).toBe(0);
    expect(ocrTokenBagDiff(text, `${text} ${text}`)).toBe(0);
  });

  it('counts tokens present on only one side', () => {
    expect(ocrTokenBagDiff('a b c', 'a b d e')).toBe(3);
  });

  it('measured true-duplicate jitter stays small (dot-leader miscounts, stray bullet)', () => {
    // Real OCR pair from two re-copies of the same receipt screenshot.
    const a =
      'Keterangan Transaksi Bank Mandiri - …………9365 INA WIDYA LAKSMIASIH Rekening Sumber Total Transaksi Rp 350.000';
    const b =
      '· Keterangan Transaksi Bank Mandiri - ……………9365 INA WIDYA LAKSMIASIH Rekening Sumber Total Transaksi Rp 350.000';
    expect(ocrTokenBagDiff(a, b)).toBeLessThanOrEqual(3);
  });

  it('measured template-variant pair exceeds the veto threshold (different transactions)', () => {
    // Two Mandiri receipts of the same template, dates/ref numbers differ.
    const a =
      'Pindah Dana per 21 Nov Keterangan Transaksi Bank Mandiri 4908 SRI AFIFAH Rekening Sumber Rp 50.002.500 Total Transaksi Biaya Transaksi Rp 2.500 2301211122464090057 21 Nov 2022 12:03:15 WIB';
    const b =
      'Kas Operasional per 27 Des Keterangan Transaksi Bank Mandiri 4908 SRI AFIFAH Rekening Sumber Rp 50.002.500 Total Transaksi Biaya Transaksi Rp 2.500 2212271121489702350 27 Des 2022 11:18:37 WIB';
    expect(ocrTokenBagDiff(a, b)).toBeGreaterThanOrEqual(10);
  });
});
