document.addEventListener("DOMContentLoaded", async function () {
	const resultsContainer = document.getElementById("search-results-container");
	const queryDisplay = document.getElementById("query-display");
	const searchInformation = document.getElementById("search-information");

	// Read query from URL
	const query = new URLSearchParams(window.location.search)
		.get("q")
		?.trim()
		.toLowerCase();

	if (!query) {
		if (searchInformation) {
			searchInformation.textContent = "No query. To search, enter a query in the search box in the footer.";
		}
		return;
	}

	// Display query
	if (queryDisplay) {
		queryDisplay.textContent = `Search results for "${query}"`;
	}

	// Load search_index.en.json
	let searchData = [];
	try {
		const response = await fetch("/search_index.en.json");
		searchData = await response.json();
	} catch (err) {
		console.error("Failed to load search index:", err);
		if (searchInformation) {
			searchInformation.textContent = "Failed to load search_index.en.json";
		}
		return;
	}

	const searchTerms = query.split(/\s+/).filter(t => t.length >= 2);
	// doc represents a single document in searchData
	const scoreDoc = doc => {
		let score = 0;

		for (const t of searchTerms) {
			const exact = arr => arr?.includes(t);
			const prefix = arr => arr?.some(w => w.startsWith(t));

			if (exact(doc.titleWords)) score += 12;
			else if (prefix(doc.titleWords)) score += 6;

			if (exact(doc.keywords)) score += 10;
			else if (prefix(doc.keywords)) score += 5;

			if (exact(doc.slugWords)) score += 8;
			else if (prefix(doc.slugWords)) score += 4;

			if (exact(doc.summaryWords)) score += 6;
			else if (prefix(doc.summaryWords)) score += 3;

			if (exact(doc.authorWords)) score += 6;
			if (prefix(doc.bodyWords)) score += 1;
		}
		return score;
	};

	const results = searchData
		.map(doc => ({ doc, score: scoreDoc(doc) }))
		.filter(r => r.score > 0)
		.sort((a, b) => b.score - a.score)
		.slice(0, 50)
		.map(r => r.doc);

	if (!resultsContainer) return;
	resultsContainer.innerHTML = "";

	if (!results.length) {
		if (searchInformation) {
			searchInformation.textContent = `No results found for "${query}"`;
		}
	} else {

		const highlight = (text) => {
			let out = text;
			for (const t of searchTerms) {
				out = out.replace(
					new RegExp(`\\b(${t}\\w*)\\b`, "gi"),
					"<mark>$1</mark>"
				);
			}
			return out;
		};

		const makeSnippet = (text) => {
			if (!text) return "";

			const lower = text.toLowerCase();

			let matchPos = -1;

			for (const term of searchTerms) {
				matchPos = lower.indexOf(term);

				if (matchPos !== -1) {
					break;
				}
			}

			if (matchPos === -1) {
				return text.substring(0, 500);
			}

			const start = Math.max(0, matchPos - 250);
			const end = Math.min(text.length, matchPos + 250);

			return (
				(start > 0 ? "…" : "") +
				text.substring(start, end) +
				(end < text.length ? "…" : "")
			);
		};

		results.forEach(doc => {
			const cloneResult = 
				document.getElementById("search-result-template").content.cloneNode(true);
			const content = `${doc.summary || ""} ${doc.body || ""}`;
			const snippetText = makeSnippet(content);
			const snippetElement = cloneResult.querySelector(".result-snippet");
			if (snippetText) {
				snippetElement.innerHTML = highlight(snippetText);
			} else {
				snippetElement.textContent =
					"No excerpt containing search results available. Click link to go to full page.";
			}
			// cloneResult.querySelector(".result-snippet").innerHTML = highlight(snippetText) || "No excerpt containing search results available. Click link to go to full page.";
			cloneResult.querySelector(".result-link").href = doc.url || "#";
			cloneResult.querySelector(".result-link").textContent = 
				doc.title || "No title";

			resultsContainer.appendChild(cloneResult);
		});
	}
});
