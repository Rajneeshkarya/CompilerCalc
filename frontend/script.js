// Grab DOM elements
const sourceCodeEl = document.getElementById('sourceCode');
const submitBtn = document.getElementById('submitBtn');
const loadingIndicator = document.getElementById('loadingIndicator');
const lexicalOutput = document.getElementById('lexicalOutput');
const parseTreeOutput = document.getElementById('parseTreeOutput');
const finalOutput = document.getElementById('finalOutput');

// Show loading state
function setLoading(isLoading) {
  if (isLoading) {
    submitBtn.disabled = true;
    loadingIndicator.classList.remove('hidden');
  } else {
    submitBtn.disabled = false;
    loadingIndicator.classList.add('hidden');
  }
}

// Clear previous results
function clearResults() {
  lexicalOutput.textContent = '';
  parseTreeOutput.textContent = '';
  finalOutput.textContent = '';
}

// Handle form submission
submitBtn.addEventListener('click', async () => {
  const code = sourceCodeEl.value.trim();

  if (!code) {
    alert('Please enter some code');
    return;
  }

  clearResults();
  setLoading(true);

  try {
    const response = await fetch('/compile', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ code })
    });

    if (!response.ok) {
      throw new Error(`Server error: ${response.status}`);
    }

    const data = await response.json();
    lexicalOutput.textContent = data.lexical;
    parseTreeOutput.textContent = data.parseTree;
    finalOutput.textContent = data.output;
  } catch (err) {
    console.error(err);
    alert('An error occurred while processing your code.');
  } finally {
    setLoading(false);
  }
});