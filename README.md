# loganlabarge.github.io

Personal website of Logan LaBarge, served free by GitHub Pages at
**https://loganlabarge.github.io/**.

Plain HTML and CSS: no build step, no frameworks, no web fonts, no paid services.

| File | Purpose |
|---|---|
| `index.html` | The whole site: content, SEO tags, Open Graph tags, JSON-LD structured data |
| `assets/styles.css` | Styles (light and dark mode, mobile layout) |
| `assets/og-image.png` | 1200x630 card shown when the link is shared |
| `assets/favicon.*`, `apple-touch-icon.png` | Browser and phone icons |
| `robots.txt` | Lets every crawler in (search engines and AI search) and points to the sitemap |
| `sitemap.xml` | The page list for Google and Bing; update `<lastmod>` when the content changes |
| `404.html` | "Page not found" page |
| `.nojekyll` | Tells GitHub Pages to serve the files as-is |
| `tools/check-before-publish.ps1` | Fails while any placeholder or unconfirmed draft is left |
| `tools/make-images.ps1` | Regenerates the share card and icons |

## Before publishing

```powershell
powershell -ExecutionPolicy Bypass -File tools\check-before-publish.ps1
```

It must print `READY`. Yellow `TODO` boxes are information only Logan can supply; dashed
"Draft: please check" boxes are wording to confirm, rewrite or delete (then remove the
`draft` class).

## Publishing (one-time)

GitHub Pages on a free account needs a **public** repository, so everything in this folder
becomes public.

1. Open **GitHub Desktop**, then **File > Add local repository** and choose this folder.
2. Commit any changes, then click **Publish repository**.
   - Name: `loganlabarge.github.io` (it must match exactly, or the address changes)
   - **Untick "Keep this code private."**
3. On github.com open the repo, then **Settings > Pages**. Under *Build and deployment*, set
   Source = *Deploy from a branch*, Branch = `main`, folder `/ (root)`, and save.
4. After about a minute the site is live at https://loganlabarge.github.io/.

Updates later: edit, commit in GitHub Desktop, then **Push origin**. The site refreshes
within about a minute.

## Google Search Console (free)

1. Go to https://search.google.com/search-console and sign in with your Google account.
2. **Add property**, then choose **URL prefix** (not "Domain", which needs your own domain),
   and enter `https://loganlabarge.github.io/`.
3. Choose the **HTML tag** method and copy the `<meta name="google-site-verification" ...>` tag.
4. Paste it into `index.html` where the comment says so, commit, and push. Wait a minute,
   then click **Verify**.
5. Go to **Sitemaps**, submit `sitemap.xml`, then use **URL inspection** on the homepage and
   click **Request indexing**.

Keep the meta tag in the page forever; removing it un-verifies the property.

## Bing Webmaster Tools (free; this also feeds ChatGPT Search and Copilot)

1. Go to https://www.bing.com/webmasters and sign in.
2. Choose **Import from Google Search Console** (fastest), or add the site and use the
   `msvalidate.01` meta tag the same way as Google's.
3. Submit `https://loganlabarge.github.io/sitemap.xml`.

## Checking the SEO after it's live

- Structured data: https://search.google.com/test/rich-results and https://validator.schema.org/
- Share card: paste the URL into a LinkedIn post draft, or use https://www.opengraph.xyz/
- Speed and accessibility: https://pagespeed.web.dev/

Indexing usually takes days to a few weeks. Linking to this site from your LinkedIn, GitHub
profile and any game pages (and listing those profiles in the JSON-LD `sameAs`) is what
helps search engines connect them to the same Logan LaBarge.
