#!/usr/bin/env node
// Requires Node.js 18+ (fetch, AbortSignal.timeout)
// ============================================================================
// statusline-powerline.js — statusline.js の Powerline テーマ版（自己完結）
//   データ処理ロジックは statusline.js と同一。描画のみ Powerline 化:
//     - 各セグメントに 256色の背景色を付与
//     - セグメント境界を塗りつぶし矢印  () で接続
//   ※ Powerline グリフ表示には Nerd Font / Powerline パッチ済みフォントが必要
//   切替: settings.json の statusLine.command を
//         node "${HOME}/.claude/statusline-powerline.js" に差し替え
//   キャッシュファイルは statusline.js と共有（同一データなので二重スキャン回避）
// ============================================================================
'use strict';

const fs = require('fs');
const path = require('path');

// ============================================================================
// 定数
// ============================================================================

const C = {
  reset: '\x1b[0m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  magenta: '\x1b[35m',
  gray: '\x1b[90m',
};

const CONTEXT_BAR_WIDTH = 10;
const LIMIT_BAR_WIDTH = 10;

// モデル別料金（USD/MTok）
// Source: https://platform.claude.com/docs/en/about-claude/pricing
const PRICING = {
  'claude-opus-4-6':          { input: 5,  output: 25, cache_read: 0.50, cache_write_5m: 6.25, cache_write_1h: 10 },
  'claude-sonnet-4-6':        { input: 3,  output: 15, cache_read: 0.30, cache_write_5m: 3.75, cache_write_1h: 6 },
  'claude-haiku-4-5-20251001': { input: 1,  output: 5,  cache_read: 0.10, cache_write_5m: 1.25, cache_write_1h: 2 },
};

const FALLBACK_PRICING = PRICING['claude-sonnet-4-6'];

const MONTH_NAMES = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

const HOME = process.env.HOME || process.env.USERPROFILE;
const CLAUDE_DIR = path.join(HOME, '.claude');
const PROJECTS_DIR = path.join(CLAUDE_DIR, 'projects');
const COST_CACHE_FILE = path.join(CLAUDE_DIR, '.statusline-cost-cache.json');
const USAGE_CACHE_FILE = path.join(CLAUDE_DIR, '.statusline-usage-cache.json');
const CREDENTIALS_FILE = path.join(CLAUDE_DIR, '.credentials.json');

const CACHE_TTL_MS = 300000;      // 5 minutes
const USAGE_CACHE_TTL_MS = 60000; // 60 seconds
const USAGE_COOLDOWN_MS = 300000; // 5 minutes — backoff after 429/error

// ── Powerline 描画ヘルパ（256色 +  矢印） ──
const ARROW = '';                       // 塗りつぶし右向き矢印
function fg(n) { return `\x1b[38;5;${n}m`; }  // 前景 256色
function bg(n) { return `\x1b[48;5;${n}m`; }  // 背景 256色

// セグメント別テーマ（fg/bg は 256色番号）
const T = {
  model:   { fg: 231, bg: 30  },  // 白 / ダークシアン
  context: { fg: 252, bg: 236 },  // ライトグレー / ダークグレー
  project: { fg: 231, bg: 90  },  // 白 / マゼンタ
  branch:  { fg: 235, bg: 178 },  // 黒寄り / ゴールド
  time:    { fg: 250, bg: 238 },  // グレー / 暗グレー

  zap:     { fg: 235, bg: 136 },  // 黒寄り / 暗ゴールド（⚡）
  fiveH:   { fg: 252, bg: 236 },
  sevenD:  { fg: 252, bg: 238 },

  money:   { fg: 253, bg: 65  },  // 白 / 深緑（💰・ミュート）
  day:     { fg: 252, bg: 236 },
  week:    { fg: 252, bg: 238 },
  month:   { fg: 252, bg: 240 },
};

// vim モード別テーマ（NORMAL/INSERT/VISUAL 等。mode 文字列で背景色を切替）
function modeTheme(mode) {
  switch (mode) {
    case 'INSERT':      return { fg: 231, bg: 34  };  // 緑
    case 'VISUAL':
    case 'VISUAL LINE': return { fg: 231, bg: 172 };  // オレンジ
    case 'REPLACE':     return { fg: 231, bg: 160 };  // 赤
    case 'NORMAL':
    default:            return { fg: 231, bg: 31  };  // 青
  }
}

// バーの塗り色（256色）
const BAR_FILL_CONTEXT = 71;  // 緑（ミュート）
const BAR_FILL_LIMIT = 73;    // シアン（ミュート）
const BAR_FILL_WARN = 214;    // オレンジ（>=90%）
const BAR_FILL_CRIT = 196;    // 赤（>=100%）
const BAR_EMPTY = 240;        // 空セルのドット

const EMPTY_INPUT = {
  model: 'unknown', vimMode: '', usedPct: 0, totalTokens: 0, contextSize: 0,
  projectDir: '', sessionCost: 0, apiDurationMs: 0,
};

// ============================================================================
// ユーティリティ
// ============================================================================

function formatTokens(tokens) {
  const n = Number(tokens) || 0;
  if (n >= 1000) {
    return Math.floor(n / 1000) + 'K';
  }
  return String(n);
}

function formatDuration(ms) {
  const totalSec = Math.floor(Number(ms) / 1000);
  const min = Math.floor(totalSec / 60);
  const sec = totalSec % 60;
  if (min > 0) {
    return `${min}m${String(sec).padStart(2, '0')}s`;
  }
  return `${sec}s`;
}

// Powerline セグメント内に置くバー（fg だけ変更し、reset/bg は出さない）
function plBar(pct, width, fillColor) {
  const p = Math.max(0, Math.min(100, Math.round(pct)));
  let filled = Math.round((p * width) / 100);
  if (p > 0 && filled === 0) filled = 1;
  if (filled > width) filled = width;
  const empty = width - filled;

  let fc = fillColor;
  if (p >= 100) fc = BAR_FILL_CRIT;
  else if (p >= 90) fc = BAR_FILL_WARN;

  return fg(fc) + '█'.repeat(filled) + fg(BAR_EMPTY) + '░'.repeat(empty);
}

// セグメント配列を Powerline 文字列に描画
// segments: [{ fg, bg, text }] — text 内では fg() の変更のみ可（reset/bg は禁止）
function renderPL(segments) {
  let out = '';
  for (let i = 0; i < segments.length; i++) {
    const s = segments[i];
    out += bg(s.bg) + fg(s.fg) + ' ' + s.text + ' ';
    const next = segments[i + 1];
    if (next) {
      out += bg(next.bg) + fg(s.bg) + ARROW;       // 背景色を切り替える境界矢印
    } else {
      out += C.reset + fg(s.bg) + ARROW + C.reset; // 末尾の矢印（端末既定背景へ）
    }
  }
  return out;
}

function getGitInfo(projectDir) {
  const dir = projectDir || '';
  const project = path.basename(dir);

  let branch = '';
  try {
    const head = fs.readFileSync(path.join(dir, '.git', 'HEAD'), 'utf8').trim();
    const match = head.match(/^ref: refs\/heads\/(.+)$/);
    branch = match ? match[1] : head.slice(0, 7);
  } catch (_) {
    // .git/HEAD が読めない = git リポジトリでない
  }

  return { project, branch };
}

function formatResetTime(resetsAt) {
  if (!resetsAt) return '';
  try {
    const resetDate = new Date(resetsAt);
    if (isNaN(resetDate.getTime())) return '';
    const now = Date.now();
    const diffMs = resetDate.getTime() - now;
    if (diffMs <= 0) return '';

    const diffMin = Math.floor(diffMs / 60000);
    let remaining;
    if (diffMin >= 60) {
      const h = Math.floor(diffMin / 60);
      const m = diffMin % 60;
      remaining = `⏳${h}h${m}m`;
    } else {
      remaining = `⏳${diffMin}m`;
    }

    const localHH = String(resetDate.getHours()).padStart(2, '0');
    const localMM = String(resetDate.getMinutes()).padStart(2, '0');
    return `${remaining} (${localHH}:${localMM})`;
  } catch (_) {
    return '';
  }
}

function formatCost(usd) {
  return '$' + usd.toFixed(2);
}

function readJsonFile(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (_) {
    return null;
  }
}

function writeJsonFile(filePath, data) {
  try {
    fs.writeFileSync(filePath, JSON.stringify(data), 'utf8');
  } catch (_) {}
}

// ============================================================================
// stdin JSON解析
// ============================================================================

function readStdin() {
  try {
    return fs.readFileSync(0, 'utf8');
  } catch (_) {
    return '';
  }
}

function parseInput(raw) {
  try {
    const j = JSON.parse(raw);
    const cw = j.context_window || {};
    const co = j.cost || {};
    const usedPct = Math.floor(Number(cw.used_percentage) || 0);
    const contextSize = Number(cw.context_window_size) || 0;
    return {
      model: (j.model && (j.model.display_name || j.model.id)) || 'unknown',
      vimMode: (j.vim && j.vim.mode) || '',
      usedPct,
      totalTokens: Math.round(usedPct / 100 * contextSize),
      contextSize,
      projectDir: (j.workspace && j.workspace.project_dir) || '',
      sessionCost: co.total_cost_usd || 0,
      apiDurationMs: co.total_api_duration_ms || 0,
    };
  } catch (_) {
    return EMPTY_INPUT;
  }
}

// ============================================================================
// コスト計算（scanAllFiles, calcLineCost + 5分キャッシュ）
// ============================================================================

function formatDateStr(date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

function getTodayStr(now) {
  return formatDateStr(now || new Date());
}

function getMonthStr(now) {
  return formatDateStr(now || new Date()).slice(0, 7);
}

function getWeekStartStr(now) {
  const d = now || new Date();
  const day = d.getDay();
  const diff = (day === 0) ? -6 : 1 - day;
  const monday = new Date(d);
  monday.setDate(monday.getDate() + diff);
  return formatDateStr(monday);
}

function getShortMonthName(now) {
  return MONTH_NAMES[(now || new Date()).getMonth()];
}

function readCache() {
  return readJsonFile(COST_CACHE_FILE);
}

function writeCache(costData) {
  const now = new Date();
  writeJsonFile(COST_CACHE_FILE, {
    updated_at: now.toISOString(),
    today: { date: getTodayStr(now), cost_usd: costData.todayCost },
    weekly: { week_start: getWeekStartStr(now), cost_usd: costData.weeklyCost },
    monthly: { month: getMonthStr(now), cost_usd: costData.monthlyCost },
  });
}

function isCacheValid(cache) {
  if (!isCostCacheReliable(cache)) return false;
  if (!cache.updated_at) return false;
  if (cache.today.cost_usd == null || cache.weekly.cost_usd == null || cache.monthly.cost_usd == null) return false;
  const updatedAt = new Date(cache.updated_at).getTime();
  if (isNaN(updatedAt)) return false;
  if (Date.now() - updatedAt > CACHE_TTL_MS) return false;
  return true;
}

function findJsonlFiles(dir, results) {
  if (!results) results = [];
  try {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        findJsonlFiles(fullPath, results);
      } else if (entry.isFile() && entry.name.endsWith('.jsonl')) {
        results.push(fullPath);
      }
    }
  } catch (_) {
    // 読み取れないディレクトリは無視
  }
  return results;
}

