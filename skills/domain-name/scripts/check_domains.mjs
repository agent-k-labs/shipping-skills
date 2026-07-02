#!/usr/bin/env node
/**
 * check_domains.mjs — batch domain availability (and optional pricing) checker.
 *
 * Availability: RDAP, resolved per-TLD via the IANA bootstrap registry (free, no
 *               API key). HTTP 404 from the registry's RDAP = unregistered.
 *               TLDs with no RDAP service (some ccTLDs) fall back to a DNS NS
 *               lookup via the system resolver: NS records = taken, NXDOMAIN =
 *               likely available (registrar confirmation still needed).
 * Pricing:      Cloudflare Registrar API (beta) when CLOUDFLARE_API_TOKEN and
 *               CLOUDFLARE_ACCOUNT_ID are set. Falls back to RDAP-only otherwise.
 *
 * Usage:
 *   node check_domains.mjs taskflow shipfast              # bare names × default TLDs
 *   node check_domains.mjs taskflow.com getship.app       # exact domains
 *   node check_domains.mjs taskflow --tlds com,io,ai      # custom TLD set
 *   node check_domains.mjs taskflow --json                # machine-readable output
 */

import { promises as dns } from "node:dns";

const DEFAULT_TLDS = ["com", "app", "io", "dev", "ai", "co"];
const IANA_BOOTSTRAP = "https://data.iana.org/rdap/dns.json";
const CF_API = "https://api.cloudflare.com/client/v4";
const CONCURRENCY = 4;

function parseArgs(argv) {
  const names = [];
  let tlds = DEFAULT_TLDS;
  let json = false;
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--tlds") {
      const val = argv[++i];
      if (!val) die("--tlds requires a comma-separated list, e.g. --tlds com,io,ai");
      tlds = val.split(",").map((t) => t.trim().replace(/^\./, "")).filter(Boolean);
    } else if (a === "--json") {
      json = true;
    } else if (a.startsWith("--")) {
      die(`Unknown flag: ${a}`);
    } else {
      names.push(a.toLowerCase());
    }
  }
  if (names.length === 0) {
    die(
      "No names given.\nUsage: node check_domains.mjs <name|domain> [...] [--tlds com,io,ai] [--json]"
    );
  }
  const domains = [];
  for (const n of names) {
    if (n.includes(".")) domains.push(n);
    else for (const t of tlds) domains.push(`${n}.${t}`);
  }
  return { domains: [...new Set(domains)], json };
}

function die(msg) {
  console.error(msg);
  process.exit(1);
}

/** tld -> RDAP base URL, from the IANA bootstrap registry. */
async function loadRdapBootstrap() {
  try {
    const res = await fetch(IANA_BOOTSTRAP);
    if (!res.ok) return null;
    const data = await res.json();
    const map = new Map();
    for (const [tlds, urls] of data.services ?? []) {
      const base = urls.find((u) => u.startsWith("https://")) ?? urls[0];
      for (const t of tlds) map.set(t.toLowerCase(), base.endsWith("/") ? base : base + "/");
    }
    return map;
  } catch {
    return null;
  }
}

async function rdapCheck(domain, base) {
  try {
    const res = await fetch(`${base}domain/${encodeURIComponent(domain)}`, {
      headers: { accept: "application/rdap+json" },
      redirect: "follow",
    });
    if (res.status === 404) return { domain, status: "available" };
    if (res.ok) {
      let registered = "";
      try {
        const data = await res.json();
        const reg = (data.events || []).find((e) => e.eventAction === "registration");
        if (reg?.eventDate) registered = reg.eventDate.slice(0, 10);
      } catch {
        /* body parse is best-effort */
      }
      return { domain, status: "taken", registered };
    }
    return dnsCheck(domain, `RDAP HTTP ${res.status}`);
  } catch (err) {
    return dnsCheck(domain, `RDAP error: ${err.message}`);
  }
}

/** Fallback for TLDs without RDAP: NS lookup via the system resolver. */
async function dnsCheck(domain, why) {
  try {
    const ns = await dns.resolveNs(domain);
    if (ns.length > 0) return { domain, status: "taken", note: `${why}; has NS records` };
    return { domain, status: "unknown", note: `${why}; DNS inconclusive — check manually` };
  } catch (err) {
    if (err.code === "ENOTFOUND") {
      return { domain, status: "likely available", note: `${why}; NXDOMAIN — confirm at a registrar` };
    }
    if (err.code === "ENODATA" || err.code === "ESERVFAIL") {
      return { domain, status: "taken", note: `${why}; domain exists in DNS (${err.code})` };
    }
    return { domain, status: "unknown", note: `${why}; DNS error: ${err.code || err.message}` };
  }
}

