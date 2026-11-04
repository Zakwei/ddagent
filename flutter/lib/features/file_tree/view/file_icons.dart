import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Extension → icon subset of fileIcons.ts (the 200+ Lucide map collapses to
/// ~25 Material equivalents + a generic fallback).
({IconData icon, Color color}) fileIcon(String name) {
  final dot = name.lastIndexOf('.');
  final ext = dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
  const amber = Colors.amber;
  const blue = Colors.blue;
  const green = Colors.green;
  const orange = Colors.deepOrange;
  const grey = Colors.blueGrey;
  return switch (ext) {
    'dart' => (icon: LucideIcons.code, color: blue),
    'js' || 'jsx' || 'mjs' || 'cjs' => (icon: LucideIcons.fileCode, color: amber),
    'ts' || 'tsx' || 'mts' => (icon: LucideIcons.code, color: blue),
    'py' || 'pyw' || 'ipynb' => (icon: LucideIcons.code, color: green),
    'rs' || 'go' || 'c' || 'cpp' || 'h' => (icon: LucideIcons.settings2, color: orange),
    'rb' || 'java' || 'kt' || 'swift' || 'php' => (icon: LucideIcons.code, color: orange),
    'json' || 'yaml' || 'yml' || 'toml' || 'xml' => (icon: LucideIcons.braces, color: grey),
    'md' || 'txt' || 'rtf' => (icon: LucideIcons.fileText, color: grey),
    'html' || 'css' || 'scss' => (icon: LucideIcons.globe, color: blue),
    'sh' || 'bash' || 'zsh' || 'ps1' => (icon: LucideIcons.squareTerminal, color: green),
    'png' ||
    'jpg' ||
    'jpeg' ||
    'gif' ||
    'svg' ||
    'webp' ||
    'ico' ||
    'bmp' => (icon: LucideIcons.image, color: Colors.purple),
    'zip' || 'tar' || 'gz' || '7z' || 'rar' => (icon: LucideIcons.archive, color: amber),
    'pdf' => (icon: LucideIcons.fileText, color: Colors.red),
    'mp3' || 'wav' || 'ogg' || 'flac' => (icon: LucideIcons.music, color: Colors.pink),
    'mp4' || 'mov' || 'mkv' || 'webm' => (icon: LucideIcons.video, color: Colors.red),
    'sql' || 'db' || 'sqlite' => (icon: LucideIcons.database, color: blue),
    'env' || 'lock' || 'pem' || 'key' => (icon: LucideIcons.lock, color: grey),
    _ => (icon: LucideIcons.file, color: grey),
  };
}
