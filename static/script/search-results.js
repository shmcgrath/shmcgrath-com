document.addEventListener("DOMContentLoaded", async function() {
	const resultsContainer = document.getElementById('searchResults');
	const queryDisplay = document.getElementById('queryDisplay');

    // Read query from URL
    const params = new URLSearchParams(window.location.search);
    const query = params.get('q') || '';

	// Display the query in the div
	if (queryDisplay) {
		queryDisplay.textContent = `Search results for "${query}"`;
	}

    // Load JSON data
    const response = await fetch('/search_index.en.json');
    const searchData = await response.json();

    // Configure Fuse.js
    const fuse = new Fuse(searchData, {
				keys: [
						{ name: "title", weight: 0.5 },
						{ name: "body", weight: 0.5 },
						{ name: "description", weight: 0.1 },
						{ name: "slug", weight: 0.05 },
						{ name: "author", weight: 0.05 },
						{ name: "url", weight: 0.01 },
						{ name: "keywords", weight: 0.9 }
				],
        threshold: 0.6,
        includeScore: true
    });

    // Perform search
    const results = query ? fuse.search(query).slice(0, 50) : [];
		console.log(results);

    if (results.length === 0) {
        resultsContainer.innerHTML = `<li>No results found for "${query}"</li>`;
    } else {
        results.forEach(r => {
						console.log(r);
            const li = document.createElement('li');
						const a = document.createElement('a');
            const url = r.item.url || '#'; // optional link field
						a.href = url;
            const title = r.item.title || 'No title';
						a.textContent = title;
						li.appendChild(a);
            resultsContainer.appendChild(li);
        });
    }
});
