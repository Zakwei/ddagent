import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';

/// Status colours for the Control Center — colour encodes status only, never
/// brand (parity with src/components/quota/tone.ts).
enum QuotaTone { safe, watch, danger, neutral, info }

const quotaToneColors = <QuotaTone, Color>{
  QuotaTone.safe: Color(0xFF10B981), // emerald-500
  QuotaTone.watch: Color(0xFFF59E0B), // amber-500
  QuotaTone.danger: Color(0xFFEF4444), // red-500
  QuotaTone.neutral: Color(0xFF71717A), // zinc-500
  QuotaTone.info: Color(0xFF0EA5E9), // sky-500
};

Color quotaToneColor(QuotaTone tone) => quotaToneColors[tone]!;

QuotaTone toneForPercent(num percent, num watch, num danger) => percent >= danger
    ? QuotaTone.danger
    : percent >= watch
    ? QuotaTone.watch
    : QuotaTone.safe;

QuotaTone toneForQuality(String quality) => switch (quality) {
  'live' => QuotaTone.safe,
  'cached' => QuotaTone.info,
  'error' => QuotaTone.danger,
  _ => QuotaTone.neutral, // estimate | unknown
};

QuotaTone toneForAgentStatus(String status) => switch (status) {
  'running' => QuotaTone.info,
  'waiting' => QuotaTone.watch,
  'failed' => QuotaTone.danger,
  'finished' => QuotaTone.safe,
  _ => QuotaTone.neutral, // queued
};

// ─── Formatting (parity with quota/format.ts) ───────────────────────────────

String formatTokens(num value) {
  final abs = value.abs();
  if (abs >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
  if (abs >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
  if (abs >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
  return '${value.round()}';
}

String formatCost(num value) {
  if (value > 0 && value.abs() < 0.01) return '<\$0.01';
  return '\$${value.toStringAsFixed(2)}';
}

/// `42 min` | `1 h 42 min` | `3 d 12 h` (`—` for unknown/zero).
String formatDuration(num? seconds) {
  if (seconds == null || seconds <= 0) return '—';
  final minutes = (seconds / 60).round();
  if (minutes < 60) return t.quota.duration.minutes(minutes: minutes);
  final hours = minutes ~/ 60;
  if (hours < 24) return t.quota.duration.hoursMinutes(hours: hours, minutes: minutes % 60);
  return t.quota.duration.daysHours(days: hours ~/ 24, hours: hours % 24);
}

String formatRelativeTo(String? iso) {
  if (iso == null) return '—';
  final at = DateTime.tryParse(iso);
  if (at == null) return '—';
  final diff = at.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  if (diff <= 0) return '—';
  return formatDuration(diff / 1000);
}

/// `YYYY-MM-DD` → `MM-DD` axis label.
String formatDayLabel(String date) => date.length >= 10 ? date.substring(5) : date;

/// ISO timestamp → "3 h 12 min ago" style age.
String formatAgo(String? iso) {
  if (iso == null) return '—';
  final at = DateTime.tryParse(iso);
  if (at == null) return '—';
  final secs = (DateTime.now().millisecondsSinceEpoch - at.millisecondsSinceEpoch) / 1000;
  return secs <= 0 ? t.quota.duration.now : formatDuration(secs);
}

/// Absolute clock time — the old header renders `Updated 10:33:02`.
String formatClock(String? iso) {
  final at = DateTime.tryParse(iso ?? '')?.toLocal();
  if (at == null) return '—';
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(at.hour)}:${two(at.minute)}:${two(at.second)}';
}