function calcLineCost(entry) {
  // costUSD フィールドがあればそのまま使う（ccusage の autoモードと同様）
  if (entry.costUSD != null) {
    return Number(entry.costUSD) || 0;
  }

  // フォールバック: トークン×単価で計算
  const model = (entry.message && entry.message.model) || '';
  const usage = (entry.message && entry.message.usage) || {};

  const pricing = PRICING[model] || FALLBACK_PRICING;

  const inputTokens = usage.input_tokens || 0;
  const outputTokens = usage.output_tokens || 0;
  const cacheReadTokens = usage.cache_read_input_tokens || 0;

  // タイプ別キャッシュ作成トークンがあれば優先
  const cacheCreation = usage.cache_creation;
  let cacheWrite1hTokens = 0;
  let cacheWrite5mTokens = 0;

  if (cacheCreation &&
      (cacheCreation.ephemeral_1h_input_tokens !== undefined ||
       cacheCreation.ephemeral_5m_input_tokens !== undefined)) {
    cacheWrite1hTokens = cacheCreation.ephemeral_1h_input_tokens || 0;
    cacheWrite5mTokens = cacheCreation.ephemeral_5m_input_tokens || 0;
  } else {
    // cache_creation_input_tokens にフォールバック、5m単価で計算（ccusage 準拠）
    cacheWrite1hTokens = 0;
    cacheWrite5mTokens = usage.cache_creation_input_tokens || 0;
  }

  const cost =
    (inputTokens * pricing.input / 1_000_000) +
    (outputTokens * pricing.output / 1_000_000) +
    (cacheReadTokens * pricing.cache_read / 1_000_000) +
    (cacheWrite1hTokens * pricing.cache_write_1h / 1_000_000) +
    (cacheWrite5mTokens * pricing.cache_write_5m / 1_000_000);

  return cost;
}

