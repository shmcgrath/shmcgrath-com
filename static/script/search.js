document.addEventListener("DOMContentLoaded", async function () {
	const resultsContainer = document.getElementById("search-results-list");
	const queryDisplay = document.getElementById("query-display");
	const searchInformation = document.getElementById("search-information");

	// Read query from URL
	const query = new URLSearchParams(window.location.search)
		.get("q")
		?.trim()
		.toLowerCase();

	if (!query) {
		if (searchInformation) {
				searchInformation.textContent = "No query. To search, enter a query.";
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
		} else {
			resultsContainer.innerHTML = `<li>No results found for "${query}"</li>`;
		}
	} else {

		console.log(results);

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

		results.forEach(doc => {
			const li = document.createElement("li");
			const a = document.createElement("a");

			a.href = doc.url || "#";
			a.innerHTML = highlight(doc.title || "No title");
			li.appendChild(a);

			const snippetText = (doc.summary || doc.body || "").substring(0, 500);
			if (snippetText) {
				const snippetWords = snippetText.toLowerCase().split(/\s+/).filter(Boolean);
				const snippet = document.createElement("p");
				snippet.innerHTML = highlight(snippetText) + ((doc.summary || doc.body || "").length > 200 ? "…" : "");

				li.appendChild(snippet);
			}
			resultsContainer.appendChild(li);
		});
	}
});
