---

# 📘 Solomon PDF Downloader – Reproducible Setup Guide

> **Purpose**
> This guide documents a repeatable, ethical process for downloading authenticated PDF resources from the Solomon (Moodle) platform using a headless browser and session cookies.

---

## 📑 Table of Contents

* [Overview](#overview)
* [Assumptions](#assumptions)
* [Step 1 – System Prerequisites](#step-1--system-prerequisites)

<!-- Future steps will be added incrementally -->

---

## Overview

We will:

* Authenticate using **browser-exported cookies**
* Use **Puppeteer (headless Chromium)** to behave like a real browser
* Extract **real PDF URLs** injected by Moodle
* Download **binary PDFs (not HTML)** reliably

⚠️ Cookies are **temporary** and must be refreshed periodically.

---

## Assumptions

* OS: **Kali Linux**
* Working directory: `~/Solomon`
* You already have:

  * `download-pdfs.js`
  * `cookies.json` (will be refreshed later)
  * `resource_urls.txt`

---

## Step 1 – System Prerequisites

### 🎯 Goal

Ensure the system has **Node.js, npm, and Puppeteer dependencies** installed correctly.

This step verifies that:

* Node.js works
* npm works
* Puppeteer can launch Chromium

---

### 1.1 Verify Node.js and npm

Run:

```bash
node --version
npm --version
```

✅ **Expected result**:

* Node.js ≥ **18**
* npm ≥ **9**

If either command fails or versions are too old, **stop here**.

---

### 1.2 Install required system libraries (Chromium dependencies)

Puppeteer requires native libraries even in headless mode.

Run:

```bash
sudo apt update
sudo apt install -y \
  libasound2 \
  libatk-bridge2.0-0 \
  libgtk-3-0 \
  libnss3 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  libgbm1 \
  libdrm2 \
  libxshmfence1
```

✅ These are **mandatory** — skipping them causes silent Chromium failures.

---

### 1.3 Install Node dependencies (local project)

From your project directory:

```bash
cd ~/Solomon
npm install
```

This installs:

* `puppeteer`
* Any locked dependencies from `package-lock.json`

✅ Expected result:

* No errors
* `node_modules/` directory created

---

### 1.4 Sanity check (no script execution yet)

Run:

```bash
node -e "console.log('Node OK')"
```

Expected output:

```
Node OK
```

---