function scanAllFiles() {
  const files = findJsonlFiles(PROJECTS_DIR).sort();
  const now = new Date();
  const todayStr = getTodayStr(now);
  const monthStr = getMonthStr(now);
  const weekStartStr = getWeekStartStr(now);

  // 週の範囲: 月曜日〜日曜日の日付セットを生成
  const weekDates = new Set();
  const [wy, wm, wd] = weekStartStr.split('-').map(Number);
  const weekStart = new Date(wy, wm - 1, wd);
  for (let i = 0; i < 7; i++) {
    const d = new Date(weekStart);
    d.setDate(weekStart.getDate() + i);
    weekDates.add(formatDateStr(d));
  }

  // mtime フィルタ: 今月1日より前に最終更新されたファイルはスキップ
  const monthStartMs = new Date(now.getFullYear(), now.getMonth(), 1).getTime();
  // 週が月をまたぐ場合は週の開始日も考慮
  const cutoffMs = Math.min(monthStartMs, weekStart.getTime());

  // message.id + requestId の組み合わせで重複排除
  // 初出を採用（ccusage 準拠）— 後続の同一キーはスキップ
  const seen = new Map(); // key -> { cost, localDate, inMonth, inWeek }

  for (const file of files) {
    // mtime が cutoff より古いファイルは丸ごとスキップ
    try {
      if (fs.statSync(file).mtimeMs < cutoffMs) continue;
    } catch (_) {
      continue;
    }

    let raw;
    try {
      raw = fs.readFileSync(file, 'utf8');
    } catch (_) {
      continue;
    }

    const lines = raw.split('\n');
    for (const line of lines) {
      // プリフィルタ: assistant 行以外はパースをスキップ
      if (!line.includes('"assistant"')) continue;
      let entry;
      try {
        entry = JSON.parse(line);
      } catch (_) {
        continue;
      }

      if (!entry || entry.type !== 'assistant') continue;
      if (!entry.timestamp) continue;

      const msgId = entry.message && entry.message.id;
      const reqId = entry.requestId;

      // 重複排除キー: 両方揃った場合のみ生成（ccusage 準拠）
      // 片方でも欠けたら重複排除しない（常にカウント）
      const key = (msgId && reqId) ? `${msgId}:${reqId}` : null;

      const date = new Date(entry.timestamp);
      if (isNaN(date.getTime())) continue;

      const localDate = formatDateStr(date);
      const localMonth = localDate.slice(0, 7);

      // 今月 または 今週に含まれるエントリを対象とする
      const inMonth = localMonth === monthStr;
      const inWeek = weekDates.has(localDate);
      if (!inMonth && !inWeek) continue;

      const record = { cost: calcLineCost(entry), localDate, inMonth, inWeek };

      if (key === null) {
        // キーなし → 重複排除せず常に追加
        seen.set(Symbol(), record);
      } else if (!seen.has(key)) {
        // 初出: 採用（ccusage 準拠）
        seen.set(key, record);
      }
      // 既出: スキップ（ccusage 準拠 — 初出を維持）
    }
  }

  let todayCost = 0;
  let weeklyCost = 0;
  let monthlyCost = 0;

  for (const { cost, localDate, inMonth, inWeek } of seen.values()) {
    if (inMonth) monthlyCost += cost;
    if (inWeek) weeklyCost += cost;
    if (localDate === todayStr) todayCost += cost;
  }

  return { todayCost, weeklyCost, monthlyCost };
}

