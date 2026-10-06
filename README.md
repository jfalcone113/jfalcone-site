# A thoughtful portfolio — Quarto starter

A five-page portfolio with warm ivory backgrounds, charcoal typography, burnt-orange accents, and responsive layouts. Built with Quarto, plain CSS, and a small inline resource filter. No R, Python, npm, remote fonts, or image downloads are needed to build it.

## Start here

Install Quarto from https://quarto.org/docs/get-started/ if needed. Open a terminal in this folder and run:

```sh
quarto preview
```

Build the complete site for publication:

```sh
quarto render
```

Quarto puts the generated website in `_site/`. Publish that whole directory with your preferred static-site host. Use `quarto preview` to test search locally; opening HTML directly from your file browser may restrict browser features.

## Files

| File | Purpose |
| --- | --- |
| `index.qmd` | Home: greeting, introduction, and paths into the site |
| `projects.qmd` | Three sample project cards with expandable case-study outlines |
| `resume.qmd` | Detailed resume, section links, and Print / save as PDF button |
| `contact.qmd` | Email, LinkedIn, GitHub, and location |
| `resources.qmd` | Three usable learning templates, live search, and category filter |
| `styles.css` | All custom design, mobile layouts, and print styles |
| `_quarto.yml` | Site navigation, search, metadata, and footer |

Keep the files together. `index.qmd` is the Home page because static hosts use `index.html` as their landing page.

## Make it yours

1. Replace `Your Name`, `YOUR-USERNAME`, `your.name@example.com`, and bracketed prompts throughout the files. Contact links are placeholders and need your actual details. Example projects are explicitly labeled; replace these before publishing.
2. Edit your positioning and introduction in `index.qmd`. The sample voice is deliberately broad so it can suit different disciplines.
3. Replace project titles, descriptions, tags, and outline prompts in `projects.qmd`. Duplicate an entire `project-card` block to add a project, with a unique ID. Decorative artwork is CSS; you can replace a `project-art` block with an image of your work.
4. Fill in `resume.qmd`, and delete irrelevant sections. The print button opens the browser print dialog, where viewers can choose Save as PDF. To offer a prepared PDF, create `files/resume.pdf` and uncomment the example download link.
5. Edit the resource cards in `resources.qmd`. Each has a unique ID and a `data-category` value (`study`, `documents`, or `collections`). Duplicate a card to add more. To add a category, add a matching `<option>` to the category select. Search reads all card text, including collapsed details. With JavaScript disabled, every card stays readable.
6. Edit the color tokens at the start of `styles.css`. Fonts use the visitor's installed system fonts; no external font service is required.
7. Set `site-url` in `_quarto.yml` when you know the final public address, and update the footer.

The main content uses Markdown and Quarto fenced divs (`:::`). Keep opening and closing div fences paired when editing. Each page already includes a custom visible H1; CSS hides Quarto's automatic title block to avoid duplicate page titles.

## Add downloadable resources

Create a `files/` directory, add your PDF or other document, and link it from a card:

```markdown
[Download the study sheet ↓](files/study-sheet.pdf)
```

Quarto copies linked local resources into the rendered site. For unlinked files you also want to publish, add `resources: [files/**]` under `project` in `_quarto.yml`. Only link to files you have actually added. Commented examples in this starter are not active download links.

## Design and accessibility

- Responsive navigation and layouts for mobile, tablet, and desktop.
- Visible keyboard focus, semantic headings, labeled filters, and native expandable details.
- Resource result counts announced to assistive technology, with a no-results state.
- Reduced-motion support and resume print styling.
- Decorative illustrations are hidden from assistive technology; add descriptive alt text to meaningful replacement images.
- Built-in Quarto site search is separate from the Resources page filter.

Test your real content at narrow widths and in print preview after personalizing it, especially long names, URLs, and resume sections.

## Quarto references

- [Website configuration](https://quarto.org/docs/websites/)
- [Website navigation](https://quarto.org/docs/websites/website-navigation.html)
- [HTML theming](https://quarto.org/docs/output-formats/html-themes.html)
