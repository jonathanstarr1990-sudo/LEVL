---
date: 2026-06-23
tags: [LEVL, dev-log, automation, make-com, brevo, netlify, site-build]
project: LEVL
status: complete
---

# LEVL Development Log — June 2026

## What Was Built This Session

### 1. Three New Standalone Pages
All match the full LEVL design system (dark surface, amber accent, Inter/Fraunces fonts).

| File | URL | Purpose |
|---|---|---|
| `privacy.html` | joinlevl.com/privacy.html | Privacy Policy — plain English, validation-stage appropriate |
| `terms.html` | joinlevl.com/terms.html | Terms of Use — IP, liability, governing law |
| `contact.html` | joinlevl.com/contact.html | Three contact cards (General / Partnerships / Investment) |

All route to `hello@joinlevl.com` with appropriate mailto subject lines.

### 2. index.html Footer Links Updated
Footer links changed from `mailto:` placeholders to the new dedicated pages:
- Privacy → `privacy.html`
- Terms → `terms.html`
- Contact → `contact.html`

All four files committed and pushed to `gh-pages` branch.

---

## Make.com Confirmation Email Automation

### Scenario Structure
```
Netlify form submission
  → Netlify outgoing webhook
    → Make.com custom webhook (trigger)
      → Router (4 paths, filtered by role)
        → Path 1: summary = creator  → Brevo: Send an Email (Creator template)
        → Path 2: summary = manager  → Brevo: Send an Email (Manager template)
        → Path 3: summary = sponsor  → Brevo: Send an Email (Sponsor template)
        → Path 4: summary = investor → Brevo: Send an Email (Investor template)
```

### Key Variable Mappings (from Netlify webhook payload)
| Make.com Variable | Form Field | Example |
|---|---|---|
| `{{1.email}}` | Email address | user@example.com |
| `{{1.first_name}}` | First name | Maya |
| `{{1.last_name}}` | Last name | Chen |
| `{{1.summary}}` | Role selection | creator / manager / sponsor / investor |

> **Note:** Netlify maps the `role` hidden field to `summary` in the webhook payload. Always filter on `{{1.summary}}` not `{{1.role}}`.

### Brevo Setup
- **Sender name:** LEVL
- **Sender email:** hello@joinlevl.com (verified)
- **Reply-to:** hello@joinlevl.com
- **Connection:** "My Brevo connection" (API key-based)
- **Scenario toggle:** On / "Immediately as data arrives"

### Email Subjects
| Role | Subject |
|---|---|
| Creator | You're on the LEVL waitlist, {{1.first_name}} |
| Manager | You're on the LEVL waitlist, {{1.first_name}} |
| Sponsor | You're on the LEVL waitlist, {{1.first_name}} |
| Investor | Thanks for your interest, {{1.first_name}} |

### Signature Block (all templates)
```
The LEVL Team
hello@joinlevl.com
```

---

## DNS Records Added (joinlevl.com via 123 Reg)

| Type | Name | Value | Purpose |
|---|---|---|---|
| CNAME | `brevo1._domainkey` | `b1.joinlevl-com.dkim.brevo.com` | DKIM signing (Brevo) |
| CNAME | `brevo2._domainkey` | `b2.joinlevl-com.dkim.brevo.com` | DKIM signing (Brevo) |

> Brevo code TXT and DMARC records were already present and verified.

---

## Infrastructure Overview

| Service | Purpose | Notes |
|---|---|---|
| Netlify | Site hosting + form capture | `magical-gelato-35ef32.netlify.app` |
| GitHub Pages (`gh-pages` branch) | Source of truth for HTML files | jonathanstarr1990-sudo/LEVL |
| 123 Reg | Domain registrar + email hosting | joinlevl.com / hello@joinlevl.com |
| Brevo | Transactional email sending | Free tier — 300 emails/day |
| Make.com | Automation layer | Free tier — 1,000 ops/month |
| Microsoft Clarity | Analytics | ID: x20xfzeqbp |

---

## Site File Structure

```
LEVL/
├── index.html              — Homepage (platform, trust, waitlist)
├── trust-framework.html    — LEVL Trust Framework detail page
├── levl-investor-brief.html — 5-tab investor brief
├── privacy.html            — Privacy Policy (NEW)
├── terms.html              — Terms of Use (NEW)
└── contact.html            — Contact page (NEW)
```

### Design System (CSS custom properties)
```css
--amber: #F59E0B
--amber2: #FBBF24
--green: #10B981
--violet: #7C3AED
--surface: #0C0C1A
--surface2: #101020
--t1: #F5F3EE
--t2: rgba(245,243,238,0.62)
--t3: rgba(245,243,238,0.30)
--border: rgba(245,158,11,0.14)
--border2: rgba(245,243,238,0.07)
--sans: 'Inter'
--display: 'Fraunces'
--mono: 'DM Mono'
```

---

## Company Details (for footers / disclosures)

> LEVL is a product of **Nexum Growth Labs Ltd.**
> Company No. **16967326**, registered in England & Wales.
> Contact: hello@joinlevl.com
> Companies House: https://find-and-update.company-information.service.gov.uk/company/16967326

---

## Waitlist Form Fields

| Field name | Type | Notes |
|---|---|---|
| `role` | Hidden | Set by JS button click: creator/manager/sponsor/investor |
| `first_name` | Text | Required |
| `last_name` | Text | Required |
| `email` | Email | Required |
| `primary_platform` | Select | Options change per role |
| `audience_size` | Select | Options change per role (label also changes) |
| `bot-field` | Hidden honeypot | Netlify spam filter |

---

## Previous Session Work (Summary)

### Homepage (index.html)
- Explore LEVL section — 3 cards (Platform / Trust Framework / Investor Brief)
- Investor section before waitlist
- Removed duplicate "How LEVL Works" strip
- Ticker constrained to content width (`.ticker-outer`)
- Mobile centering fixes throughout
- CTA language: "See the Platform", "View Platform Preview"
- Scroll reveal: threshold 0, rootMargin, above-fold immediate reveal
- Logo click → scrolls to top (JS)
- Back-to-top button (JS-injected)
- Footer: company disclosure, copyright

### Trust Framework (trust-framework.html)
- Added footer with company disclosure
- Logo click → returns to index.html

### Investor Brief (levl-investor-brief.html)
- Added Network-Led Growth section
- Added footer with company disclosure
- Logo click → returns to index.html

---

## Outstanding / Next Steps

- [ ] Set up Obsidian auto-log hook for future sessions
- [ ] Monitor Make.com scenario for any delivery failures (check execution history weekly)
- [ ] Consider full Brevo domain verification (SPF/DKIM) once volume increases for better deliverability
- [ ] Validate all 4 role confirmation emails periodically by test-submitting the form
- [ ] Consider adding an unsubscribe mechanism to confirmation emails before scaling

---

## Funding Context (for reference)

**Validation stage** — not currently raising.
- Validation target: £5K–£15K
- Seed target: £500K–£1M
- Series A target: £3.5M

Do not position as venture-backed. Honesty over polish.