// ============================================================================
// Usage API（fetchUsageLimits + 60秒キャッシュ + resets_at保存）
// ============================================================================

function readOAuthToken() {
  const creds = readJsonFile(CREDENTIALS_FILE);
  return (creds && creds.claudeAiOauth && creds.claudeAiOauth.accessToken) || null;
}

function readUsageCacheRaw() {
  return readJsonFile(USAGE_CACHE_FILE);
}

function isUsageCacheFresh(cache) {
  if (!cache || !cache.updated_at) return false;
  return Date.now() - new Date(cache.updated_at).getTime() <= USAGE_CACHE_TTL_MS;
}

function isUsageCacheReliable(cache) {
  if (!cache || !cache.updated_at) return false;
  // resets_at を過ぎていたら信頼できない
  if (cache.five_hour_resets_at) {
    const resetsAt = new Date(cache.five_hour_resets_at).getTime();
    if (!isNaN(resetsAt) && Date.now() > resetsAt) return false;
  }
  // コストキャッシュTTLと統一（5分）
  const age = Date.now() - new Date(cache.updated_at).getTime();
  if (age > CACHE_TTL_MS) return false;
  return true;
}

function isCostCacheReliable(cache) {
  if (!cache || !cache.today || !cache.weekly || !cache.monthly) return false;
  const now = new Date();
  if (cache.today.date !== getTodayStr(now)) return false;
  if (cache.weekly.week_start !== getWeekStartStr(now)) return false;
  if (cache.monthly.month !== getMonthStr(now)) return false;
  return true;
}