async function cloudflarePricing(domains, token, accountId) {
  const results = new Map();
  for (let i = 0; i < domains.length; i += 20) {
    const batch = domains.slice(i, i + 20);
    const res = await fetch(`${CF_API}/accounts/${accountId}/registrar/domain-check`, {
      method: "POST",
      headers: {
        authorization: `Bearer ${token}`,
        "content-type": "application/json",
      },
      body: JSON.stringify({ domains: batch }),
    });
    if (!res.ok) {
      const body = await res.text();
      console.error(
        `Cloudflare domain-check failed (HTTP ${res.status}) — continuing with RDAP only.\n${body.slice(0, 300)}`
      );
      return results;
    }
    const data = await res.json();
    for (const d of data.result?.domains ?? []) {
      results.set(d.name, {
        registrable: d.registrable,
        tier: d.tier,
        reason: d.reason,
        registration: d.pricing ? `$${d.pricing.registration_cost}` : "",
        renewal: d.pricing ? `$${d.pricing.renewal_cost}` : "",
      });
    }
  }
  return results;
}

async function mapWithConcurrency(items, limit, fn) {
  const out = new Array(items.length);
  let next = 0;
  await Promise.all(
    Array.from({ length: Math.min(limit, items.length) }, async () => {
      while (next < items.length) {
        const i = next++;
        out[i] = await fn(items[i]);
      }
    })
  );
  return out;
}

const { domains, json } = parseArgs(process.argv.slice(2));

const bootstrap = await loadRdapBootstrap();
if (!bootstrap && !json) {
  console.error("Could not load the IANA RDAP bootstrap — falling back to DNS checks only.\n");
}

const rdapResults = await mapWithConcurrency(domains, CONCURRENCY, (domain) => {
  const tld = domain.split(".").pop();
  const base = bootstrap?.get(tld);
  return base ? rdapCheck(domain, base) : dnsCheck(domain, `no RDAP service for .${tld}`);
});

const token = process.env.CLOUDFLARE_API_TOKEN;
const accountId = process.env.CLOUDFLARE_ACCOUNT_ID;
let pricing = new Map();
if (token && accountId) {
  pricing = await cloudflarePricing(domains, token, accountId);
} else if (!json) {
  console.error(
    "Tip: set CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID for live registration pricing.\n"
  );
}

const rows = rdapResults.map((r) => {
  const p = pricing.get(r.domain);
  let status = r.status;
  if (p) {
    if (p.registrable) status = "available";
    else if (r.status === "available" || r.status === "likely available") status = "unregistrable";
  }
  return {
    domain: r.domain,
    status,
    registered: r.registered || "",
    note: p?.reason || r.note || "",
    registration: p?.registration || "",
    renewal: p?.renewal || "",
    tier: p?.tier || "",
  };
});

if (json) {
  console.log(JSON.stringify(rows, null, 2));
} else {
  const hasPricing = pricing.size > 0;
  const header = ["DOMAIN", "STATUS", ...(hasPricing ? ["PRICE", "RENEWAL"] : []), "NOTES"];
  const table = rows.map((r) => [
    r.domain,
    r.status,
    ...(hasPricing ? [r.registration, r.renewal] : []),
    [r.registered && `registered ${r.registered}`, r.note, r.tier === "premium" && "PREMIUM"]
      .filter(Boolean)
      .join("; "),
  ]);
  const widths = header.map((h, i) => Math.max(h.length, ...table.map((row) => row[i].length)));
  const fmt = (row) => row.map((c, i) => c.padEnd(widths[i])).join("  ");
  console.log(fmt(header));
  console.log(fmt(widths.map((w) => "-".repeat(w))));
  for (const row of table) console.log(fmt(row));
  const available = rows.filter((r) => r.status === "available").length;
  const likely = rows.filter((r) => r.status === "likely available").length;
  console.log(`\n${available} available, ${likely} likely available (of ${rows.length} checked)`);
  if (likely > 0) {
    console.log("'likely available' = no RDAP for that TLD; NXDOMAIN in DNS — confirm at a registrar before celebrating.");
  }
}
