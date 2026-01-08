---


# 📘 Solomon PDF Downloader – Reproducible Setup Guide

> **Purpose**
> This guide documents a repeatable, ethical process for downloading authenticated PDF resources from the Solomon (Moodle) platform using a headless browser and session cookies.


---

All good catch 👍 — this is exactly why writing a **proper wiki/process** matters.

Below is a **fully regenerated Step 1**, corrected and complete, with **ALL required system packages AND Puppeteer installation** included.

This **replaces the old Step 1 entirely**.
It is **GitHub-ready Markdown**, clean, copy-paste safe.

---

# 📘 Solomon PDF Downloader – Reproducible Setup Guide

## 📑 Table of Contents

* [Overview](#overview)
* [Assumptions](#assumptions)
* [Step 1 – System & Project Prerequisites](#step-1--system--project-prerequisites)
* [Step 2 – Obtain Fresh Authentication Cookies](#step-2--obtain-fresh-authentication-cookies)
* [Step 3 – Extract Resource URLs from a Course Page](#step-3--extract-resource-urls-from-a-course-page)
* [Step 4 – Test Download of a Single PDF](#step-4--test-download-of-a-single-pdf)

---

## Step 1 – System & Project Prerequisites

### 🎯 Goal

Prepare a **clean Kali Linux environment** capable of:

* Running Node.js
* Running Puppeteer (headless Chromium)
* Downloading authenticated PDFs from Moodle

This step ensures:

* All OS dependencies are installed
* Node.js + npm are available
* Puppeteer is installed **locally** in the project

---

## 1.1 Verify Node.js and npm

Run:

```bash
node --version
npm --version
```

✅ **Required versions**:

* Node.js ≥ **18**
* npm ≥ **9**

If missing or outdated:

```bash
sudo apt install -y nodejs npm
```

---

## 1.2 Install Chromium Runtime Dependencies (MANDATORY)

Puppeteer requires native libraries even in headless mode.

Run **exactly once**:

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

⚠️ Skipping this step causes:

* Chromium launch failures
* Silent Puppeteer crashes
* HTML instead of PDF downloads

---

## 1.3 Verify Project Directory

Your working directory **must not** be a shared filesystem
(e.g. `/mnt/hgfs`, `/mnt/c`, SMB, etc.).

Confirm location:

```bash
pwd
```

✅ Recommended:

```text
/home/<user>/Solomon
```

---

## 1.4 Install Project Dependencies (Puppeteer)

From the project directory:

```bash
cd ~/Solomon
npm install puppeteer
```

This installs:

* `puppeteer`
* Chromium binary
* Supporting Node dependencies

Expected result:

* `node_modules/` directory created
* No `ENOTSUP` or symlink errors

---

## 1.5 Verify Puppeteer Installation

Run:

```bash
node -e "require('puppeteer'); console.log('Puppeteer OK')"
```

Expected output:

```text
Puppeteer OK
```

---

## 1.6 Final Sanity Check

```bash
node -e "console.log('Node OK')"
```

Expected:

```text
Node OK
```

---

## ✅ Step 1 Completion Criteria

You may proceed **only if**:

* Node.js works
* npm works
* Puppeteer loads without error
* No missing shared library errors



---



## Step 2 – Obtain Fresh Authentication Cookies

### 🎯 Goal

Create a **Puppeteer-compatible `cookies.json`** file that:

* Authenticates you to Solomon (Moodle)
* Avoids Puppeteer parsing errors
* Can be reused until the session expires

⚠️ **Important:**
Browser-exported cookies are **NOT** directly usable.
They **must be reformatted** before use.

---

## 2.1 Log in to Solomon (Browser)

Using a normal browser (Firefox or Chrome):

1. Navigate to
   [https://solomon.ugle.org.uk/](https://solomon.ugle.org.uk/)
2. Log in normally
3. Confirm you can access enrolled courses (e.g. *First Degree*)

✅ Do **not** use private/incognito mode.

---

## 2.2 Install Cookie-Editor Extension

Install **Cookie-Editor**:

* Firefox: [https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/](https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/)
* Chrome: [https://chromewebstore.google.com/detail/cookie-editor](https://chromewebstore.google.com/detail/cookie-editor)

Reload the Solomon page after installing.

---

## 2.3 Export Cookies (JSON)

1. While on **[https://solomon.ugle.org.uk/](https://solomon.ugle.org.uk/)**
2. Open **Cookie-Editor**
3. Click **Export**
4. Select **JSON**
5. Save as:

```text
cookies.json
```

At this stage the file is **NOT ready yet**.

---

## 2.4 ⚠️ Critical Step – Reformat cookies.json for Puppeteer

### ❌ Problem: Default Export Is Incompatible

Cookie-Editor exports cookies with fields that **break Puppeteer**, such as:

* `partitionKey`
* `sameSite`
* `firstPartyDomain`
* `storeId`
* `hostOnly`
* `session`
* `expirationDate`

These fields cause:

* Puppeteer crashes
* Silent failures
* HTML downloads instead of PDFs

---

### ✅ Solution: Strip Cookies to Minimal Schema

Each cookie object **must contain only**:

| Field      | Required |
| ---------- | -------- |
| `name`     | ✅        |
| `value`    | ✅        |
| `domain`   | ✅        |
| `path`     | ✅        |
| `secure`   | ✅        |
| `httpOnly` | Optional |

---

### 2.4.1 Replace cookies.json with Sanitised Version

Edit the file:

```bash
nano ~/Solomon/cookies.json
```

Replace the contents with a **cleaned version** like this:

```json
[
  {
    "name": "MOODLEID1_",
    "value": "sodium%3AqnPlCgjRnIPzNMyqjRoseJoo1IQ7l9uH4ua2qYf3XJWPlUszr%2BrSzuCjND0L2iIovuJ1",
    "domain": "solomon.ugle.org.uk",
    "path": "/",
    "secure": true,
    "httpOnly": true
  },
  {
    "name": "AWSALBCORS",
    "value": "JS3/QPHpwkyoaEY/4Zlf+o0zSMmP6bShYegkWdJ+d9dxSFpxui46TJg5LGESTVEl02WPQJ9kAQskkEnJgAhGpojf1sEDtb2VcBmB7pfWFAtesdy86iL8W19STjmo",
    "domain": "solomon.ugle.org.uk",
    "path": "/",
    "secure": true
  },
  {
    "name": "AWSALB",
    "value": "JS3/QPHpwkyoaEY/4Zlf+o0zSMmP6bShYegkWdJ+d9dxSFpxui46TJg5LGESTVEl02WPQJ9kAQskkEnJgAhGpojf1sEDtb2VcBmB7pfWFAtesdy86iL8W19STjmo",
    "domain": "solomon.ugle.org.uk",
    "path": "/",
    "secure": false
  },
  {
    "name": "MoodleSession",
    "value": "7nm2i1en9qijqrmcms07nnndmj",
    "domain": "solomon.ugle.org.uk",
    "path": "/",
    "secure": true,
    "httpOnly": true
  }
]
```

> 🔑 **MoodleSession is mandatory**
> Without it, downloads will silently downgrade to HTML.

---

## 2.5 Verify cookies.json

Quick sanity check:

```bash
grep MoodleSession cookies.json
```

Expected output:

```text
"name": "MoodleSession"
```

If missing → **repeat Step 2.1–2.4**.

---

## ⏱️ Cookie Lifetime Notes

* Cookies are **session-based**
* Expire when:

  * You log out
  * Session times out
  * Moodle invalidates sessions
* Symptoms of expiry:

  * Files download but are HTML instead of PDF

➡️ When that happens, **repeat Step 2**.

---

Perfect. Here is **STEP 3 only**, written in **clean, copy-paste-ready GitHub Markdown**, continuing exactly from where we left off.

No assumptions skipped, no automation yet — this step is about **building the input list correctly**.

---



## Step 3 – Extract Resource URLs from a Course Page

### 🎯 Goal

Generate a clean `resource_urls.txt` file containing **only Moodle resource links** of the form:

```text
https://solomon.ugle.org.uk/mod/resource/view.php?id=XXXX
```

These URLs are the **inputs** to the downloader script.

---

## 3.1 Open the Target Course in Browser

In your browser (same one used for cookies):

1. Navigate to the course page
   Example (First Degree):

```
https://solomon.ugle.org.uk/course/view.php?id=79
```

2. Ensure:

   * You are logged in
   * All sections are expanded
   * PDFs are visible on the page

---

## 3.2 Save the Course Page HTML

This step freezes the page so links can be extracted reliably.

### Option A – Browser (recommended)

1. Right-click → **Save Page As**
2. Save as:

   ```text
   Solomon-FirstDegree.html
   ```
3. Copy the file into your Kali working directory:

```bash
cp /path/to/Solomon-FirstDegree.html ~/Solomon/
```

---

## 3.3 Extract Resource Links from HTML

From your working directory:

```bash
cd ~/Solomon
```

Run:

```bash
grep -oP 'https:\/\/solomon\.ugle\.org\.uk\/mod\/resource\/view\.php\?id=\d+' Solomon-FirstDegree.html \
  | sort -u > resource_urls.txt
```

### What this does:

* Finds **only** Moodle resource links
* Removes duplicates
* Outputs one URL per line

---

## 3.4 Verify resource_urls.txt

Inspect the file:

```bash
cat resource_urls.txt
```

Expected output example:

```text
https://solomon.ugle.org.uk/mod/resource/view.php?id=2301
https://solomon.ugle.org.uk/mod/resource/view.php?id=2302
https://solomon.ugle.org.uk/mod/resource/view.php?id=2303
```

Optional count check:

```bash
wc -l resource_urls.txt
```

---

## 3.5 Sanity Check (Single URL)

Before bulk downloading, confirm the first entry matches what you see in the browser:

```bash
head -n 1 resource_urls.txt
```

Manually open that link in your browser — it should:

* Belong to the correct course
* Point to a PDF resource

---