function isUsageInCooldown(cache) {
  if (!cache || !cache.cooldown_until) return false;
  return Date.now() < cache.cooldown_until;
}

function writeUsageCache(usage, cooldownUntil) {
  const data = {
    updated_at: new Date().toISOString(),
    five_hour: usage.five_hour,
    seven_day: usage.seven_day,
  };
  if (usage.five_hour_resets_at != null) {
    data.five_hour_resets_at = usage.five_hour_resets_at;
  }
  if (cooldownUntil) {
    data.cooldown_until = cooldownUntil;
  }
  writeJsonFile(USAGE_CACHE_FILE, data);
}

function enterCooldown(cache) {
  const fallback = cache || { five_hour: null, seven_day: null };
  writeUsageCache(fallback, Date.now() + USAGE_COOLDOWN_MS);
  return fallback;
}

async function fetchUsageLimits(cache) {
  const token = readOAuthToken();
  if (!token) return cache; // no token → stale fallback

  try {
    const res = await fetch('https://api.anthropic.com/api/oauth/usage', {
      headers: {
        'Authorization': 'Bearer ' + token,
        'anthropic-beta': 'oauth-2025-04-20',
        'Content-Type': 'application/json',
      },
      signal: AbortSignal.timeout(3000),
    });
    if (!res.ok) return enterCooldown(cache);
    const data = await res.json();
    const usage = {
      five_hour: (data.five_hour && data.five_hour.utilization != null) ? data.five_hour.utilization : null,
      seven_day: (data.seven_day && data.seven_day.utilization != null) ? data.seven_day.utilization : null,
      five_hour_resets_at: (data.five_hour && data.five_hour.resets_at) || null,
    };
    writeUsageCache(usage);
    return usage;
  } catch (_) {
    return enterCooldown(cache);
  }
}

// ============================================================================
// 表示構築（Powerline）
// ============================================================================

function buildLine1(input) {
  const segs = [];

  // vim モード（有効時のみ・先頭セグメント。モード色で背景を切替）
  if (input.vimMode) {
    segs.push({ ...modeTheme(input.vimMode), text: input.vimMode });
  }

  // モデル名
  segs.push({ ...T.model, text: input.model });

  // コンテキストバー（バーの後はセグメント文字色へ戻す）
  const pct = input.usedPct;
  const usedFormatted = formatTokens(input.totalTokens);
  const maxFormatted = formatTokens(input.contextSize);
  const ctxText = plBar(pct, CONTEXT_BAR_WIDTH, BAR_FILL_CONTEXT)
    + fg(T.context.fg) + ` ${usedFormatted}/${maxFormatted} (${pct}%)`;
  segs.push({ ...T.context, text: ctxText });

  // Git情報
  const { project, branch } = getGitInfo(input.projectDir);
  if (project) {
    segs.push({ ...T.project, text: project });
    if (branch) {
      segs.push({ ...T.branch, text: branch });
    }
  }

  // 稼働時間
  segs.push({ ...T.time, text: '⏱ ' + formatDuration(input.apiDurationMs) });

  return renderPL(segs);
}

function buildLimitSegmentPL(label, pct, theme, extra) {
  let t = `${label} ` + plBar(pct, LIMIT_BAR_WIDTH, BAR_FILL_LIMIT)
    + fg(theme.fg) + ` ${String(pct).padStart(3)}%`;
  if (extra) t += ' ' + extra;
  return { ...theme, text: t };
}

function buildLine2(usage, stale) {
  if (!usage || (usage.five_hour == null && usage.seven_day == null)) return '';

  const segs = [{ ...T.zap, text: '⚡' }];

  if (usage.five_hour != null) {
    const resetStr = formatResetTime(usage.five_hour_resets_at);
    segs.push(buildLimitSegmentPL('5h', Math.round(usage.five_hour), T.fiveH, resetStr));
  }

  if (usage.seven_day != null) {
    segs.push(buildLimitSegmentPL('7d', Math.round(usage.seven_day), T.sevenD, ''));
  }

  let line = renderPL(segs);
  if (stale) line += ' ' + C.gray + '~' + C.reset;
  return line;
}

function buildLine3(sessionCost, costData) {
  const sessTxt = (sessionCost != null && !isNaN(sessionCost))
    ? `💰 ${formatCost(sessionCost)}`
    : '💰';

  const segs = [
    { ...T.money, text: sessTxt },
    { ...T.day,   text: `1d ${formatCost(costData.todayCost)}` },
    { ...T.week,  text: `1w ${formatCost(costData.weeklyCost)}` },
    { ...T.month, text: `${getShortMonthName()} ${formatCost(costData.monthlyCost)}` },
  ];
  return renderPL(segs);
}

// ============================================================================
// main
// ============================================================================

async function main() {
  try {
    const raw = readStdin();
    const input = parseInput(raw);
    // ── 1. キャッシュを同期で読み出し ──
    const usageCache = readUsageCacheRaw();
    const costCache = readCache();

    // ── 2. キャッシュの信頼性を判定 ──
    const needsUsageRefresh = !isUsageCacheReliable(usageCache) && !isUsageInCooldown(usageCache);
    const needsCostRefresh = !isCostCacheReliable(costCache);

    let usageData = usageCache;
    let usageRefreshed = false;
    let costData = null;

    // ── 3. 信頼できないキャッシュは表示前に同期で更新 ──
    if (needsUsageRefresh || needsCostRefresh) {
      const jobs = [];
      if (needsUsageRefresh) {
        jobs.push(fetchUsageLimits(usageCache).then(r => { usageData = r; usageRefreshed = true; }));
      }
      if (needsCostRefresh) {
        jobs.push((async () => {
          const data = scanAllFiles();
          writeCache(data);
          costData = data;
        })());
      }
      await Promise.all(jobs).catch(() => {});
    }

    // API失敗時（cooldown入り→古いキャッシュがそのまま返る）は stale 扱い
    const isUsageStale = needsUsageRefresh && !usageRefreshed;

    // costData が更新されなかった場合はキャッシュから読み出し
    if (!costData) {
      const cached = (costCache && costCache.today && costCache.weekly && costCache.monthly)
        ? { todayCost: costCache.today.cost_usd, weeklyCost: costCache.weekly.cost_usd, monthlyCost: costCache.monthly.cost_usd }
        : null;
      costData = cached || { todayCost: 0, weeklyCost: 0, monthlyCost: 0 };
    }

    // ── 4. 出力（常に3行表示） ──
    process.stdout.write(buildLine1(input) + '\n');
    const line2 = buildLine2(usageData, isUsageStale);
    if (line2) process.stdout.write(line2 + '\n');
    process.stdout.write(buildLine3(input.sessionCost, costData) + '\n');

    // ── 5. reliable だが fresh でない場合は裏で非同期更新（通常の60秒/5分更新） ──
    const refreshJobs = [];

    if (!needsUsageRefresh && !isUsageCacheFresh(usageCache) && !isUsageInCooldown(usageCache)) {
      refreshJobs.push(fetchUsageLimits(usageCache));
    }

    if (!needsCostRefresh && !isCacheValid(costCache)) {
      refreshJobs.push((async () => {
        const data = scanAllFiles();
        writeCache(data);
      })());
    }

    if (refreshJobs.length > 0) {
      await Promise.all(refreshJobs).catch(() => {});
    }
  } catch (_) {}
}

main();
